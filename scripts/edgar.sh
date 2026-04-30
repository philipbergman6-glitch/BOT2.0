#!/usr/bin/env bash
# SEC EDGAR wrapper — public Form 4 (insider) data. No auth, 10 req/sec, UA required.
# Usage: bash scripts/edgar.sh form4 CIK_OR_TICKER
#        bash scripts/edgar.sh cluster TICKER DAYS
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

UA="${EDGAR_USER_AGENT:-BOT2.0 philip.bergman6@gmail.com}"

cmd="${1:-}"
shift || true

case "$cmd" in
  form4)
    target="${1:?usage: form4 CIK_OR_TICKER}"
    python3 - "$target" "$UA" <<'PY'
import json, subprocess, sys
target, ua = sys.argv[1], sys.argv[2]
def get(url):
    return subprocess.check_output(['curl', '-fsS', '-A', ua, url])
if target.isdigit():
    cik_int = int(target)
else:
    tk = json.loads(get("https://www.sec.gov/files/company_tickers.json"))
    m = next((v for v in tk.values() if v['ticker'].upper() == target.upper()), None)
    if not m:
        print(f"ticker {target} not found", file=sys.stderr); sys.exit(2)
    cik_int = int(m['cik_str'])
sub = json.loads(get(f"https://data.sec.gov/submissions/CIK{cik_int:010d}.json"))
r = sub['filings']['recent']
def xml_path(doc):
    # primaryDocument is the XSL-rendered HTML view (e.g. "xslF345X06/form4.xml");
    # raw XML lives at the parent path.
    return doc.split('/', 1)[1] if doc.startswith('xsl') and '/' in doc else doc
out = []
for i, f in enumerate(r['form']):
    if f != '4':
        continue
    acc = r['accessionNumber'][i].replace('-', '')
    base = f"https://www.sec.gov/Archives/edgar/data/{cik_int}/{acc}"
    out.append({'accession': r['accessionNumber'][i], 'date': r['filingDate'][i],
                'xml_url': f"{base}/{xml_path(r['primaryDocument'][i])}",
                'view_url': f"{base}/{r['primaryDocument'][i]}"})
print(json.dumps(out, indent=2))
PY
    ;;
  cluster)
    sym="${1:?usage: cluster TICKER DAYS}"
    days="${2:?usage: cluster TICKER DAYS}"
    python3 - "$sym" "$days" "$UA" <<'PY'
import json, subprocess, sys
from datetime import date, timedelta
import xml.etree.ElementTree as ET
sym, days, ua = sys.argv[1], int(sys.argv[2]), sys.argv[3]
def get(url):
    return subprocess.check_output(['curl', '-fsS', '-A', ua, url])
tk = json.loads(get("https://www.sec.gov/files/company_tickers.json"))
m = next((v for v in tk.values() if v['ticker'].upper() == sym.upper()), None)
if not m:
    print(f"ticker {sym} not found", file=sys.stderr); sys.exit(2)
cik_int = int(m['cik_str'])
sub = json.loads(get(f"https://data.sec.gov/submissions/CIK{cik_int:010d}.json"))
cutoff = date.today() - timedelta(days=days)
r = sub['filings']['recent']
total, insiders = 0.0, set()
for i, form in enumerate(r['form']):
    if form != '4' or date.fromisoformat(r['filingDate'][i]) < cutoff:
        continue
    acc = r['accessionNumber'][i].replace('-', '')
    doc = r['primaryDocument'][i]
    if doc.startswith('xsl') and '/' in doc:
        doc = doc.split('/', 1)[1]
    try:
        root = ET.fromstring(get(f"https://www.sec.gov/Archives/edgar/data/{cik_int}/{acc}/{doc}"))
    except Exception:
        continue
    name = (root.findtext('.//rptOwnerName') or 'unknown').strip()
    bought = False
    for tx in root.findall('.//nonDerivativeTransaction'):
        if (tx.findtext('.//transactionCode') or '').strip() != 'P':
            continue
        shares = float(tx.findtext('.//transactionShares/value') or 0)
        price = float(tx.findtext('.//transactionPricePerShare/value') or 0)
        total += shares * price
        bought = True
    if bought:
        insiders.add(name)
print(json.dumps({'ticker': sym.upper(), 'days': days,
                  'distinct_insiders': len(insiders),
                  'total_value_usd': round(total, 2),
                  'insiders': sorted(insiders)}, indent=2))
PY
    ;;
  *)
    echo "Usage: bash scripts/edgar.sh <form4 CIK_OR_TICKER|cluster TICKER DAYS>" >&2
    exit 1
    ;;
esac
echo

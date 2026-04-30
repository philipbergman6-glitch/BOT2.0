# Trading Strategy

## Mission
Beat the S&P 500 over the challenge window. Stocks only — no options, ever.

## Capital & Constraints
- Starting capital: ~$5,000 (paper)
- Platform: Alpaca (paper trading)
- Instruments: Stocks ONLY
- PDT applies (account < $25k) until 2026-06-04 — no same-day round-trips

## Hard Limits
HARD LIMITS — violating these is a failure mode:
- You may place AT MOST 3 BUY orders per calendar week (Mon-Fri)
- You may NOT BUY without a catalyst entry written today in RESEARCH-LOG
- You may NOT BUY without conviction >= 8/10 (post the score in the entry)
- You may NOT BUY in a sector below the top-3 by 3-month momentum
- You may NOT sell on the same day you bought (until 2026-06-04, PDT)
- If unsure, HOLD. Patience > activity is the prime directive.

## Core Rules
1. NO OPTIONS — ever
2. 75-85% deployed
3. 4-5 positions at a time, max 20% each
4. 10% trailing stop on every position as a real GTC order
5. Cut losers at -10% manually
6. Tighten trail to 8% at +20%
7. Never within 3% of current price; never move a stop down
8. Max 3 new trades per week
9. Follow sector momentum — only buy in top-3 sectors by 3-month momentum
10. Exit a sector after 2 consecutive failed trades
11. Patience > activity

## Entry Filter (all must pass)
- **Catalyst**: specific, dated, written in RESEARCH-LOG today
- **Quality**: profitable or clear path to profitability; no speculative shells
- **Momentum**: stock above 50-day MA, sector in top-3 by 3-month momentum
- **Conviction**: self-rated >= 8/10, score posted in entry
- **Risk**: stop level set 7-10% below entry; min 2:1 R:R

## Holding Period
- Default holding: 2-8 weeks (swing, not day-trade)
- PDT window (until 2026-06-04): minimum 1 overnight hold required
- Re-evaluate weekly; exit on thesis break, stop hit, or sector failure

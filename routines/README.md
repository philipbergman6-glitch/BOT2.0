# Cloud Routine Prompts

Paste each of these verbatim into its Claude Code cloud routine. Do not
paraphrase. The env-var check block and the commit-and-push step are
load-bearing.

## Cron schedules (America/Chicago)

| Routine name | Cron            | File                |
|--------------|-----------------|---------------------|
| BOT2.0-1P    | `0 6 * * 1-5`   | `pre-market.md`     |
| BOT2.0-2M    | `36 8 * * 1-5`  | `market-open.md`    |
| BOT2.0-3mid  | `20 12 * * 1-5` | `midday.md`         |
| BOT2.0-4D    | `30 15 * * 1-5` | `daily-summary.md`  |
| BOT2.0-5W    | `20 16 * * 5`   | `weekly-review.md`  |

## One-time prerequisites per routine

1. Install Claude GitHub App on this repo.
2. Enable "Allow unrestricted branch pushes" in the routine's environment.
3. Set env vars on the routine (NOT in a committed .env file):
   `ALPACA_API_KEY`, `ALPACA_SECRET_KEY`, `ALPACA_ENDPOINT`,
   `ALPACA_DATA_ENDPOINT`, `PERPLEXITY_API_KEY`, `PERPLEXITY_MODEL`,
   `RESEND_API_KEY`, `EMAIL_TO`, `EMAIL_FROM`.

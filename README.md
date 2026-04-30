# Trading Bot

Autonomous swing-trading agent for a ~$5,000 Alpaca paper account
(PDT-constrained until 2026-06-04). Stocks only.
Claude Code is the bot — five cloud routines fire on weekday crons, read
memory from git, call wrappers for Alpaca/Perplexity/Resend-email/EDGAR,
and commit new memory back to main.

## Layout

- `CLAUDE.md` — agent rulebook, auto-loaded every session
- `scripts/` — bash wrappers for Alpaca, Perplexity, Resend email, SEC EDGAR
- `.claude/commands/` — local slash commands for ad-hoc use
- `routines/` — cloud routine prompts (the production path)
- `memory/` — persistent state, committed to main

## Local quickstart

1. `cp env.template .env` and fill in credentials
2. Open repo in Claude Code
3. Run `/portfolio` for a read-only snapshot, or `/trade` for a manual trade helper

## Cloud setup

See the setup guide — install Claude GitHub App, create 5 routines, paste
prompts from `routines/*.md` verbatim, enable "Allow unrestricted branch
pushes", set env vars on each routine (NOT in a .env file).

## Cron schedules (America/Chicago)

- `BOT2.0-1P`   pre-market    `0 6 * * 1-5`    (6:00 AM weekdays)
- `BOT2.0-2M`   market-open   `36 8 * * 1-5`   (8:36 AM weekdays)
- `BOT2.0-3mid` midday        `20 12 * * 1-5`  (12:20 PM weekdays)
- `BOT2.0-4D`   daily summary `30 15 * * 1-5`  (3:30 PM weekdays)
- `BOT2.0-5W`   weekly review `20 16 * * 5`    (4:20 PM Friday)

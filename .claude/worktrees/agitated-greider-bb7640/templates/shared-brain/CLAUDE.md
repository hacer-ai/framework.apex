# __PROJECT_NAME__ — CLAUDE.md

Claude Code entry point. Auto-read every session.

## Session start
Run `/apex-start` — it loads what's needed. Do not bulk-read all brain files on every session.

Load on demand:
- `.agents/MAP.md` — when navigating unfamiliar modules (do not scan folders)
- `.agents/CONTEXT.md` — when you need stack, services, or `LINEAR_MODE`
- `.agents/DECISIONS.md` — before proposing architecture alternatives
- `.agents/SCHEMA.md` — before any DB work (non-negotiable, see DB Rule below)

## DB Rule — Non-negotiable
Never write a migration, query, or ORM model without reading `.agents/SCHEMA.md` first.
The `apex-schema` skill handles this automatically, but also read SCHEMA.md manually
when the task references any table or field.

## Golden Rules
- Never rewrite working modules unless explicitly required
- Never change `.agents/CONTRACTS.md` interfaces without approval (if the file exists)
- Always check `.agents/DECISIONS.md` before proposing alternatives already debated
- Always run `/apex-end` before closing a session
- A task does not enter Done without a `[PR: #N]` or `[@<short-sha>]` proof tag

## Task states
TASKS.md uses: **Todo · In Progress · Human Review · Rework · Done**, plus parking lots **Backlog** and **Blocked**.
A task with an open PR awaiting CI/review lives in Human Review. A task that came back from review with feedback lives in Rework.

## Linear integration
Set `LINEAR_MODE` in `.agents/CONTEXT.md`:
- `source` — Linear is the team's source of truth. `/apex-start` runs `/apex-sync` first.
- `mirror` — TASKS.md is local-first; state pushed to Linear on transitions. (Default.)
- `off` — Linear unused.

## Brain File Hygiene — Rules for writing to .agents/
- **No redundancy across files**: CLAUDE.md is canonical for stack, constraints, conventions, commands. CONTEXT.md holds ONLY project metadata, services, env vars, `LINEAR_MODE`, risks. DECISIONS.md holds the "why" behind architectural choices. MAP.md holds file paths and route maps only.
- **Before writing to any file**: ask "Is this already documented elsewhere?" If yes, don't duplicate it.
- **Unique IDs**: T-NNN and ADR-NNN must never collide. Always scan for the highest existing number before creating a new one.
- **Completed work is immutable history**: Once a task is Done, its entry is a one-liner. Session logs older than 2 weeks are archive material — `/apex-tidy` handles this.
- **CONTRACTS.md is optional**: Only maintain it if the project has > 10 documented API endpoints.

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in — names + scope]
- Tasks tagged `[CONTRACTOR: @name]` are scoped to that person

## Commands
- `/apex-init` — one-time setup: fill brain files from the real codebase
- `/apex-start` — begin session: load tasks, pick what to work on
- `/apex-end` — close session: update brain files (enforces PR-proof gate)
- `/apex-sync` — bidirectional reconcile with Linear (pull + push)
- `/apex-tidy` — janitorial pass: archive old Done tasks, compress PROGRESS, fix collisions. Runs cheap on Haiku
- `apex-schema` — auto-fires on DB phrases; also invokable as `/apex-schema`

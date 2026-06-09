# __PROJECT_NAME__ — AGENTS.md

Codex entry point. Mirrors CLAUDE.md — points to the same `.agents/` brain.

## Session start
Invoke `apex-start` — it loads what's needed. Do not bulk-read all brain files on every session.

Load on demand:
- `.agents/MAP.md` — when navigating unfamiliar modules (do not scan folders)
- `.agents/CONTEXT.md` — when you need stack, services, or `LINEAR_MODE`
- `.agents/DECISIONS.md` — before proposing architecture alternatives
- `.agents/SCHEMA.md` — before any DB work (non-negotiable)

## DB Rule — Non-negotiable
Never write a migration, query, or ORM model without reading `.agents/SCHEMA.md` first.

## Golden Rules
- Never rewrite working modules unless explicitly required
- Never change `.agents/CONTRACTS.md` interfaces without approval (if the file exists)
- Always check `.agents/DECISIONS.md` before proposing alternatives already debated
- A task does not enter Done without a `[PR: #N]` or `[@<short-sha>]` proof tag

## Task states
TASKS.md uses: **Todo · In Progress · Human Review · Rework · Done**, plus parking lots **Backlog** and **Blocked**.

## Linear integration
`LINEAR_MODE` lives in `.agents/CONTEXT.md`:
- `source` — Linear is the source of truth. `apex-start` runs `apex-sync` first.
- `mirror` — TASKS.md is local-first; state pushed on transitions. (Default.)
- `off` — Linear unused.

## Brain File Hygiene
- **No redundancy**: CONTEXT.md holds ONLY project metadata, services, env vars, `LINEAR_MODE`, risks. DECISIONS.md holds "why". MAP.md holds paths only.
- **Unique IDs**: T-NNN and ADR-NNN must never collide. Scan highest before creating.
- **Completed work is immutable**: Done tasks are one-liners. Session logs > 2 weeks old are archive material — `apex-tidy` handles this.
- **CONTRACTS.md is optional**: only if > 10 documented API endpoints.

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in]

## Skills (invoke by name or by description)
- `apex-start` — begin session: load tasks, pick what to work on
- `apex-end` — close session: update brain files (enforces PR-proof gate)
- `apex-sync` — bidirectional reconcile with Linear (pull + push)
- `apex-tidy` — janitorial pass: archive old Done, compress PROGRESS, fix collisions
- `apex-schema` — auto-fires on DB phrases
- `apex-linear-bootstrap` — push all tasks to Linear (once per project)
- `apex-linear-sync` — push a single task's state change to Linear
- `apex-linear-add` — add a new task to TASKS.md (and Linear)

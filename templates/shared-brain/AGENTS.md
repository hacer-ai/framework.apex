# __PROJECT_NAME__ — Agent instructions

Shared entry point for all coding agents. Codex reads this file natively;
Claude Code reads it through the `@AGENTS.md` import in CLAUDE.md.
Both point to the same `.agents/` shared brain.

## Session start
Run the `apex-start` skill — it loads what's needed. Do not bulk-read all brain files on every session.

Load on demand:
- `.agents/MAP.md` — when navigating unfamiliar modules (do not scan folders)
- `.agents/CONTEXT.md` — when you need stack or services info
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
- Always run the `apex-end` skill before closing a session

## Brain File Hygiene — Rules for writing to .agents/
- **No redundancy across files**: this file is canonical for constraints, conventions, and rules. CONTEXT.md holds ONLY project metadata, services table, env vars, known risks. DECISIONS.md holds the "why" behind architectural choices. MAP.md holds file paths and route maps only.
- **Before writing to any file**: ask "Is this already documented elsewhere?" If yes, don't duplicate it.
- **Unique IDs**: Task IDs (T-NNN) and ADR numbers (ADR-NNN) must never collide. Always scan for the highest existing number before creating a new one.
- **Completed work is immutable history**: Once a task is DONE, its entry is a one-liner. Session logs older than 2 weeks are archive material, not active context.
- **CONTRACTS.md is optional**: Only maintain it if the project has > 10 documented API endpoints. A partially-documented API surface is worse than no documentation.

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in — names + scope]
- Tasks tagged `[CONTRACTOR: @name]` are scoped to that person

## Skills
- `apex-start` — begin session: load tasks, pick what to work on
- `apex-end` — close session: update brain files
- `apex-schema` — auto-fires on DB phrases; also manually invokable
- `apex-linear-bootstrap` — push all tasks to Linear (once per project)
- `apex-linear-sync` — sync a task status change to Linear
- `apex-linear-add` — add a new task to TASKS.md + Linear

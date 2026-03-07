# __PROJECT_NAME__ — AGENTS.md

Codex entry point. Mirrors CLAUDE.md — points to the same `.agents/` brain.

## Read Order (every session, no exceptions)
1. `.agents/CONTEXT.md` — stack and services
2. `.agents/MAP.md` — codebase map (read this, do not scan folders)
3. `.agents/TASKS.md` — work queue
4. `.agents/PROGRESS.md` — where we left off

## DB Rule — Non-negotiable
Never write a migration, query, or ORM model without reading `.agents/SCHEMA.md` first.

## Golden Rules
- Never rewrite working modules unless explicitly required
- Never change `.agents/CONTRACTS.md` interfaces without approval
- Always check `.agents/DECISIONS.md` before proposing alternatives already debated

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in]

## Skills (invoke by name or by description)
- `apex-start` — load brain and show task list
- `apex-end` — close session, update brain files
- `apex-schema` — DB change guard
- `apex-plan` — plan features before coding
- `apex-linear-bootstrap` — push all tasks to Linear (once per project)
- `apex-linear-sync` — sync a task status change to Linear
- `apex-linear-add` — add a new task to TASKS.md + Linear

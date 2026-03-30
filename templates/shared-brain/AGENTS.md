# __PROJECT_NAME__ — AGENTS.md

Codex entry point. Mirrors CLAUDE.md — points to the same `.agents/` brain.

## Session start
Invoke `apex-start` — it loads what's needed. Do not bulk-read all brain files on every session.

Load on demand:
- `.agents/MAP.md` — when navigating unfamiliar modules (do not scan folders)
- `.agents/CONTEXT.md` — when you need stack or services info
- `.agents/DECISIONS.md` — before proposing architecture alternatives
- `.agents/SCHEMA.md` — before any DB work (non-negotiable)

## DB Rule — Non-negotiable
Never write a migration, query, or ORM model without reading `.agents/SCHEMA.md` first.

## Golden Rules
- Never rewrite working modules unless explicitly required
- Never change `.agents/CONTRACTS.md` interfaces without approval (if the file exists)
- Always check `.agents/DECISIONS.md` before proposing alternatives already debated

## Brain File Hygiene — Rules for writing to .agents/
- **No redundancy**: CONTEXT.md holds ONLY project metadata, services, env vars, risks — nothing that's in AGENTS.md. DECISIONS.md holds "why". MAP.md holds paths only.
- **Before writing to any file**: check if the info already exists elsewhere. Don't duplicate.
- **Unique IDs**: T-NNN and ADR-NNN must never collide. Scan for highest existing number before creating.
- **Completed work is immutable**: DONE tasks are one-liners. Session logs > 2 weeks old are archive material.
- **CONTRACTS.md is optional**: Only maintain if > 10 documented API endpoints.

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in]

## Skills (invoke by name or by description)
- `apex-start` — begin session: load tasks, pick what to work on
- `apex-end` — close session: update brain files
- `apex-schema` — auto-fires on DB phrases; also manually invokable
- `apex-linear-bootstrap` — push all tasks to Linear (once per project)
- `apex-linear-sync` — sync a task status change to Linear
- `apex-linear-add` — add a new task to TASKS.md + Linear

# __PROJECT_NAME__ — AGENTS.md

This file is the Codex entry point for the APEX shared-brain workflow.

## Shared Brain
The source of continuity for this project lives in `.agents/`.
Read it first, but do not treat it as a replacement for the codebase.
Use it to focus your exploration, then verify assumptions against source files before making edits.

## Read Order
1. `.agents/CONTEXT.md`
2. `.agents/MAP.md`
3. `.agents/TASKS.md`
4. `.agents/PROGRESS.md`
5. `.agents/DECISIONS.md`
6. `.agents/CONTRACTS.md` when API or shared interface work is involved
7. `.agents/SCHEMA.md` before any DB query, migration, ORM, or schema change

## Shared Workflows
Open the relevant playbook and follow it when the task matches:
- `.agents/playbooks/start-session.md` for "start session", "what should I work on", or project handoff
- `.agents/playbooks/end-session.md` for wrap-up, status sync, or updating shared memory
- `.agents/playbooks/db-change.md` for any database work
- `.agents/playbooks/plan-feature.md` for planning before implementation

## Operating Rules
- Validate shared-brain docs against real code before changing production files.
- Update `.agents/` whenever a code change invalidates project memory.
- Never perform destructive DB changes without an explicit rollback path and user approval.
- If `MAP.md` is stale, fix `MAP.md`; do not pretend the map is current.
- When a task is ambiguous, prefer inspecting the code over inventing missing context.

## Project Mode
Current mode: `ACTIVE`

## Team
- Lead: [fill in]
- Contributors: [fill in]

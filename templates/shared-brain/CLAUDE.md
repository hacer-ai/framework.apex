# __PROJECT_NAME__ — CLAUDE.md

This file is the Claude entry point for the APEX shared-brain workflow.

## Shared Brain
The durable project memory lives in `.agents/`.
Read it first, but do not substitute it for source inspection.
Use the map to narrow the search space, then confirm details in the repo before editing.

## Read Order
1. `.agents/CONTEXT.md`
2. `.agents/MAP.md`
3. `.agents/TASKS.md`
4. `.agents/PROGRESS.md`
5. `.agents/DECISIONS.md`
6. `.agents/CONTRACTS.md` when contracts or APIs are touched
7. `.agents/SCHEMA.md` before any DB work

## Ambient Rules
Read `.agents/rules/` at the start of every session. These are not workflow steps — they are standing principles that shape how every task is approached:
- `.agents/rules/code-quality.md`
- `.agents/rules/git-workflow.md`
- `.agents/rules/security.md`
- `.agents/rules/error-handling.md`
- `.agents/rules/testing.md`

## Shared Workflows
The canonical workflow docs live in `.agents/playbooks/`.
Use the relevant playbook when the user intent matches:
- `.agents/playbooks/start-session.md`
- `.agents/playbooks/end-session.md`
- `.agents/playbooks/db-change.md`
- `.agents/playbooks/plan-feature.md`

## Claude Convenience
If `.claude/commands/` exists, the slash commands there are wrappers around the same playbooks.
Those commands are convenience only; `.agents/playbooks/` remains the source of truth.

## Operating Rules
- Validate shared-brain docs against real code before making edits.
- Update `.agents/` whenever the implementation changes project memory.
- Never write a migration, query, or ORM model before reading `.agents/SCHEMA.md`.
- If shared docs are stale, repair them as part of the task.

## Project Mode
Current mode: `ACTIVE`

## Team
- Lead: [fill in]
- Contributors: [fill in]

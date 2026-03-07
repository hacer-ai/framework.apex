# __PROJECT_NAME__ — CLAUDE.md

Claude Code entry point. Auto-read every session.

## Read Order (every session, no exceptions)
1. `.agents/CONTEXT.md` — stack and services
2. `.agents/MAP.md` — codebase map (read this, do not scan folders)
3. `.agents/TASKS.md` — work queue
4. `.agents/PROGRESS.md` — where we left off

## DB Rule — Non-negotiable
Never write a migration, query, or ORM model without reading `.agents/SCHEMA.md` first.
The `apex-schema` skill handles this automatically, but also read SCHEMA.md manually
when the task references any table or field.

## Golden Rules
- Never rewrite working modules unless explicitly required
- Never change `.agents/CONTRACTS.md` interfaces without approval
- Always check `.agents/DECISIONS.md` before proposing alternatives already debated
- Always run `/apex-end` before closing a session

## Project Mode
Current mode: **ACTIVE**

## Team
- Lead: [fill in]
- Contributors: [fill in — names + scope]
- Tasks tagged `[CONTRACTOR: @name]` are scoped to that person

## Commands
- `/apex-start` — load brain and show task list
- `/apex-task` — show task board, pick or add a task
- `/apex-end` — close session, update brain files
- `/apex-schema [change]` — DB change guard (also auto-fires on DB phrases)
- `/apex-plan [feature]` — plan before coding
- `/apex-onboard` — onboard a new team member or agent

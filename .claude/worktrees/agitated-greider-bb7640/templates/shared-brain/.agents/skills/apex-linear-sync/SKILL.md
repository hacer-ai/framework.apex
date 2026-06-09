---
name: apex-linear-sync
description: Push a single task's state change to Linear. Called by apex-end and apex-start when a task moves state. Manual trigger only — does not auto-fire on free-form chat. Use when explicitly invoked or when another APEX skill calls it.
---

Read `.agents/CONTEXT.md`. If `LINEAR_MODE=off`, exit silently with `Linear sync skipped.`.

Read `.agents/TASKS.md` to find the task being updated.

Extract the Linear ID from the `[LIN: ABC-NNN]` tag. If absent, respond `This task has no Linear ID — run apex-linear-bootstrap or add it manually.` and exit.

Map TASKS.md state → Linear status:

| TASKS.md section | Linear status | Comment |
| --- | --- | --- |
| Todo | Todo | "Queued via APEX — YYYY-MM-DD" |
| In Progress | In Progress | "Started via APEX — YYYY-MM-DD" |
| Human Review | In Review | "PR ready — YYYY-MM-DD" |
| Rework | In Progress | "Reopened from review — YYYY-MM-DD" |
| Done | Done | "Completed via APEX — <one-line summary>" |
| Backlog | Backlog | "Deferred — YYYY-MM-DD" |
| Blocked | Todo | "BLOCKED: <reason> — YYYY-MM-DD" |

Update Linear and add the comment. Confirm: `✓ Linear [ABC-NNN] → <status>`.

For larger reconciles (pull from Linear, batch push), use `apex-sync` instead.

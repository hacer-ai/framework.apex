---
name: apex-linear-bootstrap
description: Bootstrap Linear by creating issues from TASKS.md. Use when the user says "push tasks to Linear", "bootstrap Linear", "sync tasks to Linear for the first time", or "create Linear issues from TASKS.md". Only run this once per project.
---

Read .agents/TASKS.md and .agents/CONTEXT.md.

Extract the Linear Team ID and Project from CONTEXT.md.

For every task that does NOT already have a `[LIN: ...]` tag:

1. Create a Linear issue:
   - title: task title (strip T-NNN prefix)
   - team: team ID from CONTEXT.md
   - status: map TASKS.md section → In Progress / Todo / Done
   - description: APEX task T-NNN — notes and files from TASKS.md
   - label: "apex"

2. Immediately after each issue is created, append `[LIN: ABC-NNN]` to that task line in TASKS.md.

3. After all issues are created, report:
   - How many issues were created
   - Any failures (and why)
   - Confirm TASKS.md has all Linear IDs

Do not create duplicates — skip tasks that already have `[LIN: ...]`.
Do not create issues for [DONE] tasks unless explicitly asked.

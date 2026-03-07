---
name: apex-linear-sync
description: Sync a task status change to Linear. Auto-invoke whenever a task in TASKS.md changes state — moving to In Progress, marking as Done, marking as Blocked, or unblocking. Trigger phrases: "mark done", "task complete", "starting task", "moving to in progress", "blocked on", "unblocked".
allowed-tools: Read, Write, mcp__linear__updateIssue, mcp__linear__createComment
---

Read .agents/TASKS.md to find the task being updated.

Extract the Linear ID from the `[LIN: ABC-NNN]` tag on that task line.

If no `[LIN: ...]` tag exists: stop and say "This task has no Linear ID — run apex-linear-bootstrap first or add it manually."

Based on the state change:

**Starting (moving to In Progress):**
- Update issue status → "In Progress"
- Add comment: "Started via APEX — [today's date]"

**Completing:**
- Update issue status → "Done"
- Add comment: "Completed via APEX — [one-line summary of what was done]"
- Update TASKS.md: mark [DONE] with date

**Blocking:**
- Update issue status → "Todo"
- Add comment: "BLOCKED: [reason] — [date]"
- Update TASKS.md: add [BLOCKED: reason] tag

**Unblocking:**
- Update issue status → "Todo"
- Add comment: "Unblocked — [date]"
- Update TASKS.md: remove [BLOCKED] tag

After updating: confirm "✓ Linear [ABC-NNN] updated to [status]"

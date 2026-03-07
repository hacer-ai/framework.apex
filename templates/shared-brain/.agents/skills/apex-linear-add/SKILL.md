---
name: apex-linear-add
description: Add a new task to both TASKS.md and Linear simultaneously. Use when the user wants to add a new task, issue, or work item. Trigger: "add task", "new task", "create issue", "add to backlog", "add task: [description]".
allowed-tools: Read, Write, mcp__linear__createIssue
---

Read .agents/TASKS.md and .agents/CONTEXT.md.

New task to add: $ARGUMENTS

1. Determine the next T-NNN number from TASKS.md
2. Create a Linear issue:
   - title: task description from $ARGUMENTS
   - team: team ID from CONTEXT.md
   - status: Todo
   - description: APEX task T-NNN — created via apex-linear-add
   - label: "apex"
3. Add the task to the Up Next section of TASKS.md:
   `- [ ] **T-NNN** [LIN: ABC-NNN] — [title] [LEAD]`
4. Confirm: "✓ T-NNN created in TASKS.md and Linear [ABC-NNN]"

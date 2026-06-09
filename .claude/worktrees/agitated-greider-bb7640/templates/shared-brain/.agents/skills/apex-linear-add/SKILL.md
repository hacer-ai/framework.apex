---
name: apex-linear-add
description: Add a new task to TASKS.md (and Linear, when LINEAR_MODE != off). Use when the user wants to add a new task, issue, or work item. Trigger phrases: "add task", "new task", "create issue", "add to backlog", "add task: [description]".
---

Read `.agents/TASKS.md` and `.agents/CONTEXT.md`.

New task to add: $ARGUMENTS

Resolve `LINEAR_MODE` from CONTEXT.md (default: `mirror`).

1. Determine the next free `T-NNN` from TASKS.md (highest existing + 1).

2. **If `LINEAR_MODE != off`**, create a Linear issue:
   - title: task description from $ARGUMENTS
   - team: team ID from CONTEXT.md
   - status: Todo
   - description: `APEX task T-NNN — created via apex-linear-add`
   - label: `apex`

   On success, capture the Linear ID (e.g. `ABC-NNN`).

3. Add the task to the **Todo** section of TASKS.md:
   - With Linear: `- [ ] T-NNN [LIN: ABC-NNN] — [title] [LEAD]`
   - Without Linear (`LINEAR_MODE=off`): `- [ ] T-NNN — [title] [LEAD]`

4. Confirm:
   - With Linear: `✓ T-NNN created in TASKS.md and Linear [ABC-NNN]`
   - Without Linear: `✓ T-NNN added to TASKS.md (Linear sync off)`

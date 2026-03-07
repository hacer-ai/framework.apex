Read .agents/TASKS.md silently.

Display the task board:

---
## Task Board — __PROJECT_NAME__

**🔴 In Progress**
[for each: T-NNN [LIN: ID if present] — title · owner]
  [one-line description of what needs to happen]

**🟡 Up Next**
[for each: T-NNN [LIN: ID if present] — title · owner]
  [one-line description of what needs to happen]

**🚫 Blocked**
[for each: T-NNN — title · BLOCKED: reason]

**🔵 Backlog** (top 5)
[T-NNN — title]
---

Reply with:
- A T-ID to start working on that task
- "add task: [description]" to create a new task (adds to TASKS.md + Linear)
- "show all" to see the full backlog
- "block T-NNN: [reason]" to flag a task as blocked

When the user selects a task:
- Mark it In Progress in .agents/TASKS.md
- If it has a `[LIN: ABC-NNN]` tag, call apex-linear-sync to move it to In Progress in Linear
- If it touches the database, read .agents/SCHEMA.md before writing any code

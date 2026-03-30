# TASKS.md — __PROJECT_NAME__

## Task format
```
- [ ] T-NNN [LIN: ABC-NNN] — title `[LEAD]`
  - Files: relevant files (optional)
  - Notes: context (optional)
```
- `[LEAD]` — who owns this (human name, Claude, or Codex)
- `[CONTRACTOR: @name]` — scoped to a specific contractor
- `[LIN: ABC-NNN]` — Linear issue ID, added by apex-linear-bootstrap or apex-linear-add
- `🔒 ACTIVO: Name · date` — someone is actively working on this now. Remove on commit.

One active task per person/agent at a time. If you see 🔒 on a task you were about to take, pick another.

## Hygiene rules
- **Unique IDs**: Before creating a new T-NNN, scan for the highest existing number and use +1. NEVER reuse a task ID.
- **Done format**: When a task is marked DONE, trim it to one line: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD`. Delete all sub-bullets — the code and git history have the details.
- **In Progress integrity**: The "In Progress" section must contain ONLY items NOT marked [x]. Move completed items to Done immediately.
- **Size control**: If this file exceeds 500 lines, trim Done tasks to one-liners and remove any sub-bullets from completed work.

---

## 🔴 In Progress
- [ ] T-001 — [current task] `[LEAD]` 🔒 ACTIVO: [Name · YYYY-MM-DD]
  - Notes: [what needs to happen]

## 🟡 Up Next
- [ ] T-002 — [next priority task] `[LEAD]`
- [ ] T-003 — [another task] `[LEAD]`

## 🔵 Backlog
- [ ] T-010 — [future task] `[LEAD]`

## 🚫 Blocked
- [ ] T-099 — [blocked task] `[BLOCKED: reason · since YYYY-MM-DD]`

## ✅ Done
- [x] T-000 — Initial shared-brain setup

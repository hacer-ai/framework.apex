# TASKS.md — __PROJECT_NAME__

This file is the **buffer** between the team's tracker (Linear, by default) and the work the agent does today.
Linear holds history; TASKS.md holds attention.

## Task format
```
- [ ] T-NNN [LIN: ABC-NNN] — title `[LEAD]`
  - Files: relevant files (optional)
  - Notes: short context (optional)
```

Tags:
- `[LEAD]` — who owns this (human name, Claude, or Codex)
- `[CONTRACTOR: @name]` — scoped to a specific contractor
- `[LIN: ABC-NNN]` — Linear issue ID (added by `apex-linear-add` / `apex-sync`)
- `[PR: #123]` — pull request that ships the work (proof-of-work; required to enter Done)
- `[@abc1234]` — short commit hash (alternative proof when no PR was opened)
- `🔒 ACTIVO: Name · YYYY-MM-DD` — someone is actively working on this now. Remove on commit.

One active task per person/agent at a time. If you see 🔒 on a task you were about to take, pick another.

## State machine

Active flow:
```
Todo  →  In Progress  →  Human Review  →  Done
                    ↑           │
                    └─── Rework ┘
```

Parking lots (out of active flow): **Backlog** (not scheduled), **Blocked** (waiting on something external).

| State | Meaning | Next |
| --- | --- | --- |
| Todo | Scheduled, not started | In Progress |
| In Progress | Someone/some agent is working it now | Human Review or Done |
| Human Review | PR open, awaiting review or CI | Done or Rework |
| Rework | Came back from review with feedback | In Progress |
| Done | Shipped — PR merged or commit landed | (terminal) |
| Backlog | Captured but not scheduled | Todo when picked up |
| Blocked | Cannot proceed — external dependency | Todo when unblocked |

## Hygiene rules
- **Unique IDs**: scan for the highest existing T-NNN and use +1. Never reuse a task ID.
- **Done format**: when a task is marked Done, trim it to one line: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD [PR: #123]`. Delete sub-bullets — git history has the details.
- **Proof of work**: a task cannot enter Done without `[PR: #N]` or `[@hash]`. `apex-end` enforces this.
- **In Progress integrity**: only items NOT marked [x] live here. Move completed items to Human Review or Done immediately.
- **Size control**: if this file exceeds 400 lines, run `/apex-tidy` — it archives Done > 14 days into `.agents/archive/`.

---

## 🔵 Todo
- [ ] T-002 — [next task] `[LEAD]`
- [ ] T-003 — [another task] `[LEAD]`

## 🔴 In Progress
- [ ] T-001 — [current task] `[LEAD]` 🔒 ACTIVO: [Name · YYYY-MM-DD]
  - Notes: [what needs to happen]

## 🟣 Human Review
<!-- Tasks with an open PR awaiting review or CI. Move to Done when merged. -->

## 🟠 Rework
<!-- Tasks that came back from review with feedback. Move to In Progress when picking back up. -->

## 🟡 Backlog
- [ ] T-010 — [future task] `[LEAD]`

## 🚫 Blocked
- [ ] T-099 — [blocked task] `[BLOCKED: reason · since YYYY-MM-DD]`

## ✅ Done
- [x] T-000 — Initial shared-brain setup [Lead] DONE YYYY-MM-DD [@initial]

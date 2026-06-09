---
name: apex-sync
description: Bidirectional reconcile between Linear and TASKS.md. Pulls new Linear issues into TASKS.md and pushes local state changes out. Run at the start of a session (LINEAR_MODE=source) or on demand.
disable-model-invocation: true
---

Read `.agents/CONTEXT.md` and resolve `LINEAR_MODE`. Behavior changes per mode:

- `off` → respond `Linear sync skipped (LINEAR_MODE=off).` and exit.
- `mirror` → push-only: skip Step A, run Step B, run Step C.
- `source` → bidirectional: run Step A, then Step B, then Step C.

If `LINEAR_MODE` is missing from CONTEXT.md, default to `mirror` and warn once at the end.

Read `.agents/TASKS.md` once.

## Step A — Pull from Linear (source mode only)

Query Linear for issues that meet **all** of:
- Team ID matches CONTEXT.md.
- Project matches CONTEXT.md (if set).
- Label includes `apex` OR assignee is the current user.
- Status is one of: Todo, In Progress, In Review.
- Issue ID does NOT already appear as `[LIN: ABC-NNN]` in TASKS.md.

For each new issue:
1. Compute next free `T-NNN` (scan all existing TASKS.md IDs, take max + 1; do this fresh for each insert so the second new issue doesn't collide).
2. Map Linear status to TASKS.md section:
   - Todo → `## 🔵 Todo`
   - In Progress → `## 🔴 In Progress`
   - In Review → `## 🟣 Human Review`
3. Append: `- [ ] T-NNN [LIN: ABC-NNN] — {issue title} [LEAD]`. Use the assignee's name for `[LEAD]` if known, else leave `[LEAD]` literal for the user to fill.

## Step B — Push state changes to Linear

For each TASKS.md task with `[LIN: ABC-NNN]`:
1. Determine current local state from its section header.
2. Fetch current Linear status for `ABC-NNN`.
3. If they differ, push local → Linear:

| TASKS.md section | Linear status |
| --- | --- |
| Todo | Todo |
| In Progress | In Progress |
| Human Review | In Review |
| Rework | In Progress |
| Done | Done |
| Backlog | Backlog |
| Blocked | Todo (with comment "BLOCKED: <reason>") |

Add a one-line comment on the Linear issue describing the transition: `Synced via APEX — {old} → {new} on YYYY-MM-DD`.

**Conflict rule**: if `LINEAR_MODE=source` and Linear's status is more recent (per `updatedAt`) than the local TASKS.md edit time, **trust Linear** — update TASKS.md to match Linear's state. Record the conflict in the report.

## Step C — Report

Output exactly this block:

```
✓ APEX-SYNC — YYYY-MM-DD · mode=<mode>
pulled:    N issues from Linear → TASKS.md
pushed:    M state changes → Linear
conflicts: K (resolved by trusting <Linear|local>)
unsynced:  list of TASKS.md tasks without [LIN: ...] (or "none")
```

If anything failed (auth, rate limit, missing team ID), include it under a final `errors:` line and stop. Do not modify TASKS.md if Linear queries fail — leave the buffer untouched.

## Notes
- This command is **safe to run repeatedly**. It is idempotent.
- Done tasks older than 14 days should already be archived by `/apex-tidy` and will not appear here.
- Per-task incremental pushes (when /apex-end finalizes a task) still go through `apex-linear-sync`. This command is the bigger reconcile.

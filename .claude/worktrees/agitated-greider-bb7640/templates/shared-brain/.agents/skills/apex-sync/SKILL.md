---
name: apex-sync
description: Bidirectional reconcile between Linear and TASKS.md. Pulls new Linear issues into TASKS.md and pushes local state changes out. Run at session start (LINEAR_MODE=source) or on demand. Trigger phrases: "sync linear", "reconcile tasks", "pull from linear", "apex sync".
---

Read `.agents/CONTEXT.md` and resolve `LINEAR_MODE`:

- `off` → respond `Linear sync skipped (LINEAR_MODE=off).` and exit.
- `mirror` → push-only: skip Step A, run Step B, run Step C.
- `source` → bidirectional: run Step A, then Step B, then Step C.

If `LINEAR_MODE` is missing, default to `mirror` and warn once at the end.

Read `.agents/TASKS.md` once.

## Step A — Pull from Linear (source mode only)

Query Linear for issues that meet **all** of:
- Team ID matches CONTEXT.md.
- Project matches CONTEXT.md (if set).
- Label includes `apex` OR assignee is the current user.
- Status is one of: Todo, In Progress, In Review.
- Issue ID is NOT already in TASKS.md as `[LIN: ABC-NNN]`.

For each new issue:
1. Compute next free `T-NNN` fresh per insert (max existing + 1).
2. Map Linear status → TASKS.md section:
   - Todo → `## 🔵 Todo`
   - In Progress → `## 🔴 In Progress`
   - In Review → `## 🟣 Human Review`
3. Append: `- [ ] T-NNN [LIN: ABC-NNN] — {title} [LEAD]`. Use assignee name for `[LEAD]` if known, else leave literal.

## Step B — Push state changes

For each TASKS.md task with `[LIN: ABC-NNN]`:
1. Determine local state from section header.
2. Fetch Linear status for `ABC-NNN`.
3. If they differ, push local → Linear:

| TASKS.md section | Linear status |
| --- | --- |
| Todo | Todo |
| In Progress | In Progress |
| Human Review | In Review |
| Rework | In Progress |
| Done | Done |
| Backlog | Backlog |
| Blocked | Todo + comment `BLOCKED: <reason>` |

Add comment: `Synced via APEX — {old} → {new} on YYYY-MM-DD`.

**Conflict rule**: if `LINEAR_MODE=source` and Linear's `updatedAt` is more recent than the local edit, trust Linear — update TASKS.md to match. Record in the report.

## Step C — Report

```
✓ APEX-SYNC — YYYY-MM-DD · mode=<mode>
pulled:    N issues from Linear → TASKS.md
pushed:    M state changes → Linear
conflicts: K (resolved by trusting <Linear|local>)
unsynced:  TASKS.md tasks without [LIN: ...] (or "none")
```

On any failure (auth, rate limit, missing team ID), append an `errors:` line and **leave TASKS.md untouched**.

This skill is idempotent. Per-task incremental pushes go through `apex-linear-sync`; this is the bigger reconcile.

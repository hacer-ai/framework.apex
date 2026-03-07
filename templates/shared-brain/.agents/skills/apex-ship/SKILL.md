---
name: apex-ship
description: Close the current session, update brain files, create a task branch, commit changes, and optionally open a PR. Use when the user says "ship it", "commit", "open a PR", "done, let's ship", or "wrap up and commit".
---

Follow these steps in order:

STEP 1 — Update brain files (same as apex-end):
- .agents/PROGRESS.md — append session summary (✅ done · 🔄 carry-forward · 🧠 decisions)
- .agents/TASKS.md — mark completed tasks [DONE], remove 🔒 ACTIVO signals
- .agents/MAP.md — add new files or modules
- .agents/SCHEMA.md — if DB changed: update tables + Change Log
- .agents/DECISIONS.md — add decisions made

For each DONE task with [LIN: ABC-NNN]: call apex-linear-sync.

STEP 2 — Find the completed task. Extract T-NNN and slug the title.
Branch name: T-NNN-task-slug (e.g. T-012-jwt-refresh-token-rotation)

STEP 3 — Check current branch (git branch --show-current).
If not already on a T-NNN branch: git checkout -b [branch-name]
If on a different feature branch: ask before creating a new one.

STEP 4 — Show git status --short so user sees exactly what will be committed.
Flag any .env or build artifact files and confirm before including.

STEP 5 — Propose commit: feat(T-NNN): [one-line summary]
Ask user to confirm or edit.

STEP 6 — Ask the user:
  1. commit — commit to branch only
  2. pr     — commit + push + open PR
  3. cancel — stop, I'll handle git manually

Execute the chosen path. For PR: try gh pr create, fall back to printing the manual commands.

Follow these steps in order. Do not skip any step.

---

**STEP 1 — Update the brain files (same as apex-end)**

Update these files to reflect the current session:
- .agents/PROGRESS.md — append what was completed (✅), carried forward (🔄), decisions (🧠)
- .agents/TASKS.md — mark completed tasks [DONE] with today's date, remove 🔒 ACTIVO signals
- .agents/MAP.md — add any new files or modules created
- .agents/SCHEMA.md — only if DB changes were made
- .agents/DECISIONS.md — add any architectural decisions made

For each task marked DONE with a `[LIN: ABC-NNN]` tag: call apex-linear-sync to mark Done in Linear.

---

**STEP 2 — Find the active task**

Read .agents/TASKS.md and find the task that was just completed (most recently moved to Done).
Extract: T-NNN and the task title.
Convert the title to a branch-safe slug: lowercase, spaces → hyphens, remove special characters.
Branch name: `T-NNN-task-slug` (e.g. `T-012-jwt-refresh-token-rotation`)

---

**STEP 3 — Check the current git branch**

Run: `git branch --show-current`

- If already on a branch named `T-NNN-...` for this task: stay on it, skip to Step 4.
- If on `main`, `master`, or `develop`: run `git checkout -b [branch-name]`
- If on a different feature branch: ask the user "You're on branch [name] — create a new branch [T-NNN-slug] or stay here?" before proceeding.

---

**STEP 4 — Show what will be committed**

Run: `git status --short`

Display the output so the user can see exactly what changed. Flag any unexpected files (e.g. .env, secrets, build artifacts) and ask about them before including.

---

**STEP 5 — Propose a commit message**

Suggest a commit message in this format:
`feat(T-NNN): [one-line summary of what was accomplished]`

Show it to the user and ask: "Use this message, or type your own?"

---

**STEP 6 — Ask what to do next**

Present three options clearly:

```
What would you like to do?
  1. commit   — commit to branch [branch-name] only
  2. pr       — commit + push + open a pull request
  3. cancel   — stop here, I'll handle git manually
```

Wait for the user's choice.

---

**If the user chooses "commit":**
Run:
```
git add -A
git commit -m "[approved message]"
```
Confirm: "✓ Committed to [branch-name]. Push when ready with: git push -u origin [branch-name]"

---

**If the user chooses "pr":**
Run:
```
git add -A
git commit -m "[approved message]"
git push -u origin [branch-name]
```
Then check if `gh` is available by running: `gh --version`

If `gh` is available:
```
gh pr create --title "[approved message]" --body "Closes T-NNN\n\n[summary of what was done from PROGRESS.md]" --base main
```

If `gh` is not available, output these commands for the user to run manually:
```
# Open a PR from the GitHub web interface, or install gh:
# https://cli.github.com

# Branch pushed: [branch-name]
# PR title: [approved message]
# Base branch: main
```

---

**If the user chooses "cancel":**
Say: "Brain files are updated. Git is untouched — handle the commit manually."
Output the suggested commit message so they can copy it.

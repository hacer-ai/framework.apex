# Review

Use this workflow before committing or opening a PR. Run whenever you want an honest quality check on the current changes.

## Step 1 — Gather scope

Run `git diff HEAD` to see unstaged changes, or `git diff --cached` if changes are staged.
List every file modified. If the diff is large (200+ lines), focus on the highest-risk files first.

## Step 2 — Six-dimension evaluation

For each changed file or logical unit, evaluate:

### 1. Quality
- Is the code readable and idiomatic for this stack?
- Are there dead code, unused imports, or commented-out blocks?
- Do names communicate intent?

### 2. Architecture
- Does the change respect module boundaries defined in `.agents/MAP.md`?
- Is new logic placed in the right layer (handler vs service vs repository)?
- Is there premature abstraction or over-engineering?

### 3. Consistency
- Does the style match the surrounding code?
- Are error responses in the project's established format?
- Are naming conventions consistent with the rest of the codebase?

### 4. Reuse
- Does this duplicate logic that exists elsewhere in the project?
- Could it use an existing utility, helper, or library instead?

### 5. Security
- Are there hardcoded secrets, tokens, or credentials?
- Is user input validated at the boundary?
- Are queries parameterized? Is output sanitized?

### 6. Performance
- Are there obvious N+1 queries or missing indexes?
- Are there blocking calls in async paths?
- Is data fetched that is never used?

## Step 3 — Verdict

Produce a structured report:

```text
REVIEW COMPLETE
Files reviewed: [N]

Issues:
- [file:line] [dimension] [description] → [recommendation]
- ...

Verdict: Ready to commit | Minor issues (non-blocking) | Needs changes (blocking)
```

If verdict is "Needs changes", list only the blocking issues that must be resolved before committing.

## Rules
- Be specific. Point to exact file and line, not general areas.
- Distinguish blocking issues from suggestions.
- Do not flag style preferences as blocking.
- If no issues found, say so explicitly.

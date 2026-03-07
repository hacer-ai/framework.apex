Read these files silently:
- .agents/CONTRACTS.md
- .agents/DECISIONS.md
- .agents/MAP.md

Then run: `git diff --name-only HEAD`
(If nothing staged yet, also try: `git status --short`)

For each changed file, check:

1. **Contract check** — Does this file implement or consume any interface listed in CONTRACTS.md?
   - If yes: has the interface changed? If so, flag it — CONTRACTS.md must be updated and consumers notified.
   - If no: pass.

2. **Decision check** — Does any change in this file contradict an architectural decision in DECISIONS.md?
   - Look for: using a different library than decided, different pattern, different data format.
   - If a contradiction is found: flag it with the decision ID and what conflicts.

3. **New exports check** — Does this file export a new function, type, or API endpoint that isn't in CONTRACTS.md yet?
   - If yes: flag it — new public interfaces should be documented.

---

Output a clear report:

```
APEX REVIEW — [date]

✅ PASS — [list of files with no issues]

⚠️  REVIEW REQUIRED:
  [file] — [specific issue, which contract or decision is affected]
  [file] — [specific issue]

🔴 BLOCK:
  [file] — [issue that must be resolved before shipping: broken contract, violated decision]
```

If everything passes: "✅ All clear — no contract violations or decision conflicts found. Ready to ship."

Do not modify any files. This is read-only analysis.

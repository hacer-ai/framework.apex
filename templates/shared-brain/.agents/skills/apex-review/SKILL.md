---
name: apex-review
description: Review current changes against CONTRACTS.md and DECISIONS.md before committing. Use when the user says "review my changes", "check before shipping", "any contract violations?", or "are my changes safe to commit?".
---

Read .agents/CONTRACTS.md, .agents/DECISIONS.md, .agents/MAP.md silently.

Run: git diff --name-only HEAD

For each changed file check:
1. Contract violations — changed interface listed in CONTRACTS.md without updating it?
2. Decision conflicts — change contradicts a recorded DECISIONS.md choice?
3. New public exports — new API/function not yet in CONTRACTS.md?

Output report:
✅ PASS — [files with no issues]
⚠️ REVIEW — [file: specific issue, which contract/decision]
🔴 BLOCK — [file: must fix before shipping]

If all pass: "✅ All clear — ready to ship."

Read-only. Do not modify any files.

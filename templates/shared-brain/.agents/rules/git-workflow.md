# Git Workflow Rules

## Commits
- Every commit is atomic: one logical change per commit.
- Use imperative mood: "Add feature" not "Added feature".
- Format: `type: short description` — types: feat, fix, refactor, test, docs, chore.
- Never use `--no-verify` unless the user explicitly instructs it.

## Branches
- `main` is always deployable. Never commit directly to it.
- Feature branches: `feat/short-description`
- Bug fixes: `fix/short-description`
- Each branch addresses one concern.

## Pull requests
- Keep PRs under 400 lines of diff where possible. Split larger ones.
- Every PR needs a description explaining why, not just what.
- Do not merge until CI passes.

## What not to do
- Do not squash a branch into one commit covering multiple concerns.
- Do not rewrite published history without explicit user instruction.
- Do not force-push to `main` or shared branches.

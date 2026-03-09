# Security Rules

## Secrets
- Never hardcode secrets, API keys, tokens, or credentials in source files.
- Secrets belong in environment variables. Reference them via config objects, never inline.
- If you find a hardcoded secret while reading code, flag it in `PROGRESS.md` under ⚠️ before proceeding.

## Input validation
- Validate all input at system boundaries: HTTP handlers, CLI args, file reads, IPC.
- Do not validate inside internal functions — validate once at the entry point.
- Reject early: if input is invalid, return an error before doing any work.

## Auth
- Authentication checks happen before business logic, never inside it.
- Do not implement auth from scratch. Use the project's established auth mechanism.
- Row-level authorization must be enforced server-side.

## Injection
- Never build SQL queries by string concatenation. Use parameterized queries or the ORM.
- Never pass unsanitized user input to shell commands, `eval`, or template engines.
- Sanitize HTML output in frontend code to prevent XSS.

## Dependencies
- Flag outdated dependencies with known CVEs if discovered during reading.
- Do not introduce new dependencies with a history of security issues.

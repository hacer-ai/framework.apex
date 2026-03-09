# Error Handling Rules

## Principles
- Never silently swallow errors. If you catch an exception, either handle it or re-raise it.
- Log enough context to diagnose: operation name, inputs, system state.
- Fail fast: surface errors as early as possible rather than propagating invalid state.

## Structure
- Use structured error responses at API boundaries: `{ success, code, message }`.
- Define domain-specific error codes (e.g. `USER_NOT_FOUND`, `PAYMENT_DECLINED`).
- Do not expose stack traces or internal error details to external callers.

## Boundaries
- Wrap all external calls (databases, APIs, queues) in error handlers.
- Distinguish recoverable errors (retry, fallback) from fatal errors (abort, alert).
- At the top level, catch unhandled exceptions and log them before the process exits.

## What not to do
- Do not use exceptions for control flow.
- Do not return `null` to signal an error where a typed error is possible.
- Do not catch generic `Exception` / `Error` unless you are at a top-level boundary.

# Testing Rules

## Coverage
- Every bug fix gets a regression test.
- Every public function at a module boundary gets at least one test.
- Do not ship a feature that cannot be verified — if it can't be tested, reconsider the design.

## Test design
- Tests are documentation. Name them descriptively: `it("returns 404 when user not found")`.
- One assertion per test where practical. Multiple assertions are fine for a single logical fact.
- Tests must be deterministic. Mock time, randomness, and external services.
- Test observable behavior, not implementation details.

## Scope
- Unit tests cover pure logic in isolation.
- Integration tests cover module boundaries (service → DB, handler → service).
- Do not duplicate coverage: if a unit test covers it, the integration test does not need to repeat it.

## Maintenance
- Delete tests that no longer reflect real behavior.
- If a test is flaky, fix it or delete it — flaky tests destroy trust.
- Keep setup minimal. Avoid fixtures that grow into unmaintainable state factories.

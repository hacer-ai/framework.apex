# Database Change

Use this workflow for any migration, schema edit, query rewrite, ORM change, or DB-dependent feature.

## Required Reads
1. `.agents/SCHEMA.md`
2. Real schema sources listed in `.agents/SCHEMA.md`
3. `.agents/CONTRACTS.md` if API payloads or shared types can change
4. Relevant modules from `.agents/MAP.md`

## Analysis Checklist
1. What tables, views, or enums are affected?
2. What code paths read or write those records?
3. What constraints, indexes, and permissions could be impacted?
4. Is the change additive, backward-compatible, or destructive?
5. What is the rollback path?

## Safety Rules
- Do not rely only on `SCHEMA.md`; validate against migrations and code.
- For destructive changes, stop for approval before editing files.
- Call out data backfills, deployment ordering, and contract changes explicitly.

## Output
- Proposed change
- Affected schema objects
- Downstream code impact
- Rollback / migration notes

# DECISIONS.md

Record decisions that should not be re-litigated every session.

## Integrity rules
- **Unique ADR numbers**: Before adding a new ADR, scan all existing `## ADR-NNN` headers and use the highest + 1. NEVER reuse an ADR number.
- **Append only**: New ADRs go at the END of the file, maintaining sort order.
- **Scope**: This file holds the "why" behind architectural choices. Operational "how" belongs in CLAUDE.md.

## ADR-001 — [title]
- Date: YYYY-MM-DD
- Status: Accepted
- Context: [why this decision mattered]
- Decision: [what was chosen]
- Consequences: [tradeoffs]

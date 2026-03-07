---
name: apex-plan
description: Plan a new feature before writing any code. Use when the user says "I want to build X", "plan this feature", "what would it take to add Y", or describes a significant new capability.
---

Read: AGENTS.md, .agents/CONTEXT.md, .agents/MAP.md, .agents/SCHEMA.md, .agents/CONTRACTS.md

Feature to plan: $ARGUMENTS

Without writing any code, produce:
1. Impact analysis — existing MAP.md modules affected
2. Schema changes — new/modified tables (check SCHEMA.md)
3. New files — additions to MAP.md after implementation
4. Contract changes — CONTRACTS.md updates needed
5. Task breakdown — ordered list formatted for TASKS.md
6. Risk flags — anything that could break existing functionality

Wait for approval before adding tasks to TASKS.md or writing any code.

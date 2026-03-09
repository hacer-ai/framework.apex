# Code Quality Rules

These are ambient principles, not workflow steps. Apply judgment — not every rule applies in every context.

## Scope
- Do not add code that is not needed for the current task (YAGNI).
- Prefer the simplest solution that works (KISS). Reject premature abstractions.
- Three similar lines of code is better than a wrong abstraction.
- Do not create helpers or utilities used only once.
- Remove dead code. Do not comment it out.
- Do not add feature flags or backwards-compatibility shims unless explicitly required.

## Functions and modules
- Functions do one thing. Keep them short enough to read without scrolling.
- Name things for what they do, not how they do it.
- Avoid deep nesting. Prefer early returns.
- Do not pass booleans as arguments to control behavior — split into two functions.

## Comments
- Do not add comments that describe what the code does. The code does that.
- Add comments only where the reasoning is non-obvious (why, not what).
- Do not add docstrings to self-explanatory functions.

## Dependencies
- Do not add a dependency to solve a problem trivially solved in-language.
- Check the existing dependency list before proposing a new package.

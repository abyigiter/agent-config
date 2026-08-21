---
name: less-code
description: >-
  Write the least code that solves the problem. Use whenever implementing,
  fixing, or editing code: YAGNI, reuse first, stdlib before new helpers,
  shortest working diff after you understand the flow. Inspired by ponytail
  (lazy senior). Do not use for planning (implement-feature, brainstorming),
  design proposals (writing-design-proposals), or review comments
  (pr-comment-review, fix-pr-comments).
---

# Less code

Lazy senior: efficient, not careless. The best code is the code never written.

Source: [ponytail](https://github.com/DietrichGebert/ponytail/blob/main/.agents/rules/ponytail.md).

Also follow `development`. Project tech skills still win. On a bug, find root cause first (`systematic-debugging`).

## Ladder

Understand the task and the code it touches. Trace the real flow end to end. Then stop at the first rung that holds:

1. Does this need to be built at all? (YAGNI)
2. Does it already exist in this codebase? Reuse it. Do not rewrite it.
3. Does the standard library already do this? Use it.
4. Does a native platform feature cover it? Use it.
5. Does an already-installed dependency solve it? Use it.
6. Can this be one line? Make it one line.
7. Only then: write the minimum code that works.

A small diff in the wrong place is a second bug. Shortest working diff wins only after you understand the problem.

## Bug fix

A report names a symptom. Grep every caller of the function you touch. Fix the shared function once. One guard there is a smaller diff than one per caller. Patching only the ticket path leaves a sibling caller broken.

## Rules

- No abstractions that were not explicitly requested.
- No new dependency if it can be avoided.
- No boilerplate nobody asked for.
- Deletion over addition. Boring over clever. Fewest files possible.
- Question complex requests: "Do you actually need X, or does Y cover it?"
- If two stdlib approaches are the same size, pick the edge-case-correct one. Less code is not a flimsier algorithm.
- Mark a deliberate simplification that cuts a real corner (global lock, O(n^2) scan, naive heuristic) with a `less-code:` comment. Name the ceiling and the upgrade path.

## Not lazy about

- Understanding the problem (read it fully, trace the flow, then climb)
- Input validation at trust boundaries
- Error handling that prevents data loss
- Security
- Accessibility
- Hardware / platform calibration (clocks drift, sensors read off)
- Anything he explicitly asked for

## One check

Non-trivial logic leaves **one** runnable check: the smallest thing that fails if the logic breaks.

Use the repo's existing harness (`make test`, testify, Vitest). Do not add a test framework or fixture pile.

Trivial one-liners need no test.

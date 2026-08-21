---
name: implement-feature
description: >-
  Plan, then implement a new or large full-stack feature. Use when the user
  asks to implement a feature, build a new flow, ship an epic, or do a
  cross-cutting change that likely touches API, schema, and UI. Starts in plan
  mode, does not split a reviewable 20-30 file change into many PRs, does not
  defer work the user did not defer, skips browser/Playwright and CI polling
  unless asked. Do not use for one-line fixes, PR review, or comment posting.
---

# Implement feature

Plan first. Then ship the full vertical slice.

While coding, also follow `development` (`~/.agents/skills/development/SKILL.md`). This skill only adds plan mode and the cross-repo inventory.

## Anti-triggers

- One-file or obvious bugfix: follow `development`. Do not switch to plan mode.
- PR review / leave comments: `pr-comment-review`.
- "Skip the plan" / "just implement": stay in agent mode. Still follow the other rules.

## Defaults (do not ask)

| Choice | Default |
|---|---|
| Stack | Full-stack (schema, API, UI). Not backend-only, not UI-only. |
| Plan | Plan mode first. Write the plan. Wait for go-ahead. |
| Repos | Inventory sibling repos the feature needs. Implement every piece. |
| PR shape | One PR per repo. 20-30 files in one PR is fine if it is one story and reviewable. |
| Deferral | None, unless he asked. No "follow-up PR" for tests, UI, or the other repo. |
| Browser / Playwright | Off unless he asked. |
| Checks | Fast, scoped Make targets. No full-monorepo, no lint-full. |
| CI | Do not poll. He will look and tell you. |

## 1. Plan mode first

Switch to plan mode before writing code (`SwitchMode` → `plan`).

Do not start implementation until he says go (or "implement", "ship it", "do it").

While planning:

- Trace the user journey (entry, data, permissions, empty/error/success).
- Check meeting notes if this sounds like a named decision.
- Read the nearest existing owner in code. Do not invent a parallel path.

### Plan location

If the project documents a `docs/` (or similar) layout, put the plan there and follow that layout.

Otherwise keep the plan in plan-mode chat. Do not invent a docs convention.

Plan shape:

```markdown
<2-4 plain sentences: what this does and why. No jargon. Human summary.>

## Cross-repo
- <this repo>: …
- <sibling>: … (or none, with a one-line why)

## Execution detail
1. <bounded step> — verify: <fast check>
```

The human summary is for him. Execution detail is for the agent. No speculative alternatives you will not take.

## 2. Cross-repo inventory

Search sibling checkouts next to this repo when the feature cannot ship from one repo alone.

A piece is in scope if the feature cannot work in production without it: contract, persistence, RPC, UI, adapter, env, secret, image, cron, deploy.

Write every such piece in **Cross-repo**. Then implement it. Do not leave required sibling work as a comment on this PR.

One PR per repo when the change spans repos. Link them. Ship them together. That is not "splitting too much."

## 3. Implement

After go-ahead, switch back to agent mode. Follow `development`.

Follow the plan's execution steps in order. Each step has a verify. Run that verify before the next step.

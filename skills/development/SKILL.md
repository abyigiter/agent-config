---
name: development
description: >-
  Everyday coding contract while implementing, fixing, or editing code. Use
  whenever the user asks to write code, fix a bug, change a file, or land a
  small-to-medium change. Full-stack unless told otherwise, one reviewable PR,
  no deferred leftovers, scoped Make checks, no Playwright or CI polling unless
  asked. Do not use for big-feature planning (implement-feature), PR review
  comments (pr-comment-review), or addressing review feedback (fix-pr-comments).
---

# Development

How Bugra wants code written. Not how to boot the laptop stack.

For a **new large feature**, also load `implement-feature` (plan mode, then the full slice). This skill still applies while coding.

## Anti-triggers

- Reviewing someone else's PR / posting review comments: `pr-comment-review`.
- Addressing teammate or bot review comments on his PR: `fix-pr-comments`.
- "How do I run the local stack / database / worktree": answer from the repo README.
- Draft a Slack, email, or GitHub reply he will paste: `message`.

## Defaults (do not ask)

| Choice | Default |
|---|---|
| Stack | Full-stack. Schema + API + UI if the journey needs them. |
| Scope | The whole slice. Do not defer tests, UI, or a required sibling repo. |
| PR | One PR per repo. 20-30 files is fine if it is one story and reviewable. |
| Browser / Playwright | Off unless he asked. |
| Checks | Fast, scoped Make. No lint-full, no repo-wide `go test ./...`. |
| CI | Do not poll. Give the PR URL. He will say if it failed. |
| Diff | Surgical. No opportunistic refactors. |

## Full-stack

If he did not say "backend only" or "UI only":

- Run the repo's codegen when the contract changes
- Migration when persistence changes
- Handler / data layer
- UI if the change is user-facing
- Focused tests for new logic

Do not ship an API with no UI for a user-facing change. Do not ship UI against a missing field.

If this repo cannot work without a sibling repo, change that repo too. One PR per repo, linked.

## Do not split. Do not defer.

One story, one PR. Do not split schema / API / UI / tests.

Split only when review would actually be hard (unrelated products, or a diff a reviewer cannot hold).

No TODO, no "follow-up", no "out of scope" unless he said so.

## Fast checks

Use Make. Scope to what changed.

Run the nearest package/app target (`make test`, `make lint`, `make typecheck`). Do not invent a parallel command if Make already wraps env and output paths.

Never Playwright, `test-e2e`, browser MCP, or "open the app" unless he asked.

Never `gh pr checks` or merge-gate polling.

## Project skills

Project-level tech skills always win.

If the repo has `.agents/skills/<name>/SKILL.md` for the files you touch, load that skill. Do not replace it with a personal copy or with memory of another repo.

Personal `go` and `react` are high-level only. They do not replace a project's api, sql, schema, or frontend skill.

Load only the matching project skill. Not the whole directory.

Then also load:

| Files | Personal |
|---|---|
| any code change | `less-code` |
| `*.go` | `go` |
| `*.tsx` / frontend `*.ts` | `react` |

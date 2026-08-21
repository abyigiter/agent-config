---
name: go
description: >-
  High-level Go defaults for Bugra: err naming, new(value), one TestX plus
  t.Run, Makefile first, no Go tutorials unless the change needs it. Use when
  writing or reviewing Go in any repo. Never replaces a project skill. If the
  repo has api, sql, schema, modern-go, or similar under .agents/skills/, load
  that first and follow it. Do not use for React/UI (react) or for
  another-repo stack rules copied from memory.
---

# Go

High-level Go only. Not a copy of any project skill.

## Project skills win

If the repo has a matching tech skill, read it and follow it. Do not override stack, layout, test harness, or Make targets from memory.

Look in the workspace (and parents / worktrees) for `.agents/skills/<name>/SKILL.md`. Typical names: `api`, `sql`, `schema`, `modern-go`, `oms-api`.

This personal skill still applies for: `err`, `new(value)`, test function shape, and "do not teach Go basics".

If there is no project Go skill, use this file as the default.

Also follow `development` (`~/.agents/skills/development/SKILL.md`) while coding.

## Defaults

- `err`. Rename only when two errors coexist (`rbErr` with `err`).
- `Field: new(value)`. Never `x := value; Field: &x`.
- Tests: one `TestSubject` per subject. Scenarios as `t.Run`. Never `TestSubject_Scenario`.
- If a Makefile exists, use `make` (or `make -C <dir> …`). Never bare `go test` / `go build` when Make already wraps env and output paths.
- Teach a Go idiom only when it is load-bearing for this change. He has ~2 years of backend. No tutorials.

## Language (when the project skill does not say otherwise)

Modern Go is a toolbox, not a mandate. Prefer the clear form.

| Instead of | Use |
|---|---|
| `interface{}` | `any` |
| `err == target` | `errors.Is` / `errors.As` |
| `fmt.Errorf("…: %s", err)` | `fmt.Errorf("…: %w", err)` |
| `for i := 0; i < n; i++` | `for i := range n` |
| `context.Background()` in tests | `t.Context()` |
| loop-variable capture workaround | drop it (Go 1.22+) |

Do not flatten data or add helpers only to look modern.

## Do not put here

Project RPC/IDL, DB helpers, auth, migrations, analytics warehouses. Those live in the project skill.

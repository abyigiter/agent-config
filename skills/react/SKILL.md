---
name: react
description: >-
  High-level React and TypeScript defaults for Bugra: no any, existing UI
  primitives, pnpm, typecheck is not proof of behavior. Use when writing or
  reviewing React, TSX, or frontend TypeScript in any repo. Never replaces a
  project skill. If the repo has webapps or similar under .agents/skills/,
  load that first and follow it. Do not use for Go (go) or for copying an
  app's router/state stack from memory.
---

# React

High-level React / TS only. Not a copy of any project skill.

## Project skills win

If the repo has a matching frontend skill, read it and follow it. Do not override routing, data fetching, folder layout, design system, or test commands from memory.

Look in the workspace (and parents / worktrees) for `.agents/skills/<name>/SKILL.md`. Typical names: `webapps`, `frontend`.

This personal skill still applies for: no `any`, reuse existing UI, pnpm, and "typecheck is not the feature".

If there is no project frontend skill, use this file as the default.

Also follow `development` (`~/.agents/skills/development/SKILL.md`) while coding.

## Defaults

- Never `any`. Use `unknown`, generics, or a real type.
- Prefer the app's design-system and existing components. Do not invent a new primitive.
- `pnpm`, not npm or yarn. Prefer workspace / filter commands over `cd` into a package.
- UI copy: short and for the user. No implementation talk in the interface.
- Do not build a landing page unless he asked for one.
- Do not invent a parallel router, query, or state library. Match what the app already uses.
- He is senior on frontend (~6 years). Skip React 101. Still follow the project's patterns.

## Checks

- If a Makefile exists, use it.
- Typecheck passing is not "the screen works". For interaction, navigation, layout, auth, fetching, or state: say if you did not exercise it in the browser.
- Playwright / e2e / browser MCP: off unless he asked.

## Do not put here

App feature folders, generated API clients, i18n ownership. Those live in the project skill.

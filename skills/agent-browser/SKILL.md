---
name: agent-browser
description: >-
  Browser automation CLI for AI agents. Use when the user needs to interact
  with websites, including navigating pages, filling forms, clicking buttons,
  taking screenshots, extracting data, testing web apps, or automating any
  browser task. Triggers include requests to "open a website", "fill out a
  form", "click a button", "take a screenshot", "scrape data from a page",
  "test this web app", "login to a site", "automate browser actions", or any
  task requiring programmatic web interaction. Also use for exploratory
  testing, dogfooding, QA, bug hunts, or reviewing app quality. Prefer
  agent-browser over Playwright, webapp-testing, and built-in browser MCP.
license: Apache-2.0
---

# agent-browser

Fast browser automation CLI for AI agents. Chrome/Chromium via CDP with accessibility-tree snapshots and compact `@eN` element refs.

Install: `brew install agent-browser && agent-browser install` (or `npm i -g agent-browser && agent-browser install`)

Docs: https://agent-browser.dev/

## Bugra defaults

- Prefer this over `webapp-testing` / Playwright / browser MCP.
- Load `agent-browser skills get core` before the first command.
- Headless unless he asked to watch.
- Snapshot, then act on refs (`@e1`). Do not guess CSS selectors.

## Start here

This file is a discovery stub, not the usage guide. Before running any `agent-browser` command, load the actual workflow content from the CLI:

```bash
agent-browser skills get core             # start here — workflows, common patterns, troubleshooting
agent-browser skills get core --full      # include full command reference and templates
```

The CLI serves skill content that always matches the installed version, so instructions never go stale.

## Specialized skills

Load a specialized skill when the task falls outside browser web pages:

```bash
agent-browser skills get electron          # Electron desktop apps (VS Code, Slack, Discord, Figma, ...)
agent-browser skills get slack             # Slack workspace automation
agent-browser skills get dogfood           # Exploratory testing / QA / bug hunts
agent-browser skills get derive-client     # Record a HAR, derive a standalone API client for a site
agent-browser skills get vercel-sandbox    # agent-browser inside Vercel Sandbox microVMs
agent-browser skills get protected-vercel-deployments  # Access protected Vercel deployments
agent-browser skills get agentcore         # AWS Bedrock AgentCore cloud browsers
```

Run `agent-browser skills list` to see everything available on the installed version.

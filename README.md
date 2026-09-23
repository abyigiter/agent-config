# agent-config

Portable brain for Claude, Codex, Cursor, Hermes, and OpenCode.

This is the stuff I install on a new machine so the agent stops:

- writing like a LinkedIn ghost
- inventing a helper "for later"
- saying "Hope this helps"
- using an em dash like it pays rent

It is allowed to write less code than it wanted to. That is the whole product.

```bash
git clone git@github.com:abyigiter/agent-config.git ~/agent-config
~/agent-config/install.sh
```

Symlinks. Not a framework. If you want a platform, you are already lost.

## What lives here

| Path | Job |
|---|---|
| `AGENTS.md` | House rules. One file. No vibes doc. |
| `SOUL.md` | Always-on voice (ADHD). Linked into Claude, Codex, and Hermes. |
| `skills/` | How to code, review, debug, and draft Slack |
| `cursor/rules/` | Cursor rules. ADHD is always on. Wiki schema is globbed to `wiki/**` and `raw/**`. |
| `hermes/SOUL.md` | Symlink to `SOUL.md`. Hermes loads `~/.hermes/SOUL.md`. |
| `opencode/opencode.json` | OpenCode via OpenRouter. Grok 4.7 default, Fable planner, DeepSeek implementer. All OpenRouter models in the picker. ClickHouse, Bruin, Lightdash, Allium, Figma (desktop), Google Drive MCPs. Slack off. |

`CLAUDE.md` says `@SOUL.md`. Project `AGENTS.md` still wins in a repo.

## Personality, in skills

**Always on**

| Skill | Use |
|---|---|
| `i-have-adhd` | First line is the next action. Lists cap at 5. No closer. |

**Write code**

| Skill | Use |
|---|---|
| `less-code` | Climb the ladder. YAGNI. Reuse. Then the smallest diff. |
| `development` | One story, one PR. No "follow-up". Make, not vibes. |
| `test-driven-development` | Failing test first. Then the implementation. |
| `go` | `err`, `new(value)`, one `TestX`. Project skills still win. |
| `react` | No `any`. Existing UI. Typecheck is not the screen working. |

**Think first**

| Skill | Use |
|---|---|
| `brainstorming` | Design before typing. Get a nod. |
| `implement-feature` | Plan mode, then the full slice. |
| `writing-design-proposals` | An RFC a human can actually follow. |
| `systematic-debugging` | Root cause. Symptom patches are failure. |
| `handoff` | Compact this chat for the next agent. You have to ask. |

**Talk to humans**

| Skill | Use |
|---|---|
| `message` | Slack is chat. `yeah` not `Yes`. One markdown fence. |
| `pr-comment-review` | Post the review. No draft. No stacked counter-PR. |
| `fix-pr-comments` | Author mode. Every bot nit. No "later". |

**Stolen, on purpose**

| Skill | Use |
|---|---|
| `find-skills` | Search skills.sh |
| `vercel-react-best-practices` | Vercel React/Next performance |
| `web-design-guidelines` | UI/a11y review |
| `performance` | Core Web Vitals |
| `agent-browser` | Browser CLI. Prefer over Playwright |
| `webapp-testing` | Playwright fallback |
| `figma-code-connect` | `.figma.ts` templates. Not `.figma.tsx`. |

## Local overlay

Work stuff that must not hit GitHub lives in `local/` (gitignored).

```text
local/AGENTS.append.md      glued onto ~/AGENTS.md
local/skills/<name>/        extra skills, same symlink treatment
```

No `local/` folder? Clone stays generic. That is the point.

## What the installer links

```text
~/AGENTS.md
~/CLAUDE.md
~/.claude/CLAUDE.md
~/.claude/AGENTS.md
~/.claude/SOUL.md
~/.codex/AGENTS.md
~/.codex/SOUL.md
~/.agents/skills/<skill>
~/.claude/skills/<skill>
~/.codex/skills/<skill>
~/.cursor/rules/*.mdc
~/wiki/AGENTS.md              (if ~/wiki exists; wiki schema, not always-on)
~/.hermes/SOUL.md
~/.hermes/config.yaml
~/.hermes/skills/<skill>
~/.config/opencode/opencode.json
~/.config/opencode/AGENTS.md
```

OpenCode picks up skills from `~/.agents/skills` natively, so no extra links. Bruin, Lightdash, and Allium MCPs read tokens from `~/.config/opencode/{bruin,lightdash,allium}.token` (not in the repo). ClickHouse and Google Drive use OAuth: `opencode mcp auth <name>`. Figma uses the Figma desktop app's local MCP server (remote Figma MCP only allowlists other clients). Slack is disabled: its MCP needs a pre-registered Slack app.

## Not in this repo

Secrets, tokens, session history, SQLite, caches, and the `local/` overlay.

If it can get you fired or phished, it does not belong here.

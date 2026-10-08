# agent-config

Portable brain for Claude, Codex, Cursor, OpenCode, and Pi.

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
| `SOUL.md` | Always-on voice (ADHD). Linked into Claude and Codex. |
| `skills/` | How to code, review, debug, and draft Slack |
| `cursor/rules/` | Cursor rules. ADHD is always on. Wiki schema is globbed to `wiki/**` and `raw/**`. |
| `opencode/opencode.json` | OpenCode via OpenRouter. GLM 5.3 default, Fable planner, DeepSeek implementer. All OpenRouter models in the picker. ClickHouse, Bruin, Lightdash, Allium, Figma (desktop), Google Drive MCPs. Slack off. |
| `pi/settings.json` | Pi via OpenRouter. GLM 5.3 at high thinking by default, plus GPT-6.1 Sol / 6 Luna / 6 Astra, Grok 4.7, Claude Sonnet 5.5 / Opus 5.5 / Haiku 5.5, DeepSeek V4 Pro, Kimi K3, Qwen 3.8, and Muse Spark 1.3 in the model cycle. MCPs stay in a machine-local `~/.pi/agent/mcp.json`, not in the repo. |
| `pi/models.json` | Custom OpenRouter model defs Pi doesn't ship yet (Claude Haiku 5.5). |
| `.claude/agents/`, `.claude/commands/` | Claude Code subagents `scout` (Haiku 5.5), `planner` + `reviewer` (Opus 5.5, high effort), `worker` (Sonnet 5.5), and the same three chain commands. See [Claude subagents](#claude-subagents). |
| `pi/agents/`, `pi/prompts/` | Subagents via the [`pi-subagents`](https://github.com/nicobailon/pi-subagents) package. Builtin `scout` / `reviewer` / `worker` get model overrides in `pi/settings.json` (`subagents.agentOverrides`); custom `planner` (GPT-6.1 Sol, high) lives in `pi/agents/`. Non-Claude on purpose: Claude roles live in Claude Code. Chains: `/implement`, `/scout-and-plan`, `/implement-and-review`. |
| `pi/themes/` | Soft Catppuccin-Macchiato palette for the Pi TUI (`macchiato`, active by default). |

`CLAUDE.md` says `@SOUL.md`. Project `AGENTS.md` still wins in a repo.

## Personality, in skills

**Always on**

| Skill | Use |
|---|---|
| `adhd-output` | First line is the next action. Lists cap at 5. No closer. |

**Write code**

| Skill | Use |
|---|---|
| `less-code` | Climb the ladder. YAGNI. Reuse. Then the smallest diff. |
| `development` | One story, one PR. No "follow-up". Make, not vibes. |
| `go` | `err`, `new(value)`, one `TestX`. Project skills still win. |
| `react` | No `any`. Existing UI. Typecheck is not the screen working. |

**Think first**

| Skill | Use |
|---|---|
| `implement-feature` | Plan mode, then the full slice. |
| `writing-design-proposals` | An RFC a human can actually follow. |
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
| `vercel-react-best-practices` | Vercel React/Next performance |
| `web-design-guidelines` | UI/a11y review |
| `performance` | Core Web Vitals |
| `agent-browser` | Browser CLI. Prefer over Playwright |

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
~/.claude/agents/*.md
~/.claude/commands/*.md
~/.codex/skills/<skill>
~/.cursor/rules/*.mdc
~/wiki/AGENTS.md              (if ~/wiki exists; wiki schema, not always-on)
~/.config/opencode/opencode.json
~/.config/opencode/AGENTS.md
~/.pi/agent/settings.json
~/.pi/agent/models.json
~/.pi/agent/agents/*.md
~/.pi/agent/prompts/*.md
```

OpenCode picks up skills from `~/.agents/skills` natively, so no extra links. Bruin, Lightdash, and Allium MCPs read tokens from `~/.config/opencode/{bruin,lightdash,allium}.token` (not in the repo). ClickHouse and Google Drive use OAuth: `opencode mcp auth <name>`. Figma uses the Figma desktop app's local MCP server (remote Figma MCP only allowlists other clients). Slack is disabled: its MCP needs a pre-registered Slack app.

Pi reads skills from `~/.agents/skills` natively too. Its MCPs mirror the OpenCode set from the machine-local `~/.pi/agent/mcp.json` (not in the repo) and read the same token files. OAuth servers sign in with `pi mcp login <name>`.

## Pi subagents

After `./install.sh`, run `/reload` in pi (or start a new session).

| Agent | Model | Defined in |
|---|---|---|
| `scout` | GPT-6 Luna (low thinking) | `pi-subagents` builtin, model override in `pi/settings.json` |
| `planner` | GPT-6.1 Sol (high) | `pi/agents/planner.md` (read-only tools) |
| `reviewer` | GPT-6.1 Sol (high) | builtin + override |
| `worker` | GLM 5.3 Flash `:max` | builtin + override |

Other builtins (`researcher`, `oracle`, `delegate`, `evidence-auditor`, ...) inherit the session model.

Chains:

```
/implement add input validation to the signup handler      # scout -> planner -> worker
/scout-and-plan migrate auth to OAuth                       # scout -> planner, no edits
/implement-and-review add retry to the webhook client      # worker -> reviewer -> worker
```

Single agent or parallel, in plain English:

```
use scout to find where session tokens are validated
use reviewer to review my uncommitted changes
run 3 scouts in parallel: one for the API routes, one for the DB layer, one for the tests
```

Watching runs:

- FleetView sits under the editor and lists active runs. `/subagents-fleet` opens the live inspector: browse children, read transcripts, steer, or stop.
- Chains usually run async. Ask "show active async runs" to check on them.
- `/subagents-doctor` checks the setup. `/subagents-guide [topic]` has the built-in docs.

Notes:

- Each subagent is a separate `pi` process with a fresh context. Write tasks for someone who hasn't read the conversation.
- `pi-subagents` loads a repo's `.pi/agents/` by default (`agentScope: "both"`), and project agents win name collisions. Only run it in repos you trust.
- To change a builtin's model, edit `subagents.agentOverrides` in `pi/settings.json`. Don't copy a builtin into `pi/agents/`, because a same-name file replaces the bundled definition wholesale.
- The chain prompts embed a `js workflow` script (the `pi-subagents` workflow API). The legacy `chain` parameter is no longer supported.

## Claude subagents

The same four roles and chains as Pi, for Claude Code:

| Agent | Model | Tools |
|---|---|---|
| `scout` | Haiku 5.5 | Read, Grep, Glob, Bash (read-only) |
| `planner` | Opus 5.5, `effort: high` | Read, Grep, Glob |
| `reviewer` | Opus 5.5, `effort: high` | Read, Grep, Glob, Bash (read-only) |
| `worker` | Sonnet 5.5 | all |

```
/scout-and-plan migrate auth to OAuth                     # scout -> planner, no edits
/implement add input validation to the signup handler    # scout -> planner -> worker
/implement-and-review add retry to the webhook client    # worker -> reviewer -> worker (fix pass only if needed)
```

- The `polygon-core` plugin's `guard-agent-model-pin` hook blocks Agent calls that don't pass `model`. That parameter only takes aliases and overrides the frontmatter, so the commands pass `haiku` / `opus` / `sonnet` explicitly. The frontmatter full IDs still apply when you call an agent directly without the hook.
- `haiku` resolves to Haiku 4.5 by default. To get 5.5, set `"env": { "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-5-5" }` in the machine-local `~/.claude/settings.json` (not in the repo).

## Not in this repo

Secrets, tokens, session history, SQLite, caches, and the `local/` overlay.

If it can get you fired or phished, it does not belong here.

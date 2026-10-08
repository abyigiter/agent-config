#!/usr/bin/env zsh
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills" "$HOME/.cursor/rules" "$HOME/.config/opencode" "$HOME/.pi/agent"

if [[ -f "$repo_dir/local/AGENTS.append.md" ]]; then
  combined="$HOME/.agents/AGENTS.combined.md"
  cat "$repo_dir/AGENTS.md" "$repo_dir/local/AGENTS.append.md" > "$combined"
  ln -sfn "$combined" "$HOME/AGENTS.md"
  ln -sfn "$combined" "$HOME/.claude/AGENTS.md"
  ln -sfn "$combined" "$HOME/.codex/AGENTS.md"
  ln -sfn "$combined" "$HOME/.config/opencode/AGENTS.md"
else
  ln -sfn "$repo_dir/AGENTS.md" "$HOME/AGENTS.md"
  ln -sfn "$repo_dir/.claude/AGENTS.md" "$HOME/.claude/AGENTS.md"
  ln -sfn "$repo_dir/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
  ln -sfn "$repo_dir/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
fi

ln -sf "$repo_dir/CLAUDE.md" "$HOME/CLAUDE.md"
ln -sf "$repo_dir/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sfn "$repo_dir/SOUL.md" "$HOME/.claude/SOUL.md"
ln -sfn "$repo_dir/SOUL.md" "$HOME/.codex/SOUL.md"

link_skill() {
  local src="$1"
  local name="$2"
  for dest in "$HOME/.agents/skills/$name" "$HOME/.claude/skills/$name" "$HOME/.codex/skills/$name"; do
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      rm -rf "$dest"
    fi
    ln -sfn "$src" "$dest"
  done
}

skills=(
  agent-browser
  development
  fix-pr-comments
  go
  handoff
  adhd-output
  implement-feature
  less-code
  message
  performance
  pr-comment-review
  react
  vercel-react-best-practices
  web-design-guidelines
  writing-design-proposals
)
for s in "${skills[@]}"; do
  link_skill "$repo_dir/skills/$s" "$s"
done

if [[ -d "$repo_dir/local/skills" ]]; then
  for s in "$repo_dir/local/skills"/*; do
    [[ -d "$s" ]] || continue
    link_skill "$s" "$(basename "$s")"
  done
fi

# Keep Claude/Codex copies in lockstep with AGENTS.md for clones that have no local overlay.
sync_agents_copy() {
  local dest="$1"
  cmp -s "$repo_dir/AGENTS.md" "$dest" && return 0
  cp "$repo_dir/AGENTS.md" "$dest"
}
sync_agents_copy "$repo_dir/.claude/AGENTS.md"
sync_agents_copy "$repo_dir/.codex/AGENTS.md"

for f in "$repo_dir"/cursor/rules/*.mdc "$repo_dir"/local/cursor/rules/*.mdc(N); do
  [[ -f "$f" ]] || continue
  ln -sfn "$f" "$HOME/.cursor/rules/$(basename "$f")"
done

if [[ -d "$HOME/wiki" ]]; then
  ln -sfn "$repo_dir/cursor/rules/wiki.mdc" "$HOME/wiki/AGENTS.md"
fi

# Plugin cache re-applies on update. Re-run install after a GitLab/Granola plugin bump.
for f in "$HOME/.cursor/plugins/cache/cursor-public/gitlab/"*/rules/gitlab-workflow.mdc \
         "$HOME/.cursor/plugins/cache/cursor-public/granola/"*/rules/check-meeting-context.mdc; do
  [[ -f "$f" ]] || continue
  perl -i -pe 's/^alwaysApply: true$/alwaysApply: false/' "$f"
done

# ── OpenCode ─────────────────────────────────────────────────────────
ln -sfn "$repo_dir/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
for t in bruin lightdash allium; do
  [[ -f "$HOME/.config/opencode/$t.token" ]] || echo "  OpenCode $t MCP needs a token: put it in ~/.config/opencode/$t.token (chmod 600)"
done

# ── Pi ───────────────────────────────────────────────────────────────
ln -sfn "$repo_dir/pi/settings.json" "$HOME/.pi/agent/settings.json"
mkdir -p "$HOME/.pi/agent/themes"
ln -sfn "$repo_dir/pi/themes/"*.json "$HOME/.pi/agent/themes/"
ln -sfn "$repo_dir/pi/keybindings.json" "$HOME/.pi/agent/keybindings.json"
ln -sfn "$repo_dir/pi/models.json" "$HOME/.pi/agent/models.json"
mkdir -p "$HOME/.pi/agent/extensions" "$HOME/.pi/agent/agents" "$HOME/.pi/agent/prompts"
ln -sfn "$repo_dir/pi/extensions/subagent" "$HOME/.pi/agent/extensions/subagent"
ln -sfn "$repo_dir/pi/agents/"*.md "$HOME/.pi/agent/agents/"
ln -sfn "$repo_dir/pi/prompts/"*.md "$HOME/.pi/agent/prompts/"
# Pi already loads ~/AGENTS.md via the cwd chain; a ~/.pi/agent/AGENTS.md copy would double-load.
rm -f "$HOME/.pi/agent/AGENTS.md"
[[ -f "$HOME/.pi/agent/mcp.json" ]] || echo "  Pi MCPs are machine-local: create ~/.pi/agent/mcp.json (not in the repo)"

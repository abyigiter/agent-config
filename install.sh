#!/usr/bin/env zsh
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills" "$HOME/.cursor/rules" "$HOME/.hermes/skills"

if [[ -f "$repo_dir/local/AGENTS.append.md" ]]; then
  combined="$HOME/.agents/AGENTS.combined.md"
  cat "$repo_dir/AGENTS.md" "$repo_dir/local/AGENTS.append.md" > "$combined"
  ln -sfn "$combined" "$HOME/AGENTS.md"
  ln -sfn "$combined" "$HOME/.claude/AGENTS.md"
  ln -sfn "$combined" "$HOME/.codex/AGENTS.md"
else
  ln -sfn "$repo_dir/AGENTS.md" "$HOME/AGENTS.md"
  ln -sfn "$repo_dir/.claude/AGENTS.md" "$HOME/.claude/AGENTS.md"
  ln -sfn "$repo_dir/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
fi

ln -sf "$repo_dir/CLAUDE.md" "$HOME/CLAUDE.md"
ln -sf "$repo_dir/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

link_skill() {
  local src="$1"
  local name="$2"
  for dest in "$HOME/.agents/skills/$name" "$HOME/.claude/skills/$name" "$HOME/.codex/skills/$name" "$HOME/.hermes/skills/$name"; do
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      rm -rf "$dest"
    fi
    ln -sfn "$src" "$dest"
  done
}

skills=(
  agent-browser
  brainstorming
  development
  figma-code-connect
  find-skills
  fix-pr-comments
  go
  handoff
  i-have-adhd
  implement-feature
  less-code
  message
  performance
  pr-comment-review
  react
  systematic-debugging
  test-driven-development
  vercel-react-best-practices
  web-design-guidelines
  webapp-testing
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

# ── Hermes Agent ─────────────────────────────────────────────────────
if command -v hermes &>/dev/null; then
  mkdir -p "$HOME/.hermes"
  ln -sf "$repo_dir/hermes/config.yaml" "$HOME/.hermes/config.yaml"

  # Link custom skins
  mkdir -p "$HOME/.hermes/skins"
  for skin in "$repo_dir"/hermes/skins/*.yaml; do
    [[ -f "$skin" ]] && ln -sf "$skin" "$HOME/.hermes/skins/$(basename "$skin")"
  done

  if [[ ! -f "$HOME/.hermes/.env" ]]; then
    cp "$repo_dir/hermes/.env.template" "$HOME/.hermes/.env"
    chmod 600 "$HOME/.hermes/.env"
    echo "  Created ~/.hermes/.env — edit it with your API keys: $EDITOR ~/.hermes/.env"
  fi
fi

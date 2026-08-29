#!/usr/bin/env zsh
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills" "$HOME/.cursor/rules"

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
  for dest in "$HOME/.agents/skills/$name" "$HOME/.claude/skills/$name" "$HOME/.codex/skills/$name"; do
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      rm -rf "$dest"
    fi
    ln -sfn "$src" "$dest"
  done
}

skills=(
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

ln -sfn "$repo_dir/cursor/rules/i-have-adhd.mdc" "$HOME/.cursor/rules/i-have-adhd.mdc"

# ── Hermes Agent ─────────────────────────────────────────────────────
if command -v hermes &>/dev/null; then
  mkdir -p "$HOME/.hermes"
  ln -sf "$repo_dir/hermes/config.yaml" "$HOME/.hermes/config.yaml"
  if [[ ! -f "$HOME/.hermes/.env" ]]; then
    cp "$repo_dir/hermes/.env.template" "$HOME/.hermes/.env"
    chmod 600 "$HOME/.hermes/.env"
    echo "  Created ~/.hermes/.env — edit it with your API keys: $EDITOR ~/.hermes/.env"
  fi
fi

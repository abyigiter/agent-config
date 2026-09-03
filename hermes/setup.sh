#!/usr/bin/env zsh
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"

echo "→ Linking Hermes config..."
mkdir -p "$HOME/.hermes"
ln -sf "$repo_dir/hermes/config.yaml" "$HOME/.hermes/config.yaml"

echo "→ Linking Hermes skins..."
mkdir -p "$HOME/.hermes/skins"
for skin in "$repo_dir"/hermes/skins/*.yaml; do
  name="$(basename "$skin")"
  ln -sf "$skin" "$HOME/.hermes/skins/$name"
  echo "  Linked $name"
done

echo "→ Setting up .env (if not already present)..."
if [[ ! -f "$HOME/.hermes/.env" ]]; then
  cp "$repo_dir/hermes/.env.template" "$HOME/.hermes/.env"
  chmod 600 "$HOME/.hermes/.env"
  echo "  Created ~/.hermes/.env — edit it with your API keys:"
  echo "  $EDITOR ~/.hermes/.env"
else
  echo "  ~/.hermes/.env already exists — skipping."
fi

echo "→ Hermes setup done."
---
description: Claude's built-in /code-review via the claude CLI, always posting inline PR comments. Args pass through, e.g. `high 42`.
---
Run this command exactly once and print its output unchanged. Do nothing else.

```bash
claude -p "/cr $@"
```

`/cr` always adds `--comment` and writes a structured review body, so findings post as inline comments on the PR. Give it a PR number or URL.

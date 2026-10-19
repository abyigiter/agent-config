---
description: Scout gathers context, planner writes the plan, worker (GLM 5.3 Flash via Pi) implements it.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `planner` -> `opus`.

1. Use the `scout` subagent to find all code relevant to: $ARGUMENTS
2. Use the `planner` subagent to create an implementation plan for "$ARGUMENTS". Pass it the scout's full output and the original request.
3. Implement with GLM 5.3 Flash through the Pi CLI, not the Agent tool:
   1. Write `<scratchpad>/implement-handoff.md` with: the original request, the planner's full plan verbatim, and the worker instructions from `~/.claude/agents/worker.md` (body only, no frontmatter).
   2. From the repo root, run with Bash, `run_in_background: true`:
      `pi -p --no-session --model openrouter/z-ai/glm-5.3-flash:nitro --thinking max @<scratchpad>/implement-handoff.md "Implement the plan in the attached file."`
   3. When it finishes, read its output and check `git status` / `git diff --stat` to confirm the edits landed.

Return the worker's report, plus the diff stat.

---
description: Read-only check of devops/ArgoCD manifest changes across dev and stg for drift, missing config, and rollout risk.
argument-hint: [app or path, default current diff]
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `reviewer` -> `opus`. Nothing edits files.

1. Use the `scout` subagent. Task: for the changed apps (from the current diff, or "$ARGUMENTS" if given), collect the matching manifests, values, and appset entries in every environment (dev, stg, and prod if present). Return them side by side with file paths.
2. Use the `reviewer` subagent. Pass it the scout's output and the diff. Check and report only:
   - Env drift: keys, image tags, replicas, resources, or flags that differ between envs without a reason.
   - Missing or renamed config: env vars, secrets, ConfigMaps, or ExternalSecrets referenced but not defined in an env.
   - Rollout risk: breaking selector or label changes, probe changes, resource limit drops, sync-wave or ordering problems, anything that needs a manual step.
   Each finding gets file:line, the env affected, and the fix.

Return the findings grouped by env, then a one-line verdict: safe to roll out, or blocked by N items.

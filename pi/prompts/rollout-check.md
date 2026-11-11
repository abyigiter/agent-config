---
description: Read-only check of devops/ArgoCD manifest changes across dev and stg for drift, missing config, and rollout risk
---
Scope (empty means the current diff): $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string. Set TASK to the scope, or "the current diff" when empty.

```js workflow
const TASK = "<scope>";
const scout = await runs.run("scout", { agent: "scout", task: "For the changed apps in " + TASK + ", collect the matching manifests, values, and appset entries in every environment (dev, stg, and prod if present). Return them side by side with file paths." });
return runs.run("check", { agent: "reviewer", task: "Scope: " + TASK + "\n\nManifests per env:\n" + scout.output + "\n\nCheck and report only, edit nothing:\n- Env drift: keys, image tags, replicas, resources, or flags that differ between envs without a reason.\n- Missing or renamed config: env vars, secrets, ConfigMaps, or ExternalSecrets referenced but not defined in an env.\n- Rollout risk: breaking selector or label changes, probe changes, resource limit drops, sync-wave or ordering problems, anything needing a manual step.\nEach finding gets file:line, the env affected, and the fix." });
```

Return the findings grouped by env, then a one-line verdict: safe to roll out, or blocked by N items.

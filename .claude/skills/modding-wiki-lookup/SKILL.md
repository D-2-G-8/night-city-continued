---
name: modding-wiki-lookup
description: Look up how something is done in Cyberpunk 2077 / REDengine modding — file formats, frameworks (ArchiveXL, Codeware, TweakXL, redscript, RED4ext), world editing, WolvenKit or Blender workflows. Use this instead of answering from memory whenever REDengine-specific behaviour, an API or a file format is involved.
---

# Modding wiki lookup

REDengine modding is thinly covered in training data and shifts with each framework
release. Guessing here produces confident, wrong answers that cost hours in the lab.
Look it up.

## Where to look, in order

1. **Modding wiki** — `https://wiki.redmodding.org/cyberpunk-2077-modding`
   Built for agents: it serves `llms.txt`, markdown versions of pages, and an `?ask=`
   endpoint for direct questions.
2. **World editing section** — sectors, node removal, occluders, collisions:
   `https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/world-editing`
3. **The framework's own repo** — README and release notes for ArchiveXL, Codeware,
   TweakXL, redscript, RED4ext, World Builder, the Blender add-on.
4. **Existing code in this repo** — `core/`, `lab/harness/`, merged recipes.

## Rules

- Check findings against the versions pinned in `deps.lock.md`, not the latest release.
- If the wiki and a forum post disagree, trust the wiki.
- If you cannot confirm something, say so and mark it `[spike]` rather than guessing.
  An unverified claim in a design doc is worse than an open question.
- Record anything hard-won in `docs/runbooks/` so nobody has to re-derive it.

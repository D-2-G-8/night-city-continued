# .claude/

Claude Code configuration shared by everyone working on this repository.

| Path | What it is |
|---|---|
| `settings.json` | Permission rules. Committed, applies to everyone |
| `skills/` | Task workflows loaded on demand or by `paths` frontmatter |
| `agents/` | Subagents that keep noisy work out of the main context |
| `settings.local.json` | **Per-machine** overrides. Gitignored — never commit it |

## Permission rules

`deny` covers things that must never happen from an agent: reading secrets, force-pushing,
hard resets, and editing signed release manifests or author permission files (those are
evidence, not code — they change only by a human).

`ask` covers things that are legitimate but expensive to get wrong: commits and pushes,
the pinned dependency list, the core API, the lab host and guest scripts (a mistake there
runs untrusted code on the host), governance policy, and CI workflows.

## The validation hook

`tools/hooks/validate-changed.ps1` is a syntax gate for edited JSON, YAML and PowerShell
files. It is **not** wired up in `settings.json`, because the hook needs `pwsh` and the
macOS side of this project does not have PowerShell installed — a hook pointing at a
missing binary fails silently on every edit, which is worse than no hook.

Enable it per machine in `.claude/settings.local.json` (gitignored) once `pwsh` is present:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -NoProfile -File ./tools/hooks/validate-changed.ps1"
          }
        ]
      }
    ]
  }
}
```

Check it works before trusting it:

```powershell
pwsh -NoProfile -File ./tools/hooks/validate-changed.ps1 -Path ./some-file.json
```

## Local paths

Game install path, lab VM name and model files are personal. They belong in
`CLAUDE.local.md` (gitignored), never in a committed file.

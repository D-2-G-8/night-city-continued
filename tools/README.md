# tools/

Build, deploy and release scripts. PowerShell 7 (`pwsh`), Windows.

| Script | Purpose |
|---|---|
| `build.ps1` | Build a module, pack, recipe, or everything |
| `deploy.ps1` | Copy a build into a local game install for manual checking |
| `release.ps1` | Cut a release: manifest, SHA-256, minisign signature |
| `hooks/validate-changed.ps1` | Syntax gate for edited JSON/YAML/PS1 — see `.claude/README.md` |

These scripts are written on macOS and verified on Windows. Until a script has actually
been run on Windows, treat it as a draft.

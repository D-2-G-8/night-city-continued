@AGENTS.md

## Claude Code specifics

Everything above applies. This section is Claude Code only.

### Plan mode first

Use plan mode before touching:

- `core/` public API, facts, or anything that changes `dataVersion`
- `lab/runner/` and `lab/guest/` (a mistake here runs untrusted code on the host)
- `launcher/` signature and hash verification
- `deps.lock.md`, `releases/`, `governance/`

### Skills

Invoke by name when the task matches. Most load automatically via their `paths` frontmatter.

| Skill | Use it for |
|---|---|
| `modding-wiki-lookup` | Any REDengine modding question — before guessing |
| `new-recipe` | Adding or updating a community mod |
| `license-audit` | Checking licenses, attribution, `THIRD_PARTY.md` |
| `lab-scenario` | Writing or updating lab scenarios and points |
| `lab-report-triage` | A lab run failed — diagnose it |
| `release` | Running the release train (manual invocation only) |
| `rfc-adr` | Drafting an RFC or ADR |

### Subagents

Delegate to keep the main context clean:

- `license-reviewer` — noisy ScanCode output, recipe license tiers
- `lab-triager` — large log files and lab run artifacts
- `autonomy-guardian` — review any PR touching `services/brain/` or `core/verbs/` against ADR-008
- `saves-compat-reviewer` — review any PR that touches save data
- `modding-researcher` — research REDengine modding without polluting this context

### Local notes

Personal paths (game install, lab VM name, model files) belong in `CLAUDE.local.md`,
which is gitignored. Never commit a local path.

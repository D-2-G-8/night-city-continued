---
name: rfc-adr
description: Draft an RFC for a proposed change or an ADR recording a decision. Use when a change touches core API, schemas, save data, a new module or system mechanic, or any policy in governance/.
---

# RFC and ADR

**RFC** = a proposal, written before the code. **ADR** = a decision, recorded once made.

## When an RFC is required

- A new module, or any change to `core-api`
- Any schema change (`ncc-pack`, `ncc-recipe`, `brain api`)
- Anything touching save data or `dataVersion`
- A new system mechanic (track S)
- Any change under `governance/`
- Anything that weakens lab isolation

## RFC template — `docs/rfc/NNNN-<slug>.md`

```markdown
# RFC NNNN: <title>
Status: draft | discussion | accepted | rejected
Track: <P|E|T|W|L|N|S|I|M|C>
Author: <name>

## Problem
What is actually broken or missing. No solution here.

## Proposal
What we would do.

## Alternatives
What else was considered and why it lost. An RFC with no alternatives is not an RFC.

## Impact
- Save compatibility:
- Core API / schemas:
- Existing mods in recipes:
- Lab coverage:
- Migration plan:

## Open questions
```

## ADR template — `docs/adr/NNNN-<slug>.md`

```markdown
# ADR NNNN: <title>
Status: accepted | superseded by ADR-NNNN
Date: YYYY-MM-DD

## Context
The situation and constraints at the time.

## Decision
What we decided, in the active voice.

## Consequences
What this makes easy, what it makes hard, what we accept as the cost.
```

Write the consequences honestly, including the bad ones. An ADR that lists only benefits is
useless to whoever revisits the decision in a year.

Keep both numbered, never renumber, and mark superseded decisions rather than deleting them.

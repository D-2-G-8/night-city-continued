# ADR-011: An author can leave, at any tier, without giving a reason

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** E — Ecosystem
- **Extends:** ADR-005 (recipes, not copies)

## Context

Curated distributions and their authors have collided over one question, repeatedly: who
decides whether a mod appears in a collection.

In 2021 Nexus Mods stopped honouring author deletion requests, keeping archival copies so
that Collections would not break — a single deletion makes a curated list uninstallable.
Authors asked for one thing: the ability to decide whether their mod is included at all.
Nexus declined an opt-in for the same reason it declined deletion, and gave authors a month
to accept or leave.

Arthmoor, who maintains the Unofficial Patches that a large part of the Skyrim ecosystem
depends on, removed his mods from the site. His stated reason was that had authors been able
to opt out of mod packs, the mods would have stayed. The downstream effect was the one the
community already understood: removing a prerequisite instantly breaks everything built on it.

The objection is not abstract. An automated pack takes the author's downloads, endorsements
and donation traffic and routes it past their page.

ADR-005 already grants the right to leave, as one line among the consequences. This project
has the same shape as the thing that caused that rupture, so the right needs to be a stated
commitment rather than an implication, and the mechanics need to exist before anyone asks.

## Decision

**An author may have their mod removed from this project at any time, at any tier, without
giving a reason, and the request is honoured.**

Specifics:

1. **Inclusion at `included` is opt-in.** It requires a permissive license or written
   permission. It is never assumed and never inferred from silence.
2. **Removal covers every tier, including `compat`.** A compatibility-table entry names
   someone's work; an author who does not want to be listed is delisted.
3. **No reason is required, and none is asked for.** No review, no appeal, no negotiation.
4. **We keep no archival copy to keep a release installable.** When an author leaves, the
   files go. ADR-009 is what keeps releases working without holding anything hostage.
5. **Timing:** removed from `dev` on the next working day, and from the next release. A
   published release already on players' disks is not recalled; the component simply becomes
   unavailable, which ADR-009 handles.
6. **A withdrawal is recorded** in `governance/permissions/<mod-id>.md` alongside any earlier
   grant, with its date. The record exists so the decision is not re-litigated by whoever
   picks up the recipe next.
7. **The route is published** in `governance/author-rights.md`, reachable without reading
   the contributor documentation, and stated on the contributors page.

Downgrading a tier is the same right exercised partially, and follows the same process.

## Consequences

- A release can lose a component at short notice. ADR-009 makes that survivable; without
  ADR-009 this decision would be unaffordable.
- A widely depended-on recipe leaving will break dependent modules. The compatibility table
  records it and the affected modules degrade, which is the same path as any unavailable
  component.
- We cannot promise a stable, complete distribution over time. What we can promise is that
  nothing in it is there against its author's wishes.
- An author acting in bad faith could add and remove a recipe repeatedly. Not worth
  designing against: the cost is ours, the right is theirs.
- Honouring removal without archiving means some historical releases become permanently
  degraded. Accepted, and recorded in the compatibility table.

## Alternatives considered

- **Keep archival copies so releases stay installable.** The choice Nexus made. It solves
  the distribution problem and takes the decision away from the author, which is the whole
  dispute.
- **Opt-out at `included` only, since `linked` and `compat` need no permission.** Legally
  sufficient and misses the point: authors objected to being in a pack, not to file hosting.
- **Require a reason, to distinguish genuine objections from misunderstandings.** Turns a
  right into a request, and puts the maintainer in the position of judging it.

# ADR-004: Content is schema-backed data, validated automatically

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** P — Platform

## Context

Content packs — districts, locations, stories, resident biographies — are meant to be written
by people who are not programmers, and there are meant to be a lot of them. If every pack can
ship code, then every pack is a potential crash, an unreviewable diff, and a security problem
in the lab.

## Decision

**A content pack is data and declarations. No code.**

Every pack declares itself in `pack.json` against the `ncc-pack/N` schema: dependencies,
facts namespace, sectors, claimed vanilla nodes, lab points, license, authors. Agent
biographies are `content/<pack>/agents/*.yaml` — who this person is and where they came from,
and nothing about what they will do.

Behaviour that a pack wants but cannot express belongs in a **module**, which does ship code
and goes through the module review path.

The validator (`sdk/Validator`) checks every pack in CI. A pack that fails its schema does
not merge.

## Consequences

- A pack author needs a text editor and the templates, not a toolchain.
- Pack review is reading data, which a reviewer can actually do.
- The lab can run an untrusted pack with far less risk than untrusted code.
- Conflicts between packs are detectable: `claimsVanillaNodes` is a registry, and CI can see
  two packs claiming the same node before players do.
- The schema will feel restrictive, and authors will hit its edges. That pressure is the
  signal for what the core API should expose next — the same way `unmet_intents` drives the
  action vocabulary (ADR-008).
- Every schema change is a versioned, backwards-compatible event, not a quick edit.

## Alternatives considered

- **Let packs ship Lua.** Fastest for authors, and it makes packs unreviewable, unsafe in the
  lab, and impossible to keep working across game patches.
- **No schema, convention only.** Rejected: it means breakage is found by players.

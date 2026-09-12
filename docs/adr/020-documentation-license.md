# ADR-020: Documentation is CC BY 4.0; code samples inside it are MIT

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** C — Community

## Context

The platform's code, SDK and schemas are MIT. The documentation — guides, runbooks, the tech
doc, ADRs — had no stated licence, which means it defaulted to "all rights reserved" and
could not be quoted, translated or built on.

Documentation for a modding project is meant to be reused: translated into other languages,
quoted in community wikis, adapted into tutorials. A licence that permits that is the point.

## Decision

**Prose documentation is CC BY 4.0.** Attribution is required; everything else is permitted,
including commercial reuse and adaptation.

**Code samples inside documentation are MIT**, like the rest of the project's code. Someone
copying a snippet from a guide into their own mod should not acquire an attribution
obligation from having read it in our docs rather than in the repository.

Both licences are stated in `docs/README.md` and in the repository's `LICENSE` notes.

## Consequences

- Translations, wiki quotations and derivative tutorials are all permitted without asking.
  Translations into other languages are one of the more valuable things a community does, and
  a licence should not be in the way.
- CC BY permits commercial reuse, including someone repackaging our guides behind their own
  advertising. Accepted: the alternative restricts far more legitimate reuse than it prevents
  opportunism, and attribution still points home.
- Two licences in one repository needs saying clearly, or contributors will assume one covers
  everything. `docs/README.md` states the split and where the boundary falls.
- Contributions to documentation are accepted under CC BY 4.0, which needs to be stated in
  `CONTRIBUTING.md` so nobody contributes under an assumption they did not make.

## Alternatives considered

- **CC BY-SA 4.0.** Reciprocity is attractive, and it makes our documentation unusable in
  differently licensed community wikis, which is the main place we would want it quoted.
- **MIT for everything, prose included.** Works legally and reads oddly for prose; CC BY is
  what documentation reuse is normally expressed in, and being conventional here helps people
  understand what they may do.
- **No licence.** The status quo, which grants nothing and blocks translation.

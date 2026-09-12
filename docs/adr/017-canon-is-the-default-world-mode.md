# ADR-017: Canon is the default world mode

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** L — Life
- **Extends:** ADR-008 (agent autonomy)

## Context

ADR-008 gives the player two world modes and left the default open:

- **Canon** — story NPCs obey an active quest scene while it runs, and are free outside it;
- **Full freedom** — nobody is protected, and the main story can break.

The default is not a small setting. It decides what happens to someone who installs this
platform onto a playthrough already in progress and changes nothing.

Two pieces of evidence bear on it. Project Sid, which put a thousand autonomous agents in a
shared world, found that when the public was let in they experienced the agents as
frustratingly independent — pursuing their own agendas instead of responding to requests.
That is autonomy working correctly, and it is also a first impression. Separately, the most
common complaint about ambitious mods is that they broke an existing save or an existing
questline.

## Decision

**Canon is the default. Full freedom is an informed opt-in.**

Full freedom is presented in settings with a plain description of what it permits, including
that the main story can break and that this is not a bug.

## Consequences

- A player who installs the platform mid-playthrough does not lose the story they were in the
  middle of. Story NPCs are still autonomous everywhere outside active quest scenes, which is
  where almost all of the city's life happens.
- **Canon is testable; Full freedom is not, in the same sense.** Under Canon, a quest scene is
  an invariant the lab can assert. Under Full freedom the space of outcomes is unbounded by
  design, so the L-track test suite is built against Canon and Full freedom is exercised for
  stability rather than for correctness of outcomes.
- Shipping Full freedom as the default would make "the story broke" the most common bug
  report the project receives, and every one of them would be working as intended. That
  consumes the maintainer attention the project does not have.
- Players who want the uncompromised version have to find a setting. That is the smaller
  cost, and the setting is not hidden.
- This does not soften ADR-008. The world mode constrains *when the model is consulted about
  story characters*, never what it may decide.

## Alternatives considered

- **Full freedom as the default**, on the grounds that it is the honest expression of the
  project's design. Rejected: a default that can destroy an unfinished playthrough is not a
  default, it is an ambush.
- **No default — ask on first run.** Considered and rejected as a first-run question the
  player has no basis to answer. They have not met the agents yet.
- **Canon only, with Full freedom added later once the systems are proven.** Tempting, and it
  would mean the mode that expresses the project's intent is the one nobody can try. Both
  ship.

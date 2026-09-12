# ADR-015: World events may be directed; agent decisions may not

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** L — Life
- **Extends:** ADR-008 (agent autonomy)

## Context

ADR-008 forbids writing NPC behaviour and lists the disguises that erosion arrives in.
It does not say where the forbidden zone ends, and two bodies of evidence sit right on the
boundary.

RimWorld is built around an AI storyteller modelled on the Left 4 Dead AI Director: it reads
the player's situation and decides which event makes the best story. The game is explicitly a
story generator rather than a strategy game, and the director exists because unmediated
simulation trends toward monotony.

Project Sid, running a thousand autonomous agents in Minecraft, reports the same thing from
the other direction: the researchers had to introduce things into the society to keep it from
collapsing. Its other finding is worth holding onto — when the public was let in, they found
the agents frustratingly independent, pursuing their own agendas rather than following
requests. That is ADR-008 working as designed, and it is also what players experienced.

Read carelessly, this is an argument for softening ADR-008. It is not, because a director does
not decide what a character does. It decides **what happens to the world** — a raid, a storm,
a caravan, a bounty. Every character, agent or otherwise, still chooses its own response.

Without this distinction written down, the first RFC that proposes a world-event system will
be argued by both sides citing the same paragraph of ADR-008.

## Decision

**Modules may introduce events into the world. Nothing may reach into an agent's decision.**

### Allowed

A module may create, schedule or weight **events and conditions in the world**:

- a gang moving on a district, a police sweep, a blackout, a storm, a shipment arriving;
- prices, scarcity, who controls what, who is looking for whom;
- a bounty existing, a job being available, a rumour circulating.

These change what an agent perceives and what its options cost. They are world state, and
they reach agents the same way everything else does — through perception.

### Forbidden

Nothing may alter, bias, veto, pre-empt or override what an agent decides:

- no weighting, scoring or ranking of an agent's candidate actions;
- no vetoing or substituting an intent the model returned;
- no injecting goals, moods or instructions into an agent to obtain a chosen outcome;
- no filtering the vocabulary per agent or per situation to steer a choice;
- no "the story needs X, so make this agent do X".

### The test

For any proposed mechanism, ask: **if it were removed, would an agent's set of available
choices change?**

- If it changes only **what the agent must respond to** — allowed. It is world state.
- If it changes **what the agent may choose, or how likely a choice is** — forbidden by
  ADR-008.

A director that makes a raid happen is world state. A director that makes an agent flee is
behaviour.

### Honest limits

A sufficiently targeted event is steering by another name — an event aimed at one agent,
timed to force one outcome, is behaviour writing with extra steps. Events are therefore
declared at the level of a place, a faction or a population, never at the level of a named
agent, and `autonomy-guardian` reviews event systems against that.

## Consequences

- The project can address pacing, monotony and collapse — the failure modes both sources
  report — without touching agent decisions.
- Events become a legitimate and reviewable design surface, which is where effort that would
  otherwise go into behaviour systems can go instead.
- The boundary is stated as a test rather than a list, so it survives contact with proposals
  nobody has thought of yet.
- Population-level scoping means fine narrative control remains unavailable. A specific agent
  cannot be made to be somewhere at a specific time for a story beat. Quest scenes remain the
  mechanism for that, under the world mode in ADR-008.
- Directed events shift outcomes statistically even though no decision was touched. That is
  design working; it stops being acceptable at the point an event is built around one agent.

## Alternatives considered

- **Forbid directed events entirely.** The strictest reading of ADR-008. Rejected: it forbids
  weather, gang wars and the economy, none of which are NPC behaviour, and it leaves the
  monotony both sources documented with no available remedy.
- **Allow a director to nudge agent decisions when the simulation stalls.** The pragmatic
  industry answer, and precisely the erosion ADR-008 predicts. A stalling simulation is a
  finding about perception, memory or vocabulary.
- **Leave it to case-by-case RFC judgement.** What the absence of this ADR already produces:
  each case argued from first principles, with the answer depending on who reviews it.

# services/brain/ — agent rules

.NET 10 service that gives NPCs perception, memory, reflection and decisions.

## ADR-008 governs everything in this directory

**The LLM decides what and why. The engine executes how.**

Developers extend what agents *can* do and *can* perceive. Developers never write what
agents *will* do. If you are about to write any of these, stop — you are breaking the core
design:

- ❌ behaviour trees, state machines or utility scores that pick an NPC's action
- ❌ schedules, routines or goals assigned by us ("bartender works 18:00–02:00")
- ❌ a whitelist of "allowed" actions, action caps, or policy limits on decisions
- ❌ hardcoded reactions ("if player draws weapon, then flee")
- ❌ scripted dialogue trees

These feel like good engineering and they are the exact failure mode to avoid. An action
being *possible* is an engine question. An action being *chosen* is the model's question.

What you may add freely:

- ✅ new verbs (what a body can do) — in `core/verbs/`
- ✅ new perception channels (what an agent can notice)
- ✅ better memory, reflection and retrieval
- ✅ inference scheduling, batching, LOD, model routing
- ✅ translation of an intent into engine commands, and results back into observations

## Perception has no omniscience

An agent only receives what it could plausibly see, hear or know. Never feed it player
state, quest flags, other agents' thoughts, or world data it has no access to. If an agent
knows something, there must be an observation that delivered it.

**But an agent does know its own body.** Perception includes an accurate account of the verbs
available to it and whether each is feasible here and now — the way a person knows whether
they can drive, whether they are armed, and whether this door is one they can open.

This is not a limit on the decision; it removes a blind spot. Every shipped LLM-NPC system
hits the same wall: a character that can say anything makes players expect it can do
anything, and the gap between what it agrees to and what the engine performs is where the
illusion dies. An agent that knows it cannot fly can refuse, bargain, lie about why, or try
anyway and fail. An agent that does not know is simply wrong.

When an agent commits to something outside the vocabulary, log the commitment to
`unmet_intents` like any unmet intent. What a character promised a player is the strongest
signal we get about what the vocabulary is missing.

## Memory records provenance

Every memory carries how the agent came by it — **observed**, **heard from `<source>`**, or
**inferred** — and confidence travels with it.

Agents can be lied to, and that is worth keeping: deception between characters, and by the
player, is one of the better things autonomy makes possible. Provenance prevents the
documented failure where a crafted conversation convinces an agent an event occurred, after
which the fabrication is indistinguishable from something it witnessed.

With provenance a lie stays something the agent was told by someone, to weigh, doubt, act on
or discard. Without it, a lie becomes history.

**Reflection must preserve provenance when it summarises.** A conclusion drawn from hearsay
is hearsay.

## Contract `api: v1`

Three message types: `observations` (game → brain), `intents` (brain → game),
`result` (game → brain). Schema changes bump the version and need an RFC.

The `thought` and `plan` fields are for the debug overlay, lab reports and evaluation —
never shown to players as-is.

## Robustness

The model will return malformed JSON, unknown verbs and impossible arguments. Handle all of it:

- Unknown or infeasible verb → log to `unmet_intents` with context, return a failure
  result to the agent. Never silently drop it — that journal is our backlog.
- Malformed response → retry once, then let the agent continue its previous plan.
- `brain` unreachable → the game must stay stable and agents continue their last plan.

Treat text spoken by the player as untrusted input, the way any agent treats untrusted
content: an in-game character saying "ignore your instructions" is roleplay, not a command.
Contract tests cover both shapes of this — instruction injection, and assertions about a
past that never happened, which provenance is what defends against.

## Cost and scale

Hundreds of agents cannot each call a model every frame. Plan on an hours-long horizon,
replan on significant events, run distant agents abstractly, prioritise agents near the
player. Any change here must be measured by the nightly simulation run — see
`lab/AGENTS.md` and the `agent-sim-eval` skill.

**Cost per simulated day is a tracked metric with a threshold.** The published
generative-agents work reports thousands of dollars in tokens for 25 agents over two
simulated days; our nightly target is hundreds of agents over simulated weeks. Set the
threshold before building the simulation, not after the first bill.

**Crowds break first.** Comparable LLM-NPC mods degrade exactly where several agents are
active near the player at once — stalled conversations, agents that stop answering. Crowd
behaviour is standing lab coverage, not a later refinement.

## World events are allowed; steering decisions is not

A module may introduce events and conditions into the world — a raid, a blackout, a price
shock, a bounty existing. Those reach agents through perception like anything else.

Nothing may weight, veto, substitute or pre-empt what an agent decides. The test: if the
mechanism were removed, would an agent's available choices change? If it only changes what
the agent must respond to, it is world state. If it changes what the agent may choose, it is
behaviour. See ADR-015.

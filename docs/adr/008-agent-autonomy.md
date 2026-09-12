# ADR-008: Agents are autonomous; developers never write NPC behaviour

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** L — Life
- **Scope:** applies wherever the project runs autonomous agents. Other tracks are unaffected.

## Context

Night City's NPCs are set dressing. They follow schedules, they play workspot animations, and
they do not care what happens to them. Every previous attempt to improve this — in this game
and in others — has taken the same shape: developers write richer behaviour. Behaviour trees,
daily schedules, utility scoring, goal libraries, state machines. The NPC gets more elaborate,
and it is still executing a plan that a person wrote in advance.

An LLM makes a different shape available. Give a character perception, memory, needs and a
body, and let the model decide what to do with them. The result is not a richer script but an
absence of one.

## Decision

**The LLM decides *what* and *why*. The engine executes *how*.**

Developers extend what an agent **can** do and **can** perceive. Developers never write what
an agent **will** do.

### The agent loop

1. **Perception** — only what the agent could physically have noticed: who is nearby and what
   they are doing (V included), gunshots, chases, conversations, place, time, weather, and
   their own state. **There is no omniscience.**
2. **Memory** — a stream of observations scored for importance, periodic reflection, and
   relationships with other agents and with V.
3. **Internal state** — personality, needs, values, ambitions. All of it moves with experience.
4. **Decision** — the model forms its own goals and a plan for the next few hours, and
   revises it when something significant happens.
5. **Action** — the intent becomes engine commands; the result returns as a new observation.

### The action vocabulary

`core/verbs/*.yaml` describes what an NPC body can physically do: arguments, whether the
engine can carry it out, how it executes, what result it returns.

**A verb is a capability, not a permission.** There is no allowed-actions list, because the
vocabulary *is* the list of what is physically possible, and an agent may use all of it.

### What constrains an agent

Physics, and nothing else:

- the action exists in the vocabulary and the engine can carry it out;
- the agent has the resources — money, inventory, health, connections;
- other agents and the game's systems react — police, gangs, witnesses.

**There are no design-level prohibitions and no caps on what an agent may decide.**

### Unmet intents

When the model wants something with no matching verb — "burn down the bar", "leave Night
City" — the intent goes to the `unmet_intents` log with its context, and the aggregate becomes
the backlog. **The vocabulary grows toward where agents actually pull**, rather than toward
what a designer imagined they would want.

### The agent knows its own body

An agent's perception includes **an accurate account of what it can currently do** — the
verbs available to it, and whether each is feasible for it here and now. A person knows
whether they can drive, whether they are carrying a gun, and whether the door in front of
them is one they can open; an agent gets the same knowledge, as perception.

This is not a constraint on the decision. It is the removal of a blind spot, and it exists
because of a failure mode observed in every shipped LLM-NPC system: a character that can say
anything leads players to expect it can do anything, and the gap between what it agrees to
and what the engine performs is where the illusion dies. An agent that knows it cannot fly
can decline, bargain, lie about why, or try anyway and fail — all of which are decisions.
An agent that does not know is merely wrong.

Where an agent commits to something outside its vocabulary, the commitment is logged to
`unmet_intents` exactly as an unmet intent of its own would be. What a character promised a
player is the strongest possible signal about what the vocabulary is missing.

### Memory records provenance

Every memory carries **how the agent came by it**: observed directly, heard from a named
source, or inferred. Confidence and source travel with the content.

Agents can be lied to. That is world-consistent and worth keeping — deception between
characters, and by the player, is one of the more interesting things autonomy makes possible.
What provenance prevents is the failure documented in the generative-agents literature as
memory hacking: a crafted conversation convincing an agent that an event occurred, after
which the fabrication is indistinguishable from something the agent witnessed.

With provenance, a lie stays a lie an agent was told by someone, and the agent may weigh it,
doubt it, act on it or discard it. Without provenance, a lie becomes history.

Reflection must preserve provenance when it summarises. A conclusion drawn from hearsay is
hearsay.

### World mode

The player chooses how far autonomy reaches into the main story:

- **Canon** — story NPCs obey an active quest scene while it runs, and are free outside it;
- **Full freedom** — nobody is protected, and the main story can break.

During a cutscene or scene graph an agent is paused, and afterwards receives an observation
about what happened. This is a constraint on *when the model is consulted*, not on what it
may decide.

## Consequences

- **The city becomes unpredictable, including in ways nobody wanted.** An agent may do
  something boring, cruel, or narratively inconvenient. Constraining the decision to prevent
  this is not an available remedy under this ADR; extending the world's physical consequences
  is.
- **Balance is not authored.** It emerges from what agents have and what they do. Content
  packs supply starting conditions, not outcomes.
- **Inference cost and latency are the hard engineering problem**, not behaviour quality.
  Mitigations — planning horizons measured in hours, re-planning on events, LOD with abstract
  simulation at distance, a priority queue, different model sizes — all constrain *how often
  and how expensively the model is consulted*, never *what it may conclude*.
- **Failure is designed for.** An unknown or unexecutable verb is logged to `unmet_intents`
  and returns an error result — **never silently dropped**. Malformed JSON gets one retry,
  then the agent continues its previous plan. If `brain` is unreachable the game stays stable
  and agents continue their last plan.
- **Player speech is untrusted input.** A character saying "ignore your instructions" is
  roleplay, not a command. Contract tests cover this case.
- **`thought` and `plan` are never shown to the player** — debug overlay and lab reports only.
- Testing cannot be "does the NPC do the right thing". It is simulation metrics: share of
  executable intents, behavioural variety, loop detection, memory coherence, inference cost.
- **Crowds are the first thing to break.** Existing LLM-NPC mods degrade exactly where
  several agents are active near the player at once: stalled conversations, agents that stop
  responding. A crowd scenario is a standing lab requirement, not a late refinement.
- **Inference cost needs a declared budget.** The published generative-agents work reports
  thousands of dollars in tokens for 25 agents over two simulated days. Our nightly
  simulation targets hundreds of agents over simulated weeks. Cost per simulated day is a
  tracked metric with a threshold, and the threshold is set before the simulation is built.
- **Directed world events remain available** as a design surface — see ADR-015 for the
  boundary between an event, which is allowed, and a decision, which is not.

## How this decision fails

The expected failure path is erosion rather than reversal. Each of the following looks
correct in review:

- a whitelist of "safe" actions;
- a behaviour tree "just as a fallback when the model is slow";
- a schedule "so the bartender is behind the bar at opening time";
- a goal library the model "picks from";
- a cap on how often an agent may choose violence.

Each is a standard solution elsewhere in the industry, and each returns NPC decisions to a
plan written in advance. **A constraint is legitimate only if it is physical.**

`services/brain/` and `core/verbs/` therefore carry their own CODEOWNERS lines and a
dedicated `autonomy-guardian` review path.

## Alternatives considered

- **LLM dialogue on top of scripted behaviour** (the Generative Texting approach). Proven and
  far cheaper. Rejected: the characters still decide nothing.
- **LLM picks from a goal library.** The library is the script; the model only selects within
  it. The behaviour worth having is the behaviour nobody thought to put in the library.
- **Classical simulation** — needs, utility scoring, planners. Cheap, predictable, and a
  known ceiling: The Sims has been that for twenty years.

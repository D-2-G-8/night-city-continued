# ADR-021: Navigation in custom interiors

- **Status:** **Proposed — research required. No decision is made here, and nothing may be
  built on the assumption of one.**
- **Date:** 2026-09-12
- **Deciders:** —
- **Track:** W — World (affects L — Life)

## Context

A custom interior behind a door we cut into a facade is new geometry. The game's navigation
data is baked into shipped sectors by the studio, so our interior has none.

**What an NPC does in a space with no navmesh is documented by the community:** it walks in a
straight line toward its target, through whatever is in the way. It does not route around a
table, does not turn in a doorway, and passes through walls or wedges itself against them.
The author of Night City Allies describes exactly this, and it is why that mod excludes some
interaction points.

### What the engine has

Checked against the modding wiki, 2026-09-12:

- A **`.navmesh`** resource format exists, described there as "AI navigation meshes".
- A **`.streamingsector` can carry "navigation"**, alongside sound, collision and illumination.

So the capability is in the engine and sectors are the place it lives.

### What is not documented

The wiki states plainly that it has no navmesh section at all. Specifically undocumented:

- how to generate navigation data for a custom interior;
- how to import existing navigation data into a `.streamingsector`;
- which node types handle navigation — none appear in the node type reference;
- the internal structure of the `.navmesh` format;
- **whether a sector embeds its navigation data or references it by resource path**, and
  whether one sector can reference another's.

**Undocumented is not the same as impossible.** A large share of this ecosystem's knowledge
lives in the RED Modding Discord and in a small number of people, not on the wiki. The wiki's
silence means nobody wrote a guide.

### Why this blocks other decisions

- **The pilot location.** A single room where residents occupy workspots needs dense
  low-rise frontage with many small doors. A multi-room interior where a resident walks from
  one room to another needs somewhere a flat or an office plausibly fits, with matching
  interior assets nearby. Those are different parts of the city, so the pilot cannot be
  chosen before this is answered.
- **What the W track can promise.** W1 and W2 are shaped by whether interiors can be walked
  through or only occupied.
- **What the L track can show.** An agent that cannot walk is presence and conversation, not
  life. If navigation stays unavailable, the first demo is the pipeline — pull request, lab
  report, player update — not residents.

## Open questions, in the order they should be answered

1. **Does a sector reference navigation by resource path, or embed it?** Answerable by
   opening a shipped interior sector in WolvenKit and reading the structure. This is reading,
   not research, and it gates everything else: a path reference opens the possibility of
   supplying or reusing navigation data; an embedded blob means the format has to be
   understood first.
2. **Can WolvenKit parse `.navmesh`?** A parser means someone has already reverse-engineered
   the format and there is something to build on. An opaque blob means nobody has.
3. **Can a new interior reuse navigation that already works** — keeping a donor's walkable
   layout and replacing everything else? This trades design freedom for working NPCs and may
   be available immediately, independently of questions 1 and 2.
4. **Ask the RED Modding Discord.** Not a last resort but a parallel first step, and the
   question should be narrow: how does a sector reference its navigation, and has anyone
   supplied their own?

## Interim constraint, while this is open

This much is decidable now and holds until the questions above are answered:

**Any custom interior is designed to work without navigation.** One room, residents in
workspots, teleport where movement is unavoidable and unobserved. Content packs must not
assume an agent can path inside a custom interior, and no pack, module or scenario may ship
depending on it.

This is a constraint born of an unknown, not a design position. It is lifted the moment the
answer allows.

## Terminology, because the names collide

In this community **"custompathing" means giving assets your own file paths** — copying a mesh
to a path of ours so that editing it does not change every building in the city that uses the
original. It has nothing to do with navigation.

Searching for "pathing" finds that, not this. Write "navigation" or "navmesh" when that is
what is meant, and never shorten it to "pathing".

## What would change this ADR

Any of:

- a documented or community-confirmed way to generate or import navigation data — this ADR is
  then replaced by one that decides how we use it;
- confirmation that it is not achievable with current tooling — this ADR is then replaced by
  one that accepts workspots and teleport as the permanent shape of custom interiors, and the
  W and L tracks are planned around that;
- a working answer to question 3, which would unblock walkable interiors without answering
  questions 1 and 2 at all.

Until one of those, this stays `Proposed` and the interim constraint stands.

# Night City Continued — technical design document

> **Working title.** Status: preparing for launch. Document version: 0.4 (11.09.2026). Owner: Daria.
> **Environment:** Windows 11 only — the game, development, builds, the lab and the services. The LLM inference host is a config value: the same PC, another machine on the LAN, or a cloud API.
> **Markers in the text:** `[pin]` — a version to be filled in when dependencies are frozen in `deps.lock.md`; `[verify]` / `[spike]` — a claim or an approach that must be checked before it is built on.
>
> **Decisions:** `docs/adr/`. ADRs 009–015 came out of a review of how comparable projects solved the same problems — curated mod distributions, loaders that survive game patches, automated in-game testing, and published work on LLM-driven agents — and they extend several sections below.

---

## 1. Overview

**In short.** An open-source platform that keeps Cyberpunk 2077 evolving, and a shared home for modders. It brings existing mods and new development into one ecosystem and hands authors tooling they would otherwise have to build:

- a versioned delivery pipeline;
- a lab that boots the real game on every merge request and reports what actually changed;
- a launcher that delivers updates to players the way a game patch would.

**Why.** Official PC support stopped at patch 2.31 (September 2025) and no further updates have been announced. Modding, meanwhile, is fragmented: every author has their own process, their own manual testing and their own delivery. This project:

- gathers the community around shared infrastructure and a shared roadmap;
- keeps the game evolving through regular, compatible releases that need no reinstall and cost no saves;
- gives authors a larger audience and more support **without taking away their income channels**.

**Who it is for.**

- **Modders** — port or link their mods and get a free lab, a release pipeline and distribution through the launcher.
- **Content authors** — build districts, locations, residents and stories against the SDK without touching core code.
- **Module developers** — add new systems through the public core API.
- **Players** on PC (Windows) — install and update everything through the launcher or a Vortex collection, and take part in polls and roadmap decisions.
- **Fan communities** — the source of ideas and priorities.

---

## 2. Features

### 2.1. Development tracks

Scope is not capped. Anything the community wants from the game lands in one of these tracks. Something that looks impossible today becomes a research item, not a refusal.

| Track | What it covers |
|---|---|
| **P — Platform** | Core, module API, save migrations, release pipeline, launcher |
| **E — Ecosystem** | Recipes for existing mods, inclusion tiers, license audit, working with authors, mod porting |
| **T — Tooling** | The MR lab, SDK, pack validator, agent-driven interior generation, templates |
| **W — World** | Doors, interiors, new locations across every district: Watson, Westbrook, City Center, Heywood, Santo Domingo, Pacifica, Dogtown, Badlands |
| **L — Life** | Autonomous NPCs: personality, needs, memory and their own goals; decisions come from an LLM, not from a developer's script; a city that lives out of the player's sight |
| **N — Narrative** | Lines, voices, holocalls, supporting characters, side jobs |
| **S — Systems** | New mechanics on top of the game (housing, income, reputation, and whatever the community picks) |
| **I — Input and platforms** | VR (Vision Pro over ALVR, PS VR2 Sense), Logitech wheel, PS VR Aim Controller |
| **M — Multiplayer** | A shared city, synchronised residents and VR poses, co-op activities |
| **C — Community** | Fan polls, a public roadmap, a contributors page, funding |

### 2.2. Platform and ecosystem features

Order is set by the launch plan (section 9).

| ID | Feature | What it does | Plan step |
|---|---|---|---|
| P1 | Monorepo | Structure, licenses, CODEOWNERS, issue/RFC/PR templates | 1 |
| P2 | PR and release pipeline | Build, validation, license audit, signed release manifest | 1 |
| P3 | Console launcher `ncc` | Game build check, install, update, rollback, log bundling | 1 |
| T1 | MR lab (MVP) | One scenario: clean snapshot → install → save → point → screenshot, log, FPS → PR comment | 1 |
| C1 | Platform documentation | Environment setup, PRs, lab reports, releases, launcher | 2 |
| E1 | First included mod | An openly licensed mod taken through the full cycle | 3 |
| C2 | Donations and policy | Infrastructure funding, contributors page, distribution policy | 4 |
| C3 | Polls and roadmap | Fan polls, public results, a roadmap with an owner per feature | 5 |
| E2 | Mod recipes (3 tiers) | Included / linked / compat, with author income preserved | 6–8 |
| E3 | License audit in CI | ScanCode, license allowlist, permission registry | 1 (basic), 6–8 |
| E4 | Mod porting guide | Choosing a tier, the recipe, lab scenarios, upstream patches | 7 |
| T2 | Scenarios from the diff | The lab picks what to check from what the MR changed | After MVP |
| P4 | Save migrations | `dataVersion`, stepwise migrations, golden saves | Before the first content module |
| P5 | Launcher GUI | An interface on top of `ncc`: channels, "what's new" | After MVP |

### 2.3. Content roadmap candidates

Final priorities and owners come out of the polls (step 5). The list goes to the community at step 9.

| ID | Feature | Summary | Balance impact |
|---|---|---|---|
| W1 | Openable doors | A door on a facade leads into a pocket interior and back | Whether V gets in — including with a wanted level — is the residents' own call |
| W2 | Interiors | Built from native game assets via World Builder | Loot and shops only through S modules |
| W3 | New districts and locations | Shipped as packs, no core changes | — |
| L1 | Autonomous agents | NPCs decide what to do with themselves: each has a personality, needs, memory, relationships and goals of their own. Developers write no schedules, no behaviour scripts and no goals | Balance is not set in advance: it emerges from agents' decisions and is bounded only by what they actually have — money, weapons, connections |
| L2 | Action vocabulary | Everything an NPC body can physically do in the engine; the agent picks any of it, modules keep extending the vocabulary | — |
| L3 | Social life | Agents talk to each other, spread rumours, make friends and enemies, form groups. V is just another participant in the world; agents form their own opinion of them | — |
| L4 | A living city out of sight | Agents keep living away from the player in an abstract simulation and materialise near them | — |
| L5 | Unmet intents → backlog | Intents with no matching verb are logged and become vocabulary work | — |
| N1 | Side jobs | Questphase/scene inside story packs; agents can hand V errands of their own | Rewards come from the pack's resources or from the agent commissioning the job |
| N2 | New voices | TTS and live voice acting; original or licensed voices only | — |
| N3 | Supporting characters | Custom NPCs with a personality profile | — |
| N4 | Lip sync for dynamic lines | [research] a native runtime facial-animation plugin | — |
| S1 | System mechanics | By community RFC | Balance review mandatory |
| I1 | VR port compatibility | Checked on every release | — |
| I2 | Wheel mod compatibility | Checked on every release | — |
| I3 | PS VR Aim Controller on PC | [research] reverse engineering, a SteamVR driver, calibration against other tracking systems | — |
| M1 | Multiplayer sandbox | On top of CyberpunkMP: a shared city, synchronised residents and VR poses | Separate balance for PvP |
| M2 | Co-op story activities | [research] co-op in our own jobs first, story jobs later | — |
| T3 | Agent-driven interior generation | Layout → World Builder JSON → screenshot QA | — |

### 2.4. Autonomous agents: how this works

**The principle.** Developers do not write NPC behaviour, schedules or goals. The project gives an agent a body (the engine's action vocabulary), perception and memory; the model makes the decisions. The developers' job is to extend what an agent *can* do, never to define what it *will* do.

**The agent loop.**

1. **Perception.** Only what the agent could physically have noticed: who is nearby and what they are doing (V included), gunshots, chases, conversations, place, time, weather, and their own state (health, money, inventory). There is no omniscience. Perception also includes an accurate account of **what this body can currently do** — the verbs available and whether each is feasible here and now — the way a person knows whether they can drive or whether the door in front of them is one they can open. That is the removal of a blind spot rather than a limit on the decision: an agent that knows it cannot fly can refuse, bargain, lie about why, or try anyway and fail, while an agent that does not know is simply wrong. A commitment made outside the vocabulary is logged to `unmet_intents` like any unmet intent.
2. **Memory.** A stream of observations scored for importance, periodic reflection (conclusions about themselves, about people, about the district), and relationships with other agents and with V. Every memory carries **how the agent came by it** — observed, heard from a named source, or inferred — and reflection preserves that when it summarises. Agents can be lied to, which is worth keeping; provenance is what stops a lie from becoming history.
3. **Internal state.** Personality, needs (food, sleep, money, safety, company), values and ambitions. All of it shifts with experience.
4. **Decision.** The model forms its own goals and plan — "what am I doing for the next few hours, and why" — and revises it when something significant happens.
5. **Action.** An intent is translated into engine commands. The result — whether it worked and why — comes back to the agent as a new observation.

**Division of responsibility.** The LLM decides *what* and *why*. The engine executes *how*: pathfinding, animation, physics, combat. The execution layer makes no decisions.

**Action vocabulary (L2)** — the starting categories. Every action is described in `core/verbs/*.yaml`: arguments, whether the engine can carry it out, how it is executed, and what result it returns.

| Category | Examples |
|---|---|
| Movement | `go_to`, `drive_to`, `use_transit`, `follow`, `flee`, `hide`, `enter` / `leave` a space |
| Communication | `talk_to` (an agent or V), `call`, `send_message`, `shout` |
| Social actions | `give`, `trade`, `lend`, `bribe`, `threaten`, `steal` |
| Conflict | `draw_weapon`, `attack`, `defend`, `surrender`, `call_police`, `call_allies` |
| Daily life and work | `use_workspot` (sit, eat, drink, work), `buy`, `sell`, `work_at`, `sleep` |
| World | `open` / `lock` a door, `use_object`, `wait`, `observe` |

**What constrains an agent is physics, and nothing else.**

- The action has to exist in the vocabulary and be executable in the engine: you cannot walk through a wall, hand over money that is not yours, or shoot without a gun.
- The agent's own resources: money, inventory, health, connections.
- Consequences created by other agents and by the game's systems: police, gangs, witnesses.

There are no design-level prohibitions and no caps on what an agent may decide.

**Unmet intents (L5).** When the model wants something the vocabulary has no verb for ("burn down the bar", "leave Night City"), the intent is written to the `unmet_intents` log with its context. The aggregate is published and feeds the backlog: the vocabulary grows in the direction agents are actually pulling.

**World events are allowed; steering decisions is not** (ADR-015). A module may create, schedule or weight events and conditions in the world — a gang moving on a district, a police sweep, a blackout, prices, a bounty existing. Those reach agents through perception like anything else. Nothing may weight, veto, substitute or pre-empt what an agent decides. The test: if the mechanism were removed, would an agent's available choices change? If it only changes what the agent must respond to, it is world state; if it changes what the agent may choose, it is behaviour. Events are declared at the level of a place, a faction or a population, never a named agent — an event aimed at one agent and timed to force one outcome is behaviour writing with extra steps.

**Story and keeping the game intact.**

- The player settings carry a world mode, **defaulting to Canon** (ADR-017):
  - **Canon** — story NPCs obey an active quest scene while it runs, and are free outside it;
  - **Full freedom** — nobody is protected, and the main story can break.
- During a cutscene or a scene graph the agent is paused, and afterwards receives an observation about what happened.
- Every world change goes through the core fact store and is saved in a migration-compatible form.

**Scale without losing autonomy.**

- **Planning horizons.** The model plans hours ahead, the way a person does, and revises on significant events. It is not called every frame.
- **LOD.** Agents near the player decide often and use the whole vocabulary. Far away they live in an abstract simulation with coarse steps ("spent the evening at the bar, fell out with X") and materialise when the player comes near.
- **Priority inference queue.** Agents near the player and participants in live events go first; background agents are batched.
- **Models of different sizes:** a large one for reflection and plans, a fast one for in-the-moment reactions [to be selected].

**The `brain api: v1` contract.**

Game → `brain`, observations:

```json
{
  "api": "v1",
  "type": "observations",
  "agent_id": "watson_bartender_017",
  "game_time": "2077-11-03T23:41",
  "self": { "location": "pilot_bar", "health": 1.0, "eddies": 340, "inventory": ["shotgun"] },
  "events": [
    { "kind": "saw", "subject": "V", "detail": "walked into the bar with wanted level 2" },
    { "kind": "heard", "subject": "watson_regular_004", "detail": "says there is a bounty on V" }
  ]
}
```

`brain` → game, intents (`thought` and `plan` are for the debug overlay and lab reports; the player never sees them):

```json
{
  "api": "v1",
  "type": "intents",
  "agent_id": "watson_bartender_017",
  "thought": "That bounty on V would clear my debt to the Tyger Claws. But V bailed me out once.",
  "plan": "Don't call it in yet. Ask V what is going on and decide from the answer.",
  "intents": [
    { "verb": "talk_to", "target": "V", "text": "Heard there's a price on you. Sit down, talk." },
    { "verb": "use_workspot", "target": "bar_counter_02" }
  ]
}
```

Game → `brain`, result:

```json
{ "api": "v1", "type": "result", "agent_id": "watson_bartender_017", "verb": "talk_to", "status": "done", "detail": "V answered: \"I'll handle it. You never saw me.\"" }
```

### 2.5. Dependencies between features

- Content tracks (W, L, N, S) need P1–P3 and T1: without the pipeline and the lab, content is not accepted.
- The first module that writes into saves needs P4.
- E2–E4 need a working cycle on E1: the first mod proves porting is possible.
- L1 needs L2 (without a vocabulary an agent has nothing to act with) and the fact store; L3 and L4 need L1.
- Agents speaking out loud depends on N2 and N4; until then conversations are subtitled.
- M1 requires the L and N state to move into a core that does not depend on the client.
- I3 and M2 are research with their own spikes; content releases do not depend on them.

### 2.6. Settings and configuration

| Where | What |
|---|---|
| In game (Mod Settings) | `brain` address, world mode (**Canon by default**, Full freedom as an informed opt-in — ADR-017), agent density, module toggles, the debug overlay of agent thoughts and plans |
| `%LOCALAPPDATA%\NCC\launcher.json` | Game path, channel (stable/beta), install mode, update auto-check |
| `recipes/<id>/recipe.yaml` | An external mod's recipe: tier, source, license, patches, lab scenarios |
| `content/<pack>/pack.json` | Pack manifest: dependencies, facts, sectors, lab points, license |
| `content/<pack>/agents/*.yaml` | Starting biographies: who this person is and where they came from. What they do next is their own decision |
| `core/verbs/*.yaml` + module vocabularies | The action vocabulary: arguments, executability, execution, result |
| `lab/scenarios/*.json` | Lab scenarios |
| `services/brain/appsettings.json` | LLM endpoint, models for planning and for reactions, inference budget, memory database path |
| `governance/*.md` | Policy: donations, sponsorship, author permissions, code of conduct |

---

## 3. Technology stack

### 3.1. Architecture

```
             GitHub (public monorepo)
 PR ──► cloud CI: build · validation · license audit · artifacts
   │
   └─► lab:run label (maintainer) ──► self-hosted runner on the lab host
                                         │ downloads artifacts, never sources
                                         ▼
                              VM from a clean snapshot (no outbound network, no secrets)
                              game 2.31 (GOG) + ncc install + harness mod
                              scenarios → screenshots · FPS · logs
                                         │
                              host: compare against baseline → PR comment
 Tag release-* ──► signed manifest ──► GitHub Releases (+ Nexus, manually)
                                                  │
                                         ncc launcher on the player's PC
┌──────────────── Game 2.31 + frameworks ────────────────┐   ┌──────────────┐
│ core     — module API, facts, migrations, loader       │◄─►│ brain (.NET) │──► LLM
│ modules  — residents, narrative, phone, systems/*      │   └──────────────┘
│ content  — district-*, story-* (data)                  │
│ recipes  — included and linked community mods          │
└────────────────────────────────────────────────────────┘
```

**Layer rules.**

- A content pack is data and declarations only, no code.
- Modules talk to the core only through the public API.
- An external mod is attached by a recipe and does not have to know the core exists.
- The lab never executes MR code on the host, only inside a disposable VM.

### 3.2. Tools and versions

| Tool | Purpose | Version |
|---|---|---|
| Cyberpunk 2077 (PC, Windows; GOG for the lab) | Target game version | **2.31**, build 5294808 |
| WolvenKit / WolvenKit.CLI | Projects, import/export, packing | **9.0.1**, .NET 10 |
| RED4ext | Native plugins | **1.30.0** |
| Codeware | Entities, scriptable services, UI | **1.20.3** |
| redscript | Core, module and harness logic | [pin] |
| Cyber Engine Tweaks | Debugging, lab harness | [pin] |
| ArchiveXL / TweakXL | Sectors, node removal / TweakDB | [pin] |
| Mod Settings | In-game settings | [pin] |
| RedHttpClient | HTTP from the game to `brain` | [pin] |
| UnlimitedGeometryCacheStreaming | Collision in our own sectors | [pin] |
| World Builder, RedHotTools, removalEditor, VolumetricSelection2077 | World editing | [pin] |
| AppearanceMenuMod | NPC debugging | Development only |
| Blender + Cyberpunk IO Suite | Meshes, colliders | [pin] |
| .NET 10 | Launcher, `brain`, validator, lab utilities | [pin] |
| ScanCode Toolkit | License audit | [pin] |
| minisign | Manifest signing | [pin] |
| Hyper-V (Windows 11 Pro) | Lab VM with GPU partitioning | [spike: game stability under GPU-P] |
| PresentMon | FPS and frame-time capture in the lab | [pin] |
| ffmpeg | Screenshots and run video | [pin] |
| llama.cpp (CUDA) | Local inference | [pin] |
| Qwen family models | NPC dialogue | On the same PC as the game — a small model, roughly 4–9B; on a separate machine — Qwen3.8 27B. Quantisation [to be matched to VRAM] |
| GPT-6 Astra (API) | T3 tooling, never used at runtime | — |

**Pinning versions.** `deps.lock.md` holds the version and a link to the exact file for every dependency. It is also the source of the `requires` block in the release manifest. Updating one is a separate PR with a full lab regression.

**Documentation:**

- Modding wiki: https://wiki.redmodding.org/cyberpunk-2077-modding
- World Editing: https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/world-editing
- WolvenKit: https://github.com/WolvenKit/WolvenKit
- World Builder: https://github.com/justarandomguyintheinternet/CP77_entSpawner
- Blender IO Suite: https://github.com/WolvenKit/Cyberpunk-Blender-add-on
- Codeware: https://www.nexusmods.com/cyberpunk2077/mods/7780
- ArchiveXL: https://www.nexusmods.com/cyberpunk2077/mods/4198
- CyberpunkMP: https://github.com/tiltedphoques/CyberpunkMP
- Integrations: https://github.com/dariulone/cyberpunk-vr-port, https://www.nexusmods.com/cyberpunk2077/mods/29172

### 3.3. Engine components

- **World data:** `.streamingsector`, `.streamingblock`, `.archive.xl`, `.mesh`, PhysX colliders.
- **Scripts:** redscript — core, modules, migrations. CET Lua — debugging and the lab harness; it never ships in release modules.
- **TweakDB:** TweakXL `.yaml`.
- **Quests and scenes:** `.questphase` / `.scene` with a JSON representation for diffing.
- **UI:** Codeware/ink — phone, "what's new", overlays.
- **Audio:** muffling zones, holocalls; Audioware — [spike: loading files at runtime].
- **External processes:** the `ncc` launcher, `brain`, lab utilities — .NET 10.

### 3.4. Architecture decisions

- **ADR-001: .NET 10 for the launcher, `brain`, the validator and the lab utilities.** Shared code for manifests, signatures and logs. `brain` later moves into a CyberpunkMP server plugin, which has a .NET SDK.
- **ADR-002: GitHub Releases is the source of truth for distribution; Nexus is a mirror and a storefront.** Nexus API terms for direct downloads [verify]: from what is known, they are restricted for free accounts.
- **ADR-003: monorepo, SemVer per module, a release pinned by a manifest.**
- **ADR-004: content is schema-backed data.** Packs are validated automatically.
- **ADR-005: distribution model for third-party mods.** The project stores recipes (source, hash, license, patches), not copies. Source lands in the repository only when the license allows it or the author has given written permission.
- **ADR-006: the lab runs on a self-hosted runner with a disposable VM.** MR code is built in cloud CI, the runner downloads only artifacts, and they execute only inside a VM with no network and no secrets. Runs are triggered by a maintainer's label. GitHub does not recommend self-hosted runners on public repositories without exactly this kind of isolation.
- **ADR-007: the GOG build of the game in the lab.** No DRM, easier to hold at a specific build and to restore from an image. A personally purchased copy on our own hardware; the image is never handed to anyone.
- **ADR-008: agent autonomy.** NPC decisions come from an LLM working on perception, memory and internal state; the engine only executes. Developers extend the action vocabulary and perception, and never write behaviour, schedules or goals.

### 3.5. Licenses

| Name | How it is used | License |
|---|---|---|
| WolvenKit | A tool; never shipped in a release | GPL-3.0 |
| Qwen3.8 27B | Weights downloaded by the user | Apache-2.0 |
| llama.cpp, minisign, ScanCode, PresentMon, ffmpeg | Development and lab tooling | [verify] |
| RED4ext, Codeware, ArchiveXL, TweakXL, CET, redscript, RedHttpClient, Mod Settings | Runtime dependencies; the launcher installs them from official sources | [verify each] |
| CyberpunkMP | Multiplayer reference | Custom license — [read before forking] |
| Community mods | Through recipes; the tier depends on the license | See section 10 |

**Project licenses:**

- platform code, SDK and schemas — MIT;
- content packs and included mods — the author's license, recorded in the manifest; relicensing is forbidden;
- derivatives of game assets — within CD Projekt Red's Fan Content Guidelines;
- documentation — CC BY 4.0, with code samples inside it under MIT (ADR-020).

---

## 4. Development pipeline

### 4.1. Stages and transition criteria

| Transition | Criterion |
|---|---|
| Idea → RFC | An issue on the template: problem, track, affected modules and mods, save impact |
| RFC → Prototype | RFC accepted; a feature owner assigned; it is clear whether a new core API is needed |
| Prototype → Alpha | Works on 2.31; can be disabled; lab scenarios declared; migrations exist if data changes |
| Alpha → Beta | Lab green on the full regression; golden saves load |
| Beta → Stable | Two weeks in beta with no blockers; patch notes written for players; licenses verified |

### 4.2. Git branching

| Branch | Purpose |
|---|---|
| `main` | Shipped releases, tagged `release-X.Y.Z` |
| `dev` | Integration for the next release |
| `feature/<track>-<id>-<slug>` | Tasks; PRs target `dev` |
| `recipe/<mod-id>` | Adding or updating a mod recipe |
| `release/X.Y` | Feature freeze, beta |
| `hotfix/X.Y.Z` | Branched from a release tag, merged into `main` and `dev` |
| `port/cp<patch>` | Moving to a new game patch |
| `research/<slug>` | Spikes; merged into `dev` only after an ADR |

**PR rules:**

- cloud CI green;
- lab report with no blocking findings;
- review by the module or recipe owner (CODEOWNERS);
- squash merge; Conventional Commits with a scope (`feat(residents): …`, `recipe(example-mod): …`);
- changes to the core API, to any schema or to policy only under an accepted RFC.

### 4.3. Versioning

| Thing | Scheme | Example |
|---|---|---|
| Player-facing release | `X.Y.Z` plus a codename | `0.1.0 "Foundation"` |
| Module | SemVer | `residents 1.2.0` |
| External mod in a recipe | Upstream version plus recipe revision | `example-mod 1.4.2-r2` |
| Core API | `core-api/N` | `core-api/1` |
| Pack and recipe schemas | `ncc-pack/N`, `ncc-recipe/N` | `ncc-recipe/1` |
| `brain` contract | `api: vN` | `v1` |
| Save data | Named migrations per component, plus `dataVersion` as the release-level marker | `residents:0007-split-relationships` |
| Game patch | `+cp` metadata | `0.4.1+cp2.31` |

**Stability promise:** a pack or recipe built against schema `/1` works on every release that still supports `/1`. Support is removed no sooner than one major release after it is marked deprecated.

### 4.4. Repository layout

```
night-city-continued/
├─ core/                  # API, facts, migrations, pack and recipe loader, verbs/
├─ modules/               # residents/, narrative/, phone/, systems/<name>/
├─ content/               # districts/<name>/, stories/<name>/
├─ recipes/<mod-id>/      # recipe.yaml, patches/, LICENSE (source/ for the included tier)
├─ services/brain/        # .NET 10
├─ launcher/              # .NET 10: ncc (CLI), GUI later
├─ lab/
│  ├─ harness/            # test mod: scenarios, teleport, readiness signals
│  ├─ runner/             # host scripts: snapshots, VM start, result collection
│  ├─ guest/              # in-VM scripts: install, game launch, capture
│  ├─ scenarios/          # base scenarios (smoke, golden-saves)
│  └─ compare/            # screenshot and metric comparison, report generation
├─ sdk/                   # schemas, Validator CLI, pack and recipe templates
├─ tools/                 # build.ps1, deploy.ps1, release.ps1, agents/
├─ releases/              # manifests and signatures
├─ tests/golden-saves/    # golden saves (Git LFS)
├─ governance/            # donations.md, sponsorship.md, permissions/, CODE_OF_CONDUCT.md
├─ docs/                  # rfc/, adr/, runbooks/, guides/, patch-notes/
├─ deps.lock.md
└─ CODEOWNERS
```

### 4.5. Manifests

**External mod recipe** — `recipes/example-mod/recipe.yaml`:

```yaml
schema: ncc-recipe/1
id: example-mod
name: Example Mod
tier: included          # included | linked | compat
upstream:
  type: github          # github | nexus | other
  url: https://github.com/<author>/<repo>
  ref: v1.4.2
  sha256: "<archive hash or commit>"
license:
  spdx: MIT
  file: LICENSE
  audit: scancode        # result produced in CI
  permission: null       # or governance/permissions/example-mod.md
permissions:             # transcribed from the author's own page — ADR-010
  redistribute: allowed  # allowed | denied | unknown; unknown counts as denied
  modify: allowed        # patches/ require this
  convert: unknown
  assets: denied
  source: "https://www.nexusmods.com/cyberpunk2077/mods/<id>?tab=permissions"
  checkedOn: 2026-09-12
  checkedBy: "<maintainer>"
authors:
  - name: "<author>"
    links:
      nexus: "https://www.nexusmods.com/cyberpunk2077/mods/<id>"
      donate: "<author's link>"
revision: 2
patches:
  - patches/0001-fix-load-order.patch   # proposed upstream: <PR link>
gamePatch: ["2.31"]
requires: { core: ">=0.1.0" }
lab:
  scenarios: [smoke, "point:watson_example_01"]
```

**Module** — `modules/<id>/module.json`:

```json
{
  "id": "residents",
  "version": "1.2.0",
  "coreApi": "1",
  "requires": { "core": ">=0.3.0 <1.0.0" },
  "provides": { "actions": ["start_scene"], "events": ["resident.killed"] },
  "factsNamespace": "ncc_residents_",
  "dataVersion": { "introduced": 5, "current": 7 },
  "lab": { "scenarios": ["smoke", "residents-daycycle"] }
}
```

**Content pack** — `content/districts/<name>/pack.json`:

```json
{
  "schema": "ncc-pack/1",
  "id": "district-pilot",
  "version": "0.1.0",
  "requires": { "core": ">=0.1.0 <1.0.0" },
  "gamePatch": ["2.31"],
  "factsNamespace": "ncc_pack_pilot_",
  "sectors": ["world/pilot_interior_01.streamingsector"],
  "claimsVanillaNodes": ["<sector>#<nodeIndex>"],
  "lab": {
    "points": [
      { "id": "pilot_entrance", "pos": [0.0, 0.0, 0.0], "yaw": 0, "time": "22:00" },
      { "id": "pilot_interior", "pos": [0.0, 0.0, 0.0], "yaw": 90 }
    ]
  },
  "license": "MIT",
  "authors": ["<author>"]
}
```

**Release** — `releases/X.Y.Z.json`, signed with minisign:

```json
{
  "release": "0.1.0",
  "codename": "Foundation",
  "channel": "stable",
  "dataVersion": 1,
  "compat": [{ "gamePatch": "2.31", "gameBuild": "5294808", "status": "supported" }],
  "requires": { "RED4ext": ">=1.30.0", "Codeware": ">=1.20.3" },
  "modules": { "core": "0.1.0" },
  "recipes": {
    "example-mod": { "version": "1.4.2-r2", "tier": "linked", "required": false }
  },
  "files": [{ "path": "core-0.1.0.zip", "sha256": "…", "required": true }],
  "patchNotes": "docs/patch-notes/0.1.0.md"
}
```

`required: false` marks a component the launcher may skip when it cannot be fetched or its
hash no longer matches — always the case for `linked` recipes, whose files belong to their
authors and can change or disappear at any time. The install then completes as **degraded**,
naming what is missing. `core`, modules and `included` recipes are always `required: true`.

**Pins addendum** — `releases/X.Y.Z.pins.json`, signed with the same key:

```json
{
  "release": "0.1.0",
  "revision": 3,
  "pins": {
    "example-mod": { "ref": "v1.4.3", "sha256": "…" }
  }
}
```

It carries refs and hashes and nothing else, so a third-party author publishing a new version
of their own mod does not force a new release. The launcher accepts it when the signature
verifies, the release matches, and `revision` is higher than the one already applied; the
release manifest stays immutable and its signature stays valid. See ADR-009.

### 4.6. Building and local work (Windows, PowerShell)

```powershell
# build a module, pack, recipe, or everything
pwsh ./tools/build.ps1 -Target core -Configuration Release
pwsh ./tools/build.ps1 -Target recipe:example-mod
pwsh ./tools/build.ps1 -All -Configuration Release

# deploy into your own game for a manual check
pwsh ./tools/deploy.ps1 -GamePath "D:\Games\Cyberpunk 2077" -Targets core,recipe:example-mod

# tests and validation
dotnet test launcher
dotnet test services/brain
dotnet run --project sdk/Validator -- validate recipes/example-mod
dotnet run --project sdk/Validator -- validate content/districts/pilot

# license audit locally (CI runs the same thing)
scancode --license --copyright --json-pp .\out\scancode.json .\recipes\example-mod

# build a release: manifest, SHA-256, signature
pwsh ./tools/release.ps1 -Release 0.1.0 -Channel beta
```

- World projects are packed through WolvenKit.CLI; check the syntax against `--help` in 9.0.1.
- REDmod is not used for our own packages; mod recipes in REDmod format are supported as they are.

**Inference (for LLM-backed modules):**

```powershell
D:\tools\llama.cpp\llama-server.exe -m D:\models\qwen-small-q4_k_m.gguf --host 127.0.0.1 --port 8080 -c 8192 -ngl 99
```

### 4.7. Artifacts

- `<id>-<version>.zip` for modules, packs and `included`-tier recipes (game-root layout, with the author's `LICENSE` inside).
- For `linked` recipes — the recipe only; the player downloads the files from the author.
- `ncc-<version>-win-x64.zip` (launcher), `brain-<version>-win-x64.zip`, `ncc-sdk-<version>.zip`.
- The release manifest `.json` and its `.minisig` signature.
- `THIRD_PARTY.md` — generated from the recipes and the license audit.
- Patch notes `docs/patch-notes/X.Y.Z.md`.

---

## 5. Delivery pipeline

### 5.1. Installation from the player's side

**Path A — the launcher (primary).** The MVP is the console `ncc`; a GUI comes later.

```powershell
ncc doctor                          # check the game build, dependencies, conflicts
ncc install --release 0.1.0         # install a release
ncc update --channel stable         # update
ncc rollback                        # roll back to the previous install
ncc uninstall                       # remove, driven by the manifest
ncc logs --bundle                   # log archive for an issue
```

What the launcher does on install:

1. Checks `bin\x64\Cyberpunk2077.exe` against the `compat` entries (file version plus SHA-256).
2. Installs missing dependencies from official sources.
3. Verifies the manifest signature and the hashes, then snapshots the current install.
4. Lays down modules and `included`-tier mods.
5. For `linked`-tier mods it opens the author's page, waits for the file to appear in the downloads folder, verifies the hash and installs it. **The download counts for the author.**
6. If a `required: false` component cannot be fetched or its hash does not match, it installs everything else and completes as **degraded**, naming what is missing. `ncc doctor` reports degraded components and what they disable. Hash checking is never relaxed — a component whose hash does not match is not installed at all (ADR-009).

**Path B — Vortex.** A collection on Nexus; every release is a new collection revision.

**Path C — manual**, from the file list in the patch notes.

> Modes do not mix. If the launcher detects a Vortex or MO2 install, it drops into check-only mode.

### 5.2. Platforms

- **GitHub Releases** — the source of truth for the launcher, the SDK and manifests.
- **Nexus Mods** — a mirror for the project's modules, the Vortex collection, a storefront. Authors' mods stay on their own pages.
- Compatibility: Vortex, MO2 (check-only mode), manual installation.

### 5.3. Channels and cadence

| Channel | Who gets it | Source |
|---|---|---|
| nightly | Developers | CI artifacts from `dev`, kept 14 days |
| beta | Anyone who wants it | GitHub pre-release |
| stable | Everyone | GitHub Release + Nexus |

**Cadence:**

- a major update every 3–4 months, with a codename and an announcement;
- minor updates when they are ready;
- hotfixes for blockers within 72 hours of a release.

> **Access rule.** Every channel is open to everyone at the same time. No early access, no exclusives, no privileges and no priority support for money — not for the project's modules and not for mods in recipes. See section 11.

### 5.4. Automation

| Trigger | Where | Steps |
|---|---|---|
| PR | GitHub Actions (cloud) | Build what changed; pack and recipe validator; JSON and YAML schemas; vanilla node registry; ScanCode plus the license allowlist; .NET tests; artifacts for the lab |
| `lab:run` label (maintainers only) | Self-hosted lab runner | Smoke scenario plus the scenarios of the affected mods, packs and recipes; report posted to the PR |
| Nightly on `dev` | Lab | Full regression: every scenario, every golden save |
| Scheduled | Cloud | Re-check every `linked` upstream; open an issue when a hash stops matching or a URL stops resolving; publish a pins addendum where appropriate (ADR-009) |
| Scheduled | Cloud | Refresh the public compatibility table from lab results; mark stale entries `unknown` |
| Push to `release/*` | Cloud | Beta build, pre-release, draft patch notes (git-cliff) |
| Tag `release-*` | Cloud | Build, SHA-256, manifest signing, GitHub Release |
| Manual | Cloud | Publishing to Nexus [through the API if the terms allow; otherwise by hand] |

**Secrets:**

- `MINISIGN_KEY` — only in the release cloud environment;
- the PR comment token — only on the lab host, never inside the VM;
- `NEXUS_API_KEY` — optional;
- Authenticode signing for the launcher — **0.1.0 ships unsigned** (ADR-019): the player guide states the warning plainly, every release publishes SHA-256 checksums and a minisign signature for the launcher itself, and Azure Trusted Signing is evaluated before 1.0.

**Alternative:** orchestrate the lab through Jenkins with a Windows agent; GitHub would then only start the job and receive the report.

### 5.5. When a new game patch ships

1. The launcher sees an unknown build and blocks installs and updates with a clear message.
2. A `port/cp2.xx` branch is created; the lab image is updated to the new build (GOG).
3. Full regression across every module and recipe; authors of `linked` and `compat` mods get a compatibility report.
4. `X.Y.Z+cp2.xx` ships, and a `compat` row is added to the manifest.
5. Builds for 2.31 stay available for as long as that version is listed in `compat`.

**The platform absorbs the churn where it can** (ADR-014). When a patch moves an engine symbol, path or structure that `core` exposes, core adapts and `core-api/N` keeps its shape, so a module built against it is not expected to know a patch happened. Patch-specific code paths in core are dated and removed one major release after the patch they compensate for.

Whether third-party code can be redirected at load time — the way SMAPI rewrites Stardew Valley mods against a changed game — is **unknown on this engine and is a spike** [spike]. Nothing in the port process assumes it.

Where a mod is broken by a patch and its author is absent, the recipe can point players at a community-maintained fix, subject to the author's permissions. An abandoned mod does not silently become a `compat` entry with no way forward.

### 5.6. Rollback

- **For the player:** `ncc rollback` — snapshots of the two most recent installs; before any data migration the launcher backs up saves.
- **Saves:** modules never write anything into a save that the save cannot load without; agent memory lives outside the save files.
- **Revoking a release:** the manifest gets `"status": "revoked"`, the launcher offers a rollback, and the fix ships through `hotfix/X.Y.Z`.

---

## 6. Development process

### 6.1. Roles

| Role | Who |
|---|---|
| Founder, architecture, release manager (at the start) | Daria |
| Platform maintainers: core, launcher, lab, sdk, brain | Daria, [first contributors] |
| Lab host operator | The contributor whose machine runs the lab (ADR-016): hardware, host OS, VM lifecycle, physical access |
| Recipe owners | The mod's author, or an assigned maintainer |
| Roadmap feature owners | Assigned from the poll results (step 5) |
| Maintainer council (finance, contested RFCs) | 3–5 people; until it exists, the first contributors hold interim duties, see section 11 |
| QA | The lab, the beta channel, community testers |
| Community management: polls, fan groups | Daria, [volunteers] |
| Assistant agents | Interior drafts, code review, draft patch notes and poll summaries; decisions stay with people |

### 6.2. Planning

- **Public roadmap** in GitHub Projects: Now / Next / Later, with an owner per feature.
- **Kanban:** Backlog → RFC → Ready → In progress → Lab → Review → Done.
- **Labels:** `track:*`, `module:*`, `recipe:*`, `pack:*`, `lab:run`, `saves-impact`, `api-change`, `license-check`, `P0–P2`.
- **Prioritisation:**
  1. Anything blocking the PR → lab → release → launcher cycle.
  2. Anything that helps authors arrive and port their mods.
  3. Roadmap features from the poll results.
  4. Research.

### 6.3. Iterations and the release train

- An iteration is two weeks, aimed at one thing verifiable in-game; the demo is a video and a devlog.
- The major release train: planning → development → freeze (`release/X.Y`) → two weeks of beta → stable → hotfix window. Whatever misses the train takes the next one.

### 6.4. RFCs

- **Required for:** a new module, a change to the API or any schema, a new S mechanic, a change to policy in `governance/`, and anything that touches saves.
- **Template:** problem, solution, alternatives, impact on saves and compatibility (including mods in recipes), migration plan.
- **Decision:** made by the maintainers of the affected area; disputes go to the council.

### 6.5. Code of conduct

Contributor Covenant in `governance/CODE_OF_CONDUCT.md`, with a contact for reports and a description of how they are handled.

### 6.6. Definition of Done

- [ ] Cloud CI green: build, schemas, node registry, license audit
- [ ] Lab: declared scenarios passed, report attached to the PR
- [ ] No new errors in the redscript, CET or RED4ext logs
- [ ] If data changed: `dataVersion` bumped, a migration written, golden saves load
- [ ] The module, pack or recipe can be disabled without breaking a save
- [ ] Patch notes and documentation updated
- [ ] License and attribution preserved; nothing put behind money

---

## 7. Testing and the lab

### 7.1. Levels of testing

| Level | What is checked | Where |
|---|---|---|
| Unit | Launcher: dependencies, versions, signatures; `brain`: perception, memory and reflection, intent parsing, translation into commands, migrations | Cloud (xUnit) |
| Contract | Schemas `ncc-pack/1`, `ncc-recipe/1`, `api v1`, manifests; a fake LLM: garbage answers, non-existent actions, manipulation attempts through player speech | Cloud |
| Licenses | ScanCode: a recognised license from the allowlist, or a permission file | Cloud |
| Launcher E2E | Install, update, rollback, unknown build, corrupt archive, revoked release — against a fake game folder | Cloud |
| Agent simulation without the game | The agent core in accelerated time on an abstract city map: hundreds of agents, weeks of game time. Metrics: share of executable intents, behavioural variety, loops, memory coherence, inference cost | Lab, nightly |
| In-game | Scenarios in the real game | Lab |
| Saves | Golden saves from every past release | Lab, nightly |
| Playtests | Gameplay, balance, feel | Beta channel, community |

### 7.2. The lab: how it is built

**Hardware and environment.**

- Dual AMD EPYC 7763 (128 cores / 256 threads), 512 GB RAM, 2 TB SSD, **five RTX 5060 Ti 16 GB**. The host runs Windows Server with Hyper-V. The machine belongs to a contributor and sits in their home (ADR-016).
- **A whole GPU per VM via Discrete Device Assignment (DDA)**, not GPU partitioning. Three cards drive three concurrent game VMs; two drive a `brain` VM for inference.
- The `brain` VM sits on the same internal switch and **also has no route out** — a game VM testing the L track needs inference, and inference may not live on the host or outside the isolated network.
- Inside a game VM: the GOG build of the game 2.31 from the offline installer, the pinned frameworks, `ncc`, the harness mod, PresentMon, ffmpeg. Checkpoint `clean-2.31`.
- Game VMs use **differencing disks from one golden parent VHDX**. 2 TB is the binding constraint here, not the GPUs; a full install per VM does not fit alongside checkpoints, models and golden saves.
- **Each VM is pinned to one NUMA node.** Cross-socket memory access on a dual-socket machine adds frame-time variance, and variance is what makes a numeric gate fire on its own.
- No VM holds tokens, keys or accounts. The PR-comment token lives on the host only.
- **Absolute frame rates here are lower than on a player's desktop** — EPYC is a server part and this game is sensitive to single-thread performance. Lab figures are regression signals against a baseline on the same hardware, and are never published as expected player performance.
- **Lab availability is not guaranteed.** It is a machine in someone's home. Cloud CI — builds, schemas, license audit, .NET tests — never depends on it. When the lab is down, changes that declare lab coverage wait; documentation and non-game code merge on cloud CI alone. There is no override that merges a game-affecting change without its lab report.

**A single MR run.**

1. A maintainer applies the `lab:run` label (for outside contributors, only after reading the diff).
2. The runner on the host downloads the cloud CI artifacts and the `dev` release manifest. **MR sources are never executed on the host.**
3. The host restores the checkpoint and copies artifacts and scenarios into the VM:

   ```powershell
   Restore-VMCheckpoint -VMName lab-01 -Name clean-2.31 -Confirm:$false
   Start-VM -Name lab-01
   pwsh ./lab/runner/push-artifacts.ps1 -VMName lab-01 -Artifacts .\artifacts -Scenarios .\lab\scenarios\pr
   ```

4. Inside the VM, `lab/guest/run.ps1` installs the release and the changes through `ncc`, starts the game with the harness mod and waits for readiness signals.
5. The harness runs the scenarios: load a golden save [spike: loading a save programmatically; fallback — input automation], teleport to points, set the time of day, wait for streaming, signal "frame ready".
6. On each signal the guest script takes a screenshot (ffmpeg), records frame metrics (PresentMon) and collects the redscript, CET and RED4ext logs.
7. The host pulls the results, shuts the VM down and rolls it back.
8. `lab/compare` compares against the baseline — the last `dev` run at the same points — and posts the report to the PR.

**How the lab decides what to check.**

- **Always:** `smoke` — the game reached the main menu, the golden save loaded, 60 seconds in the city without a crash.
- **From the diff:**
  - changed packs → their `lab.points`;
  - changed modules → their `lab.scenarios`;
  - changed recipes → the recipe's `lab.scenarios`;
  - a `dataVersion` change → migration across every golden save;
  - a `deps.lock.md` change → full regression.
- **Rule for authors:** every pack, module and recipe declares at least one scenario or point.

**Gates — these block a merge:**

- the game crashed or hung;
- redscript compilation errors;
- new critical errors in the logs;
- a save failed to load;
- average FPS dropped past the threshold (default 5% at pack points, 10% in interiors with NPCs);
- a migration failed.

**Informational — does not block, but is shown to the reviewer:**

- a visual screenshot diff above the SSIM threshold;
- new warnings in the logs;
- optionally, a vision model's read of what changed in the screenshots;
- for changes to agents, the vocabulary or `brain` — simulation metrics against the baseline, plus excerpts of agent thoughts and plans from the run.

**The PR report:** a table of scenarios and their status; before/after screenshots per point; FPS (average and 1% low) against the baseline; log error excerpts; a link to the archive with the full run and a short video.

**A crash does not end the run** (ADR-012). A run is a sequence of self-contained steps with a cursor the guest persists to disk after every step. When the game dies the supervisor captures the logs and the last screenshot, marks the step `crashed`, relaunches and continues at the next step. A step that crashes twice is marked `blocked` and skipped; the run ends when the steps or the per-scenario relaunch budget are exhausted. The harness signals an intentional exit explicitly, and any exit without that signal counts as a crash. Results are pulled to the host before the VM is rolled back.

The report separates `passed`, `failed`, `crashed`, `blocked` and `not run`. A reviewer must never have to guess whether a missing result passed quietly or was never attempted.

**Thresholds are measured before they are set.** A numeric gate that has not been validated for repeatability goes red on its own and teaches reviewers to ignore the report. Before enabling one, run the same revision repeatedly, measure the spread, and put the threshold outside it — recording the measurement next to the number. The same applies to SSIM: a visual check names the defect it looks for (a black face, a gap at the neck, a missing mesh, a hole in a facade), because "pixels changed" is noise.

**Scenarios run in the load order `ncc` produces on a player's machine.** A run against a different order tests a configuration nobody has.

**Throughput.** Three game VMs run concurrently, so smoke runs on pull requests no longer queue behind each other; `hotfix/*` still takes priority. Smoke run duration — [to be measured on the MVP]. Full regression runs nightly. Scaling means more hosts on the same scheme, each with its own purchased copy of the game.

### 7.3. Regression scenarios

| Area | Cases |
|---|---|
| Updates | Update over every previous stable; rollback; unknown game patch; interrupted download; a `linked` component unavailable; a `linked` component whose hash changed; a pins addendum that is valid, stale, mismatched, or carries fields it should not |
| Saves | A save from before the platform was installed; saves from past releases; removing a module or recipe and loading a save (`on-removed`); reinstalling a component that was previously removed; migration chains; a migration already recorded is not run twice |
| Recipes | An `included` mod with patches; a `linked` mod after a manual download; two mods touching the same resources |
| World | Doors, interiors, collision in openings, occluders, facade LODs |
| Life | Day cycle; `brain` unreachable (agents continue their last plan); timeouts; an invalid model response; a non-existent action → written to `unmet_intents`; Canon and Full freedom modes; a quest scene involving an agent; agents acting against each other and against V; **a crowd — several agents active near the player at once**, where comparable systems fail first; an agent asked by the player for something outside the vocabulary; an attempt to plant a false memory through conversation |
| Narrative | Jobs from packs: start, failure, repeat; overlap with the game's own quests |
| Integrations | cyberpunk-vr-port, the wheel mod, AMM, popular mod collections |

### 7.4. Compatibility

- **Game:** every `compat` entry; currently 2.31 only.
- **Dependencies:** strictly `deps.lock.md`.
- **Matrix:** CI checks that the `requires` of every module, pack and recipe in the release manifest can be resolved.
- **Public compatibility table:** every module, pack and recipe against every supported game patch — working, degraded, broken, unknown — with the date checked and a link to the lab run. Generated from lab results rather than maintained by hand, linked from the launcher and the site, and read by `ncc doctor` to explain to a player why something is not working. An entry whose last check is old displays as `unknown`, never as its last known state (ADR-014).
- **Porting to a new patch:** a `port/cp*` branch, an updated lab image, full regression, reports to authors.

### 7.5. Release QA checklist

- [ ] `ncc install` on a clean game and `ncc update` from the previous stable both pass
- [ ] `ncc rollback` works and saves still load
- [ ] The nightly full regression is green on the release revision
- [ ] Golden saves from every supported release load and can be continued
- [ ] License audit green, `THIRD_PARTY.md` current
- [ ] Compatibility with cyberpunk-vr-port, the wheel mod and AMM verified
- [ ] Patch notes and "what's new" match the release
- [ ] For `linked` recipes, the links to author pages work

---

## 8. Known problems and technical challenges

**Bugs.** None yet. Issue template: release and `+cp`, modules and recipes with versions (attach `ncc logs --bundle`), steps, expected and actual behaviour, priority, and a link to the lab run if there is one.

**Technical challenges.** Each has a plan or a research item.

| Challenge | Impact | Plan |
|---|---|---|
| Navigation in new interiors: the engine has `.navmesh` and sectors can carry navigation, but no part of the workflow is documented | NPCs walk in straight lines through obstacles | **ADR-021 (Proposed)** — open questions in order, plus an interim constraint: custom interiors are designed to work without navigation (one room, workspots, teleport), and nothing may ship depending on agents pathing inside them |
| Lip sync for runtime lines | Agents speak without facial animation | Research N4; subtitles and voice without facial animation for now |
| Cost and latency of decisions for hundreds of agents | Inference cannot keep up with the city | Planning horizons, re-planning on events, LOD, a priority queue, models of different sizes |
| Incoherent or looping agent behaviour | The city looks broken | Memory and reflection, metrics from the lab's simulation runs, iteration on models and prompts |
| Autonomy of story NPCs | The main story can break | Canon and Full freedom modes, agents paused during scenes |
| PS VR Aim Controller on PC | No driver exists | Research I3: reverse engineering and a SteamVR driver; PS VR2 Sense support in parallel |
| Story co-op | Quests are written for a single V | Research M2: our own co-op jobs first |
| The game (especially in VR) and an LLM on one graphics card | Not enough VRAM | A smaller model, a separate machine, or a cloud API |
| A native macOS build of the game | No ArchiveXL, no Codeware | The Windows build is what we support |
| Fragility against game patches | Native plugins break | `compat`, a block in the launcher, `port/*` |
| Loading a save programmatically in the lab | Automating runs | Spike in step 1; fallback — input automation |
| A crash ending a whole lab run | A crash early in a nightly regression hides every later result | Persisted step cursor, relaunch and continue; `blocked` after two crashes on one step (ADR-012) |
| An upstream file changing or disappearing | A signed release stops installing, through no fault of the author | `required: false` for `linked` components, degraded install, signed pins addendum, scheduled upstream re-checks (ADR-009) |
| Author permissions narrower than the license | Patching a mod whose author forbade modification | Permissions recorded per recipe and enforced by the validator; `unknown` counts as denied (ADR-010) |
| Agents agreeing to what the engine cannot do | Players expect a character that talks freely to act freely; the gap is where the illusion fails | Vocabulary feasibility is part of perception; commitments outside the vocabulary are logged to `unmet_intents` (ADR-008) |
| False memories planted through conversation | A crafted conversation becomes indistinguishable from something the agent witnessed | Memory records provenance — observed, heard from a source, or inferred — and reflection preserves it (ADR-008) |
| Crowds of agents near the player | Where comparable LLM-NPC systems degrade first: stalled conversations, agents that stop answering | Standing crowd scenario in the lab; priority inference queue |
| Cost of the nightly agent simulation | Published work reports thousands of dollars in tokens for 25 agents over two simulated days | Cost per simulated day is a tracked metric with a threshold set before the simulation is built |
| The game in a VM with GPU partitioning | Whether the lab works at all | Resolved: whole-GPU passthrough (DDA) instead of partitioning, five discrete cards available (ADR-016). What remains is a one-off verification that a consumer NVIDIA card passes through correctly |
| Native code from an MR in the lab | Host security | Maintainer approval, a disposable VM with no network and no secrets, artifacts only from cloud CI |
| Lab capacity | A queue of runs | Three concurrent game VMs; full regression nightly; more hosts as it grows |
| The lab lives in one person's home | Infrastructure depends on one household's power and connectivity | Cloud CI never depends on the lab; lab downtime blocks only changes that declare lab coverage (ADR-016) |
| Nexus API terms for direct downloads | The launcher cannot download from Nexus | GitHub as the source of truth; for `linked`, the author's page plus a hash check |
| An unsigned launcher | SmartScreen warning | 0.1.0 ships unsigned with published checksums and a plain-language guide; revisited at 1.0 (ADR-019) |
| Mixing the launcher with Vortex or MO2 | Files drift out of sync | Check-only mode |
| Packs and mods fighting over the same resources | Broken locations | The `claimsVanillaNodes` registry, lab runs on combinations |
| Voices of the original actors | Legal risk | Original or licensed voices only |

**Performance.**

- Bottlenecks: entity count near the player, sector streaming on teleport, the combined load of packs and mods in one district, the inference budget against the number of active agents.
- The lab measures FPS on every PR, so regressions are visible before a merge.

**Compatibility.** Incompatible mods — [from the lab's findings]. A public status table is kept for `compat`-tier mods.

---

## 9. Roadmap

### 9.1. Launch plan

| Step | What we do | Result (readiness criterion) | Target |
|---|---|---|---|
| **1. Environment (MVP)** | Repository, cloud CI, publishing, the console launcher, the lab with one scenario; spikes: the game in a VM, loading a save | The full cycle "PR → lab → merge → release → `ncc update`" runs with no manual steps beyond maintainer approval | Q4 2026 |
| **2. Process documentation** | `CONTRIBUTING.md`, `docs/guides/dev-setup.md`, `how-to-pr.md`, `lab-reports.md`, `docs/runbooks/release.md`, `docs/guides/player-launcher.md` | A newcomer can set up their environment and open a PR from the docs alone, the lab report arrives, and they never have to ask Daria | Q4 2026 |
| **3. First openly licensed mod** | Pick a mod with a license from the allowlist (ideally a well-known one); an `included` recipe; a lab run; notify the author | The mod ships in release 0.1.0; a demo video of "PR → lab report → update on the player's PC" | Q4 2026 |
| **4. Donations and policy** | Fiscal host, contributors page, `governance/donations.md` and `sponsorship.md`, the first public financial report | Funding stage A is running (section 11) | Q1 2027 |
| **5. Polls and roadmap** | Find fan groups; run the poll (open question first, options second); publish the results; send them to contributors; a roadmap with feature owners | Results published, and GitHub Projects holds a roadmap with an owner on every Now/Next feature | Q1 2027 |
| **6. Inviting modders** | Personal messages to authors with the demo and the poll results; what we give and what we do not ask for (section 10.4) | The first outside maintainers and recipes | Q1–Q2 2027 |
| **7. Mod porting guide** | `docs/guides/migrate-mod.md`: choosing a tier, the recipe, lab scenarios, the license, upstream patches | An author opens a recipe PR on their own, from the guide | Q1 2027 (in time for step 6) |
| **8. Help with porting** | Pair sessions, reviewing recipe PRs, fixing tooling from the feedback | N mods ported [target set after step 5] | Q2 2027 |
| **9. Presenting ideas to the community** | The candidate catalogue (section 2.3) as draft RFCs; discussion; a vote | Ideas with support have an RFC and an owner | Q2 2027 |

Dates assume evening work and are indicative; they are refined after step 1.

### 9.2. Releases

| Release | Contents | Metrics |
|---|---|---|
| **0.1.0 "Foundation"** | The output of steps 1–3: the core skeleton, `ncc`, the lab MVP, the first mod in a recipe | The full cycle with no manual steps; a lab report on every PR |
| **0.2.0 "Ecosystem"** | Three recipe tiers, license audit, the porting guide, scenarios from the diff, the contributors page, save migrations (P4) | At least one outside mod ported by its own author; the nightly regression stable for a week |
| **0.3.0 onward** | From the step 5 roadmap: content and system features from section 2.3, each with an owner | Defined in each feature's RFC |
| **1.0.0** | Stable `core-api/1`, `ncc-pack/1`, `ncc-recipe/1`; the launcher GUI; a save migration guarantee | Saves from the first content releases load on 1.0 |

**Research tracks (in parallel):** I3 — the PS VR Aim Controller; M1/M2 — multiplayer and co-op jobs; N4 — runtime lip sync; navmesh in new interiors.

### 9.3. Risks and dependencies

| Risk | Impact | Mitigation |
|---|---|---|
| Modders do not show up | The ecosystem grows slowly | Include openly licensed mods; `linked` and `compat` need no author involvement; the lab's value is visible in the demo |
| License violations while collecting mods | DMCA, conflict with the community | ADR-005, the audit in CI, permission files, no relicensing |
| The project is read as a threat to authors' income | They refuse to take part | Authors stay on Nexus, `linked` downloads count for them, the contributors page carries their donation links |
| The CD Projekt letter is deferred | The shared grant fund stays closed and legal uncertainty remains | Stage A without grants; stage B only after written confirmation (section 11) |
| A security incident in the lab | Host compromise | ADR-006, maintainer approval, VM isolation |
| The lab spikes fail (GPU-P, loading a save) | An MVP without full automation | The fallbacks in section 8 |
| A new game patch ships | Dependencies and mods break | `compat`, `port/*`, reports to authors |
| Save migration bugs | Players lose progress | `dataVersion`, golden saves, launcher backups |
| Scope growth at a small bus factor | Everything stops | A stepwise launch plan; more maintainers before content features. Two people as of September 2026, with the lab host held by the second |
| The lab depends on one contributor's machine and household | Loss of the test lab | Cloud CI is independent of it; the lab image and its game copy belong to that host and are not transferable, so a replacement host means new hardware and a new purchased copy (ADR-016) |
| CD Projekt or Nexus change their position | The project or mods get taken down | Strictly free, no strings attached to content, policies monitored |

---

## 10. The mod ecosystem

### 10.1. The principle

Open source does not mean the absence of copyright: the code stays the author's, and a license merely permits use on stated terms. A public repository with no license may not be copied or redistributed. Mods on Nexus are not open source by default — the author sets their own permissions for reuploading, modification and asset use. This is why the project assembles mods as a distribution, through recipes (ADR-005).

### 10.2. Inclusion tiers

| Tier | When | What we store | How the player gets it |
|---|---|---|---|
| `included` | A license from the allowlist, or written permission from the author | Source/files with the author's LICENSE, attribution and our patches | From the project's release, through `ncc` |
| `linked` | Redistribution is not allowed, but the mod is free to download | The recipe only: link, hash, compatibility patches, scenarios | `ncc` opens the author's page and verifies the downloaded file |
| `compat` | The author objects to inclusion, or has not answered | Only an entry in the compatibility table and a lab scenario | The player installs it themselves |

**License allowlist for `included`** (ADR-018). Unconditional: MIT, MIT-0, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, 0BSD, MPL-2.0, CC0-1.0, Unlicense; CC-BY-4.0 for non-code. Conditional: GPL-3.0 and LGPL-3.0 only as separate artifacts, with our own code never linking against them; CC-BY-SA-4.0 for non-code only while we ship assets as released, since creating a derivative asset propagates share-alike. **Never accepted at any tier:** any `-NC` or `-ND` licence, and no licence at all.

**Permissions are read separately from the license** (ADR-010). Upstream platforms let an author set redistribution, modification, conversion and asset use independently, and a permissive stance on one says nothing about the others. The recipe records them with a source link and the date they were checked, and the validator derives what we may do:

| Operation | Requires |
|---|---|
| Tier `included` | `redistribute: allowed` |
| Shipping anything in `patches/` | `modify: allowed` |
| Unpacking or repacking upstream archives | `modify: allowed` |
| A recipe for a mod ported to another game patch | `convert: allowed` |
| Reusing a mod's assets in our content | `assets: allowed` |

`unknown` counts as `denied`. A mod whose author forbids modification can still be `linked` — pinned, hash-verified, with lab scenarios — but it cannot carry our patches; where a patch would be needed to make it work, it becomes `compat` with the reason recorded publicly.

**Rules:**

- the author's license is preserved; relicensing is forbidden;
- attribution appears in the recipe, in `THIRD_PARTY.md`, in the launcher and on the contributors page;
- our changes are kept as patches and proposed upstream;
- a recipe with no recognised license cannot reach the `included` tier, and CI blocks it;
- the author's permission lives in `governance/permissions/<id>.md`: a link to the message, the date, and the scope of what was permitted;
- extracted game assets are never redistributed on their own.

### 10.3. Protecting authors' interests

- Joining the project does not require leaving Nexus, changing a license, or giving up donations.
- Downloads of `linked` mods go through the authors' own pages.
- **An author may have their mod removed at any time, at any tier, including a compatibility entry, without giving a reason** (ADR-011). No review, no appeal, no negotiation. Removed from `dev` the next working day and from the next release; the withdrawal is recorded in `governance/permissions/<mod-id>.md` with its date. **No archival copy is kept** to keep a release installable — ADR-009 is what makes releases survive a component disappearing. The route is published in `governance/author-rights.md`.
- Inclusion at `included` is opt-in: it requires a permissive license or written permission, and is never inferred from silence.
- An author who becomes the recipe owner decides which patches are accepted.
- **Declining to take part is not met with our own version of their mod** (ADR-022). Reimplementing an idea is lawful and is not what this project does: "work with us or we will build it ourselves" is not an invitation. The `compat` tier needs nothing from an author, so a refusal never blocks compatibility testing.

### 10.4. What we offer modders (step 6)

- The lab: a report with screenshots, FPS and logs on every change, free.
- A working release pipeline and distribution through the launcher.
- Compatibility reports when game patches ship.
- A contributors page linking to their donations, and grants later (section 11).
- Fan poll results: what players actually want from their mods.
- A place on the roadmap and ownership of features.

### 10.5. Mod porting guide (step 7) — contents

1. Choosing a tier from the license.
2. Creating `recipes/<id>/recipe.yaml` from the SDK template.
3. Declaring lab scenarios and points.
4. Local checks: `Validator validate`, `scancode`, `deploy.ps1`.
5. The `recipe/<id>` PR, and reading the lab report.
6. Patches, and sending them upstream.
7. Becoming the recipe owner (CODEOWNERS).

---

## 11. Funding

### 11.1. Constraints

- **CD Projekt Red:** the company has called the "free plus voluntary donations" model acceptable for an individual modder. Profiting from their IP in any form, by their account, requires permission. A shared fund distributed among contributors is not addressed directly — hence the stages below.
- **Nexus:** mods, updates or support in exchange for donations are forbidden, as are paid early access and stretch goals for mod development.
- **Money never passes through the founder's personal account** — only through a fiscal host with a public ledger (Open Collective, for example) [verify host availability and payouts for contributors' countries].

### 11.2. Stages

| Stage | When | What is running |
|---|---|---|
| **A** | Plan step 4 | Infrastructure funding (lab hardware, hosting, a signing certificate); a contributors page linking to authors' personal donations; a monthly report |
| **B** | After written confirmation from CD Projekt Red (the letter is deferred) | A shared fund with quarterly grants to contributors |

### 11.3. Shared fund allocation (stage B, opening proposal)

| Line | Share |
|---|---|
| Infrastructure | 40% |
| Reserve | 10% |
| Quarterly contributor grants | 50% |

Until stage B, 100% of income goes to infrastructure and reserve.

### 11.4. Grants

- Decided by the maintainer council (3–5 people), not by the founder.
- **Public criteria:** maintaining modules and recipes after game patches, roadmap work, tooling and the lab, documentation, helping others port mods, community work. Art, writing, voice acting, translation and QA count equally with code.
- A grant recognises work already done in the quarter; it is **not** payment for a future feature.
- Amounts and recipients are published in the report with a short justification.

### 11.5. Rules

1. **No privileges for money:** no early access, no exclusives, no weight in polls or the roadmap, no priority support. A mention in the credits is acceptable if the donor wants one.
2. **Money with strings attached to content is refused**, whatever the amount and whatever it is called ("add brand X and we will donate"). The project carries no advertising and no paid product placement.
3. **Infrastructure sponsors are accepted:** hardware, hosting, CI. They are credited on the project site, nothing appears in the game, the sponsor has no influence on the roadmap, and the sponsorship is disclosed in the report.
4. **Founder's conflict of interest:** any payment to Daria from the fund is a separate line in the report, approved by the council without her vote.
5. **Transparency:** a monthly report — income, spending, grants.
6. **Leaving the project:** paid grants are not returned; rights to the code are set by its license, not by fund policy.
7. **Taxes:** every recipient declares income in their own country; the fiscal host provides payout documentation.
8. **Interim governance:** while there is no council, stage B does not open; stage A decisions (infrastructure only) are published with receipts.

### 11.6. Fan polls (step 5) — method

- **Channels:** fan communities on Reddit, Discord and Nexus, regional groups on social networks and messengers; a link in the launcher.
- **Poll structure:**
  1. An open question — "What do you miss in the game?" — before any options are shown.
  2. A choice among the candidates from section 2.3, and ranking them.
  3. What gets in the way of using mods today.
  4. Willingness to test the beta.
- **A vote does not depend on donations;** ballot stuffing is limited to one response per account on the polling platform.
- **Results:** a public summary → sent to contributors → a planning session → a roadmap with an owner on every feature.

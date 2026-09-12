# deps.lock.md

Every dependency this project pins, with the exact version and a link to the exact file.
This file is the source of the `requires` block in a release manifest.

**Rules.**

- Nothing here is bumped as a side effect of another change. A version change is its own PR.
- A change to this file triggers a **full lab regression**, not a smoke run.
- `[pin]` means the version is not frozen yet: it gets filled in when the Windows environment
  is set up and the actual installed version is known. Do not guess one.

## Game

| Item | Version | Build | Source |
|---|---|---|---|
| Cyberpunk 2077 (PC, Windows) | **2.31** | 5294808 | Retail. The lab uses the GOG offline installer (ADR-007) |

The game's own auto-update must be disabled on any machine used for development or testing.
An unknown build makes the launcher refuse to install, by design.

## Runtime frameworks

Installed on the player's machine by `ncc` from official sources.

| Item | Version | File / release | Notes |
|---|---|---|---|
| RED4ext | **1.30.0** | [pin] | Native plugin loader |
| Codeware | **1.20.3** | [pin] | Entities, scriptable services, UI |
| redscript | [pin] | [pin] | Core, modules, harness |
| ArchiveXL | [pin] | [pin] | Sectors, node removal |
| TweakXL | [pin] | [pin] | TweakDB |
| Cyber Engine Tweaks | [pin] | [pin] | Debugging and the lab harness. Never ships in a release module |
| Mod Settings | [pin] | [pin] | In-game settings |
| RedHttpClient | [pin] | [pin] | HTTP from the game to `brain` |
| UnlimitedGeometryCacheStreaming | [pin] | [pin] | Collision in our own sectors |

## Authoring tools

Not shipped. Needed to build content and world changes.

| Item | Version | Notes |
|---|---|---|
| WolvenKit / WolvenKit.CLI | **9.0.1** | .NET 10 |
| World Builder (CP77_entSpawner) | [pin] | Interiors, community nodes |
| RedHotTools | [pin] | World Inspector |
| removalEditor | [pin] | Removing vanilla nodes |
| VolumetricSelection2077 | [pin] | Bulk node removal |
| Blender | [pin] | Meshes, colliders |
| Cyberpunk IO Suite (Blender add-on) | [pin] | glTF import/export, PhysX collision |
| AppearanceMenuMod | [pin] | NPC debugging, development only |

## Platform and services

| Item | Version | Notes |
|---|---|---|
| .NET SDK | **10** | Launcher, `brain`, validator, lab utilities |
| PowerShell | **7+** (`pwsh`) | Every script in `tools/`, `lab/runner/`, `lab/guest/` |
| minisign | [pin] | Release manifest signatures |
| ScanCode Toolkit | [pin] | License audit |

## Lab

| Item | Version | Notes |
|---|---|---|
| Windows 11 Pro + Hyper-V | [pin] | Host. GPU-P is [spike] — see `docs/rfc/` |
| PresentMon | [pin] | FPS and frame times |
| ffmpeg | [pin] | Screenshots and run video |

## Inference

Chosen by the player; the project does not ship model weights.

| Item | Version | Notes |
|---|---|---|
| llama.cpp (CUDA) | [pin] | Local inference |
| Qwen model for dialogue | [pin] | ~4–9B alongside the game; Qwen3.8 27B on a separate machine. Quantisation matched to VRAM |

Alternative endpoints supported by `brain`: LM Studio (`localhost:1234/v1`),
Ollama (`localhost:11434/v1`), or a cloud API. If `brain` is unreachable the game stays
stable and modules run without an LLM.

# services/

Out-of-game services. Currently one: `brain/`.

`brain` is the .NET 10 service behind autonomous agents — perception filtering, memory,
reflection, LLM calls and intent parsing. The game talks to it over HTTP using the
`brain api: v1` contract. If it is unreachable the game stays stable and agents continue
their last plan.

Read `brain/AGENTS.md` before changing anything here. ADR-008 is not negotiable.

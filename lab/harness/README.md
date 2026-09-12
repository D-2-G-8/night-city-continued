# lab/harness/

The test mod that runs inside the game during a lab run.

It is what makes a run reproducible: teleport to a declared point, set the time of day,
wait for streaming to settle, then raise a "frame ready" signal the guest script watches for.
It also drives scenario steps and writes its own log.

CET Lua and redscript live here. **None of it ships in a release** — the harness is a test
instrument, not a feature.

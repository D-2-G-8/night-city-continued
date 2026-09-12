# ADR-012: A lab run resumes after the game crashes

- **Status:** Accepted
- **Date:** 2026-09-12
- **Deciders:** Daria (project owner)
- **Track:** T — Tooling
- **Extends:** ADR-006 (lab isolation)

## Context

The lab exists to find crashes. A crash is therefore the most valuable result a run can
produce — and, in the obvious design, the one that destroys the run that found it.

A nightly full regression visits dozens of points across packs, modules, recipes and golden
saves. If the game crashing ends the run, a crash at the third point means the remaining
points were never tested. The report says "crashed", the reviewer learns one fact, and the
next night the same thing happens one point later.

Modsvaskr, which automates the same kind of testing for Bethesda games, treats this as the
central problem rather than an edge case: it monitors the game, collects per-test pass/fail
into JSON in the game's data folder, and resumes testing after crashes by restarting the game
automatically.

## Decision

**A run is a sequence of steps with a persisted cursor. A crash fails a step; it does not end
the run.**

- The scenario's steps and their results live in a JSON file inside the guest, written after
  every step. It survives the process dying, which is the point.
- The guest supervisor watches the game process. On an unexpected exit it captures the logs
  and the last screenshot, marks the current step `crashed`, advances the cursor, relaunches
  the game and continues from the next step.
- **A step that crashes twice is marked `blocked` and skipped.** Two crashes at one point is
  already the finding; a third adds nothing and costs a relaunch.
- A run ends when the steps are exhausted or a **per-run relaunch budget** is spent. The
  budget is part of the scenario definition, so a smoke run and a nightly regression can
  differ.
- The report distinguishes `crashed` (the game died at this step), `blocked` (crashed twice,
  skipped) and `not run` (the budget ran out before reaching it). A reviewer must never have
  to guess whether a missing result means "passed quietly" or "never attempted".
- Crashes stay blocking gates. Resuming changes how much the run learns, not whether the PR
  can merge.

This lives entirely in `lab/guest/`. The host keeps its role from ADR-006: restore, push,
collect, roll back. The relaunch loop runs inside the disposable VM, and nothing about this
decision lets guest code reach the host.

## Consequences

- One PR produces the full picture: every failing point, not just the first.
- Runs take longer and vary in length, since a crash costs a relaunch plus a reload. The
  relaunch budget bounds the worst case.
- The guest supervisor has to tell an expected exit from a crash. Getting this wrong in one
  direction hides crashes, and in the other burns the budget on clean shutdowns. The harness
  therefore signals intentional exit explicitly, and any exit without that signal counts as
  a crash.
- Per-step state in the guest means a step must be self-contained: load the save, teleport,
  set the time, wait for streaming. A step that assumes the previous step left the game in a
  particular state cannot be resumed into, and the scenario schema forbids it.
- The state file records progress on disk inside a VM that is destroyed after the run.
  Results are pulled to the host before rollback; missing that ordering loses the whole run.

## Alternatives considered

- **Abort on the first crash.** Simple, and it makes the nightly regression a crash bisector
  instead of a regression suite.
- **Rerun the whole scenario after a crash, skipping known-bad steps.** Same information,
  several times the wall-clock, on hardware that runs one job at a time.
- **One VM per step.** Perfect isolation, and a checkpoint restore per point. Unaffordable at
  regression scale for a benefit the cursor already provides.

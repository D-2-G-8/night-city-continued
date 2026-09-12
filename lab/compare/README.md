# lab/compare/

Turns a finished run into a verdict: screenshot comparison (SSIM), FPS against the baseline,
new errors in the logs, and the markdown report posted to the PR.

The baseline is the last `dev` run at the same points.

Blocking gates and informational signals are defined in `docs/techdoc.md` section 7.2.
**Raising a threshold to make a run go green is a human decision, in its own PR, with a
reason** — never a quiet edit alongside the change being tested.

A threshold is measured before it is set: run the same revision repeatedly, measure the
spread, and put the threshold outside it. Record the measurement next to the number. An
unvalidated numeric gate goes red on its own and teaches reviewers to ignore it.

The report distinguishes `passed`, `failed`, `crashed`, `blocked` (crashed twice, skipped)
and `not run` (budget exhausted before reaching it). A reviewer must never have to guess
whether a missing result passed quietly or was never attempted.

# lab/compare/

Turns a finished run into a verdict: screenshot comparison (SSIM), FPS against the baseline,
new errors in the logs, and the markdown report posted to the PR.

The baseline is the last `dev` run at the same points.

Blocking gates and informational signals are defined in `docs/techdoc.md` section 7.2.
**Raising a threshold to make a run go green is a human decision, in its own PR, with a
reason** — never a quiet edit alongside the change being tested.

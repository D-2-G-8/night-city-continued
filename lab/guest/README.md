# lab/guest/

Scripts that run inside the lab VM: install the release and the change under test through
`ncc`, start the game with the harness, capture screenshots (ffmpeg), frame metrics
(PresentMon) and the redscript, CET and RED4ext logs.

The VM has no outbound network and no credentials. Anything here must work offline and must
not expect a token, an account or a shared drive.

## Surviving a crash (ADR-012)

The guest supervisor owns the run cursor. Step results are written to a JSON file after every
step, so they survive the game process dying — which is the point, since a crash is the most
valuable thing a run can find.

On an unexpected exit: capture logs and the last screenshot, mark the step `crashed`, advance
the cursor, relaunch, continue. Twice on the same step means `blocked` and skip. The run ends
when steps or the relaunch budget are exhausted.

The harness signals an intentional exit explicitly. **Any exit without that signal is a
crash** — guessing in one direction hides crashes, and in the other burns the budget on clean
shutdowns.

Results are pulled to the host **before** the VM is rolled back. Getting that order wrong
destroys the run.

# lab/runner/

Host-side scripts: restore the VM checkpoint, push artifacts in, start the run, pull results
out, post the report to the PR.

**This directory is the security boundary.** ADR-006 in one line: MR code is built in cloud
CI, the runner downloads only artifacts, and those artifacts execute only inside a disposable
VM with no network and no secrets. A run starts from a maintainer's `lab:run` label, never
automatically on an outside contributor's PR.

Never add a step here that executes anything from an MR on the host.

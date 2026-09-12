# tests/golden-saves/

Reference save files, one set per released `dataVersion`, tracked with Git LFS.

The lab loads these to prove two things on every change that touches save data:

1. A save written by an older release still loads after migration.
2. Disabling a module or recipe does not break a save that used it.

Add a new golden save whenever `dataVersion` is bumped. Never delete an old one —
a save from the first content release must still load on 1.0.

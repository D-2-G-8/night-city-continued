# lab/scenarios/

Scenario definitions the harness executes, as JSON validated against the SDK schema.

`smoke` is the one that always runs: the game reached the main menu, the golden save loaded,
60 seconds in the city without a crash.

Everything else is selected from the diff — a changed pack brings its `lab.points`, a changed
module or recipe brings its `lab.scenarios`. Every pack, module and recipe must declare at
least one scenario or point, otherwise its change ships untested.

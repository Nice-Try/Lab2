# Nice Try Lab 2 Report

Carl Moser, Louise Nielsen, Camille Xue

## Input Conditioner

Report-related deliverables:
- circuit diagram
- wave forms
- probably describe test cases
- maximum length input glitch suppressed by this

## Shift Register

We wanted to check that parallel load worked, that serial load worked, and that parallel data in had priority over serial load, and that this all worked for serial data out.

Priority (parallel vs serial load): We tested this by asserting `parallelLoad` with the least significant bit of `parallelDataIn` different from `serialDataIn` (in the first test).

Parallel load works: We tested this by loading a number (b10010100) into the shift register and comparing it against that number.

Serial load works: We ran two tests that checked this. First, starting from parallel out of b10010100 (from above), we serially loaded 8 1s, until the whole shift register held 1s. We tested this by comparing against the value above inverted, shifted left by the index of the for loop, and inverted again (effectively shifting left by right padding with 1s instead of 0s). Second, we parallel loaded in all 0s and then serial loaded in b10010100 (that same value). We tested this by comparing against the value right shifted by width minus index.

Because we had thoroughly tested this for `parallelDataOut`, in order to test `serialDataOut`, we just compared it (in all of the above cases) to the most significant bit of `parallelDataOut`.

## Midpoint Check In

Report-related deliverables:
- not sure, but I guess we could put our test sequence here.

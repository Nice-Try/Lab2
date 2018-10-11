# Nice Try Lab 2 Report

Carl Moser, Louise Nielsen, Camille Xue

## Input Conditioner

Report-related deliverables:
- circuit diagram
- wave forms

The input conditioner is tested with 2 main cases: short bounces between 0 and 1 at the begining and then settling to either 0 or 1. The noisy pin is flipped quickly between 0 and 1 6 times at the beginning of the test, and then the settles to 1. This shows how the input conditioner handles a noisy signal, how the conditioned output changes after the noise settles, and the positive edge being detected. The input remains high for some time before there is more noise and the signal settles to 0. This change between the 1 and the 0 allows the negative edge to trigger and also tests the debouncing when the conditioned output is already high.

- maximum length input glitch suppressed by this
50 MHZ -> 20 ns clock period
20 ns * 10 waittime = 200 ns


## Shift Register

Report-related deliverables:
- probably a circuit diagram, but not required by thing
- description of test bench strategy

## Midpoint Check In

Report-related deliverables:
- not sure, but I guess we could put our test sequence here.

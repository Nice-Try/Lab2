# Nice Try Lab 2 Report

Carl Moser, Louise Nielsen, Camille Xue

## Input Conditioner

Report-related deliverables:
- circuit diagram
- wave forms
- probably describe test cases
- maximum length input glitch suppressed by this

## Shift Register

Report-related deliverables:
- probably a circuit diagram, but not required by thing
- description of test bench strategy

## Midpoint Check In

### Test Sequence
These are the steps a test engineer should follow to verify that our midpoint module works as intended on an FPGA.
1. Testing Parallel Load & Parallel Out
- Press Button 0 to signal Parallel Load
- Since our parallel load value is pre-determined, you should just see the results. The LSB's should display on the LED and the expected results are 0100.
- To see the MSB's, toggle Switch 2 on. The expected results are 1001.

2. Testing Serial Load & Parallel Out
- To input serial data, use Switch 0. Having on gives a 1 and having it off gives a 0 as the serial data input
- Switch 1 on to send peripheral clock edge, which inputs the serial data
- repeat this until 8 bits have been inputted
- See result and expect the same values as what was inputted. Use switch 2 to toggle between seeing the 4 LSBs and the 4 MSBs

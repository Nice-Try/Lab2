#! /bin/bash

iverilog -o inputconditioner.vvp inputconditioner.t.v
iverilog -o shiftregister.vvp shiftregister.t.v
iverilog -o fsm.vvp fsm.t.v

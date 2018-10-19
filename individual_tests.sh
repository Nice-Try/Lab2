#! /bin/bash

iverilog -o inputconditioner.vvp inputconditioner.t.v & ./inputconditioner.vvp
iverilog -o shiftregister.vvp shiftregister.t.v& ./shiftregister.vvp
iverilog -o fsm.vvp fsm.t.v& ./fsm.vvp

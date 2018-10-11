//-----------------------------------------------------------------------------
//  Wrapper for Lab 2: Midpoint Checkin
//
//     This wrapper module allows you to load in parallel load, serial input,
//     and peripheral clock edge. It multiplexes the results on the LEDS so you
//     see half the parallel out at a time.
//
//
//  Usage:
//     btn0 - Parallel load (parallel in is hardcoded for now)
//     sw0  - serial in value
//     sw1  - peripheral clock edge
//     sw2  - switch between LSBs (0) and MSBs (1) of parallel out on LEDs
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

`include "midpoint.v"


//-----------------------------------------------------------------------------
// Basic building block modules
//-----------------------------------------------------------------------------

// D flip-flop with parameterized bit width (default: 1-bit)
// Parameters in Verilog: http://www.asic-world.com/verilog/para_modules1.html
module dff #( parameter W = 1 )
(
    input trigger,
    input enable,
    input      [W-1:0] d,
    output reg [W-1:0] q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end
    end
endmodule

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule


//-----------------------------------------------------------------------------
// Main Lab 2 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//
//-----------------------------------------------------------------------------

module fpga_wrapper
(
    input        clk,
    input  [2:0] sw,
    input  [1:0] btn,
    output [3:0] led
);
    // Instantiate vars for midpoint module
    wire parallelLoad;
    reg [7:0] parallelDataIn = 8'b10010100;
    wire serialDataIn;
    wire peripheralClk;
    wire [7:0] parallelDataOut;
    wire res_sel;
    wire serialDataOut;

    // Capture switch input to switch which MUX input to LEDs
    mux2 #(4) output_select(.in0(parallelDataOut[3:0]), .in1(parallelDataOut[7:4]), .sel(sw[2]), .out(led));

    midpoint mod(.clk(clk),
                 .parallelLoad(btn[0]),
                 .parallelDataIn(parallelDataIn),
                 .serialDataIn(sw[0]),
                 .peripheralClkEdge(sw[1]),
                 .parallelDataOut(parallelDataOut),
                 .serialDataOut(serialDataOut));

endmodule

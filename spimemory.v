//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"
`include "fsm.v"

module spiMemory
(
  input           clk,        // FPGA clock
  input           sclk_pin,   // SPI clock
  input           cs_pin,     // SPI chip select
  output          miso_pin,   // SPI master in slave out
  input           mosi_pin,   // SPI master out slave in
  output [3:0]    leds        // LEDs for debugging
);

wire conditioned_mosi;
wire conditioned_cs;
wire positive_edge;
wire negative_edge;


inputconditioner mosi_input(.clk(clk),
                            .noisysignal(mosi_pin),
                            .conditioned(conditioned_mosi),
                            .positiveedge(),
                            .negativeedge());

inputconditioner sclk_input(.clk(clk),
                            .noisysignal(sclk_pin),
                            .conditioned(),
                            .positiveedge(positive_edge),
                            .negativeedge(negative_edge));

inputconditioner cs_input(.clk(clk),
                          .noisysignal(cs_pin),
                          .conditioned(conditioned_cs),
                          .positiveedge(),
                          .negativeedge());


shiftregister shift(.clk(clk),
                    .peripheralClkEdge(positive_edge),
                    .parallelLoad(),
                    .parallelDataIn(),
                    .serialDataIn(conditioned_mosi),
                    .parallelDataOut(),
                    .serialDataOut());

FSM dut(.sclk_edge(positive_edge),
        .CS(conditioned_cs),
        .shiftRegOutP0(),
        .miso_buff(),
        .dm_we(),
        .addr_we(),
        .sr_we());

endmodule

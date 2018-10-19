//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"
`include "datamemory.v"
`include "tristate.v"
`include "fsm.v"
`include "dff.v"

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
wire dm_we;
wire miso_buff;
wire addr_we;
wire sr_we;
wire serial_out;
wire dffq;
wire [7:0] shift_reg_out;
wire [6:0] address;
wire [7:0] data_mem_out;



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
                    .parallelLoad(sr_we),
                    .parallelDataIn(data_mem_out),
                    .serialDataIn(conditioned_mosi),
                    .parallelDataOut(shift_reg_out),
                    .serialDataOut(serial_out));

datamemory dmem(.clk(clk),
                .dataOut(data_mem_out),
                .address(address),
                .writeEnable(dm_we),
                .dataIn(shift_reg_out));

tristate tris(.in(dffq),
              .enable(miso_buff),
              .out(miso_pin));

dff flip_flop(.trigger(clk),
              .enable(negative_edge),
              .d(serial_out),
              .q(dffq));

FSM dut(.sclk_edge(positive_edge),
        .CS(conditioned_cs),
        .shiftRegOutP0(shift_reg_out[0]),
        .miso_buff(miso_buff),
        .dm_we(dm_we),
        .addr_we(addr_we),
        .sr_we(sr_we));

endmodule

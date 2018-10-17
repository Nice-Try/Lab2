`include "fsm.v"

module testFSM();
  reg sclk_edge;
  reg CS; //chip select
  reg shiftRegOutP0; // R/W bit
  wire miso_buff;
  wire dm_we;
  wire addr_we;
  wire sr_we;

  // Instantiate DUT
  FSM dut(.sclk_edge(sclk_edge),
          .CS(CS),
          .shiftRegOutP0(shiftRegOutP0),
          .miso_buff(miso_buff),
          .dm_we(dm_we),
          .addr_we(addr_we),
          .sr_we(sr_we));

  // Generate clock
  initial sclk_edge=0;
  always #10 sclk_edge=!sclk_edge;


  initial begin
  $dumpfile("fsm.vcd");
  $dumpvars();
  CS = 1; #20
  CS = 0;
  shiftRegOutP0 = 1; #15
  $display("Begin testing fsm.v");
  $display("Output     Result     Expected");
  repeat (100) begin
    #20
    $display("miso_buff: %b         %b", miso_buff, 1'b1);
    $display("dm_we:     %b         %b", dm_we, 1'b1);
    $display("addr_we:   %b         %b", addr_we, 1'b1);
    $display("sr_we:     %b         %b", sr_we, 1'b1);
    $display("----------------------");
  end
  $finish();
  end

endmodule

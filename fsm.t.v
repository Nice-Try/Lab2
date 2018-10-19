`include "fsm.v"

module testFSM();

  // Instantiate test vars
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

  // Helper vars
  reg dutpassed = 1;

  // Local params so testing sucks a little less
  localparam FINAL = 4'b0000,
              ADDR = 4'b0000,
                RW = 4'b0010,
         READ_LOAD = 4'b1001,
              READ = 4'b1000,
             WRITE = 4'b0000,
          WRITE_DM = 4'b0100;

  initial begin
  $dumpfile("fsm.vcd");
  $dumpvars(0, dut);
    // Set CS to 1, wait clock cycle
    shiftRegOutP0 = 1;
    CS = 1; #25
    if (FINAL !== {miso_buff, dm_we, addr_we, sr_we}) begin
      dutpassed = 0;
    end

    // Set CS to 0, test read cycle
    CS = 0;
    repeat (7) begin
      #20 if (ADDR !== {miso_buff, dm_we, addr_we, sr_we}) begin
        dutpassed = 0;
      end
    end

    #20 if (RW !== {miso_buff, dm_we, addr_we, sr_we}) begin
      dutpassed = 0;
    end

    #20 if (READ_LOAD !== {miso_buff, dm_we, addr_we, sr_we}) begin
      dutpassed = 0;
    end

    repeat (7) begin
      #20 if (READ !== {miso_buff, dm_we, addr_we, sr_we}) begin
        dutpassed = 0;
      end
    end

    // Test write cycle
    shiftRegOutP0 = 0; #20

    repeat (6) begin
      #20 if (ADDR !== {miso_buff, dm_we, addr_we, sr_we}) begin
        dutpassed = 0;
      end
    end

    #20 if (RW !== {miso_buff, dm_we, addr_we, sr_we}) begin
      dutpassed = 0;
    end

    repeat (7) begin
      #20 if (WRITE !== {miso_buff, dm_we, addr_we, sr_we}) begin
        dutpassed = 0;
      end
    end

    #20 if (WRITE_DM !== {miso_buff, dm_we, addr_we, sr_we}) begin
      dutpassed = 0;
    end

    if (dutpassed == 1) begin
      $display("FSM tests passed");
    end

    $finish();
  end
endmodule

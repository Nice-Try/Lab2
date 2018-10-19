`include "spimemory.v"

module spimemorytest();

  // Instantiate inputs and outputs
  wire       clk;         // FPGA clock
  wire       sclk;        // SPI clock
  wire       cs;          // SPI chip select
  wire       miso;        // SPI master in slave out
  wire       mosi;        // SPI master out slave in
  wire [3:0] leds;        // LEDs for debugging

  reg        begintest;   // Set high to begin testing
  wire       endtest;     // Set high to signal test completion
  wire       dutpassed;   // Indicates whether SPI memory passed tests

  // Instantiate SPI memory (device under test)
  spiMemory DUT
  (
    .clk(clk),
    .sclk_pin(sclk),
    .cs_pin(cs),
    .miso_pin(miso),
    .mosi_pin(mosi),
    .leds(leds)
  );

  // Instantiate SPI memory test bench
  spimemorytestbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .clk(clk),
    .sclk(sclk),
    .cs(cs),
    .miso(miso),
    .mosi(mosi),
    .leds(leds)
  );

  // Assert 'begintest'
  initial begin
    $dumpfile("spimemory.vcd");
    $dumpvars(0, DUT);
    begintest = 0; #10
    begintest = 1;
  end

  // Display test results
  always @ (posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
    $finish();
  end

endmodule

module spimemorytestbench
(
// Test bench driver connections
input            begintest,
output reg       endtest,
output reg       dutpassed,

// SPI memory DUT connections
output reg       clk,
output reg       sclk,
output reg       cs,
input            miso,
output reg       mosi,
output reg [3:0] leds
);

  // Add some helper vars
  reg [7:0] data_from_read;

  // Initialize SPI memory driver signals
  initial begin
    clk            = 0;
    sclk           = 0;
    cs             = 1;
    mosi           = 0;
    leds           = 4'b0;
    data_from_read = 0;
  end

  always #10 clk = !clk;

  // When 'begintest' is asserted, run test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1; #10

    sclk = 0; #100
    sclk = 1; #100

    // Some test cases
    write(7'b0000001, 8'b10101010); #100

    read(7'b0000001, data_from_read); #1000
    $display("%b",data_from_read);

    // At the end now
    #5
    endtest = 1;
  end

  // Because I wanted functions but apparently those don't have time delays
  // Thanks, http://www.asic-world.com/verilog/task_func1.html
  task read;
    input [6:0] address;
    output [7:0] data;
    integer i;
    begin
      cs = 0; #1000
      // Serial input address
      for (i=0; i<7; i=i+1) begin
        sclk = 0; // Data presented on falling edge
        mosi = address[6-i]; #100
        sclk = 1; #100;
      end
      // Read bit
      sclk = 0;
      mosi = 1; #100
      sclk = 1; #100
      // Read back data
      for (i=0; i<8; i=i+1) begin
        sclk = 0; #100
        sclk = 1; // Data captured on rising edge
        data[7-i] = miso; #100;
      end
      #10000;
      cs = 1;
    end
  endtask

  task write;
    input [6:0] address;
    input [7:0] write_data;
    integer i;
    begin
      cs = 0; #1000
      // Serial input address
      for (i=0; i<7; i=i+1) begin
        sclk = 0; // Data presented on falling edge
        mosi = address[6-i]; #10000
        sclk = 1; #10000;
      end
      // Write bit
      sclk = 0;
      mosi = 0; #10000
      sclk = 1; #10000
      // Serial input write data
      for (i=0; i<8; i=i+1) begin
        sclk = 0; // Data presented on falling edge
        mosi = write_data[7-i]; #10000
        sclk = 1; #10000;
      end
      #10000
      cs = 1;
    end
  endtask
endmodule

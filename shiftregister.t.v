`include "shiftregister.v"
//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

  // Instantiate test vars
  reg             clk;
  reg             peripheralClkEdge;
  reg             parallelLoad;
  wire[7:0]       parallelDataOut;
  wire            serialDataOut;
  reg[7:0]        parallelDataIn;
  reg             serialDataIn;

  // Instantiate helper vars
  reg dutpassed = 1;
  reg [3:0] i;
  reg [7:0] inputVal = 8'b10010101;

  // Instantiate DUT with parameter width = 8
  shiftregister #(8) dut(.clk(clk),
  		           .peripheralClkEdge(peripheralClkEdge),
  		           .parallelLoad(parallelLoad),
  		           .parallelDataIn(parallelDataIn),
  		           .serialDataIn(serialDataIn),
  		           .parallelDataOut(parallelDataOut),
  		           .serialDataOut(serialDataOut));

  // Generate clock
  initial clk=0;
  always #10 clk=!clk;

  initial begin
    $display("Begin testing register.v");

    // Test parallel load
    parallelLoad = 1; parallelDataIn = inputVal; serialDataIn = 1; #20
    if (parallelDataOut !== parallelDataIn) begin
      $display("Test parallel load failed");
      $display("Expected: %b", parallelDataIn);
      $display("Actual:   %b", parallelDataOut);
      dutpassed = 0;
    end

    // Shift in 1s to see if that works
    serialDataIn = 1; parallelDataIn = 0; parallelLoad = 0; #20
    for (i=0; i<8; i=i+1) begin
      peripheralClkEdge = 1; #20      // Asserted for 1 cycle
      peripheralClkEdge = 0; #90     // Deasserted for a while I guess
      // The terrible thing here is invert, shift left by index, then invert back
      // So shift left with 1s by shifting the inverted version left with 0s
      // and inverting back
      if (parallelDataOut !== (~((~inputVal) << (i+1)))) begin
        $display("Test shift left 1s failed");
        $display("Expected: %b", ~((~inputVal) << (i+1)));
        $display("Actual:   %b", parallelDataOut);
        dutpassed = 0;
      end
    end

    // Starting with 0s, shift in the input val (10010101)
    parallelLoad = 1; parallelDataIn = 0; #20
    parallelLoad = 0;
    for (i=0; i<8; i=i+1) begin
      serialDataIn = inputVal[7-i]; #10
      peripheralClkEdge = 1; #20      // Asserted for 1 cycle
      peripheralClkEdge = 0; #90     // Deasserted for a while I guess
      if (parallelDataOut !== (inputVal >> (7-i))) begin
        $display("Test serial in failed");
        $display("Expected: %b", (inputVal >> (7-i)));
        $display("Actual:   %b", parallelDataOut);
        dutpassed = 0;
      end
    end

    // Missing test: does parallelLoad or serial shift win if they both happen
    // in the same clock edge?
    $display("To be implemented: test priority of parallelLoad and serial shift");

    // Show if tests passed
    if (dutpassed) begin
      $display("Tests passed");
    end else begin
      $display("Tests completed");
    end

  end

endmodule

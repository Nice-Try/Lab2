//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    // Set parallel and serial out
    assign parallelDataOut = shiftregistermem;
    assign serialDataOut = shiftregistermem[width-1];

    always @(posedge clk) begin
        // When parallelLoad is asserted, load parallelDataIn
        if (parallelLoad) begin
            shiftregistermem <= parallelDataIn;
        end

        // At peripheral clock edge, shift
        // Not sure if this actually works? unclear to me how always blocks work
        else if (peripheralClkEdge) begin
            shiftregistermem = {shiftregistermem[width-2:0], serialDataIn};
        end
    end

endmodule

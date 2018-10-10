`include "inputconditioner.v"
`include "shiftregister.v"
//------------------------------------------------------------------------
// Midpoint Checkin
//   Conditions inputs and then sends them to a shift register
//------------------------------------------------------------------------

module midpoint
#(parameter width = 8)
(
input              clk,
input              parallelLoad,
input [width-1:0]  parallelDataIn,
input              serialDataIn,
input              peripheralClkEdge,
output [width-1:0] parallelDataOut,
output             serialDataOut
);
  // Instantiate input conditioners
  inputconditioner parallelLoadConditioner(clk, parallelLoad, cleanParallelLoad, posedgeParallelLoad, negedgeParallelLoad);
  inputconditioner serialDataInConditioner(clk, serialDataIn, cleanSerialDataIn, posedgeSerialDataIn, negedgeSerialDataIn);
  inputconditioner peripheralClkEdgeConditioner(clk, peripheralClkEdge, cleanPeripheralClkEdge, posedgePeripheralClkEdge, negedgePeripheralClkEdge);

  // Instantiate shift register
  shiftregister #(8) register(.clk(clk),
                              .peripheralClkEdge(posedgePeripheralClkEdge),
                              .parallelLoad(negedgeParallelLoad),
                              .parallelDataIn(parallelDataIn),
                              .serialDataIn(cleanSerialDataIn),
                              .parallelDataOut(parallelDataOut),
                              .serialDataOut(serialDataOut));

endmodule

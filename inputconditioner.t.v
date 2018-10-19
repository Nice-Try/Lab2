`include "inputconditioner.v"
//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;

    reg [3:0] i;

    inputconditioner dut(.clk(clk),
                 .noisysignal(pin),
             .conditioned(conditioned),
             .positiveedge(rising),
             .negativeedge(falling));


    // Generate clock (50MHz)
    initial pin=0;
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    $dumpfile("inputconditioner.vcd");
    $dumpvars();

    $display("Begin testing inputconditioner.v");

    // Bounce for a little bit before settling on 1
    $display("pin  | conditioned | rising | falling");
    for(i=0; i<7; i=i+1) begin
        pin=!pin; #10
        $display(" %b   | %b           | %b      | %b", pin, conditioned, rising, falling);
    end

    pin=1; #1000
    $display(" %b   | %b           | %b      | %b", pin, conditioned, rising, falling);


    // Bounce for a little bit before settling on 0
    $display("\n");
    $display("pin  | conditioned | rising | falling");
    for(i=0; i<7; i=i+1) begin
        pin=!pin; #10
        $display(" %b   | %b           | %b      | %b", pin, conditioned, rising, falling);
    end


    pin=0; #1000
    $display(" %b   | %b           | %b      | %b", pin, conditioned, rising, falling);

    $finish();
  end
endmodule

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
    
    reg dutpassed = 1;

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
    $display("Begin testing inputconditioner.v");

    genvar i;
    generate
    for(i=0; i<7; i=i+1)
        begin:genblock
            pin=!pin; #3
            $display("pin  | conditioned | rising | falling");
            $display(" %b  | %b          | %b     |  %b", pin, conditioned, rising, falling);
        end
    endgenerate

    pin=!pin #100
    $display("pin  | conditioned | rising | falling");
    $display(" %b  | %b          | %b     |  %b", pin, conditioned, rising, falling);


    genvar i;
    generate
    for(i=0; i<7; i=i+1)
        begin:genblock
            pin=!pin; #3
            $display("pin  | conditioned | rising | falling");
            $display(" %b  | %b          | %b     |  %b", pin, conditioned, rising, falling);
        end
    endgenerate

    pin=!pin; #100
    $display("pin  | conditioned | rising | falling");
    $display(" %b  | %b          | %b     |  %b", pin, conditioned, rising, falling);

    if (dutpassed) begin
      $display("Tests passed");
    end else begin
      $display("Tests completed");
    end

  end
endmodule

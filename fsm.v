// Finite State Machine for SPI

module FSM(
  input clk,
  input CS, // chip select
  input shiftRegOutP0, // R/W bit
  output reg miso_buff, // master in slave out buffer
  output reg dm_we, // data memory
  output reg addr_we, // address
  output reg sr_we // shift register
  );

  // State Encoding (binary)
  reg[2:0] state;
  localparam ADDR = 3'b000;
  localparam RW = 3'b001;
  localparam READ_LOAD = 3'b010;
  localparam WRITE = 3'b011;
  localparam READ = 3'b100;
  localparam WRITE_DM = 3'b101;
  localparam FINAL = 3'b110;
  reg counter = 0;

  always @(posedge clk) begin
    counter = counter + 1;
    if (CS == 0) begin
      state <= FINAL;
      counter = 0;
    end
    else begin
      case(state)
        FINAL: begin
          if (CS == 1) begin
            state <= ADDR;
          end
          else begin
            miso_buff = 0;
            dm_we = 0;
            addr_we = 0;
            sr_we = 0;
          end
        end
        ADDR: begin
          miso_buff = 0;
          dm_we = 0;
          addr_we = 1;
          sr_we = 0;
          if (counter == 7)
            state <= RW;
        end
        RW: begin
          miso_buff = 0;
          dm_we = 0;
          addr_we = 1;
          sr_we = 0;
          if (shiftRegOutP0 == 1)
            state <= READ_LOAD;
          else
            state <= WRITE;
        end
        READ_LOAD: begin
          miso_buff = 1;
          dm_we = 0;
          addr_we = 0;
          sr_we = 1;
          state <= READ;
        end
        WRITE: begin
          miso_buff = 0;
          dm_we = 0;
          addr_we = 0;
          sr_we = 0;
          if (counter == 14)
            state <= WRITE_DM;
        end
        READ: begin
          miso_buff = 1;
          dm_we = 0;
          addr_we = 0;
          sr_we = 0;
        end
        WRITE_DM: begin
          miso_buff = 0;
          dm_we = 1;
          addr_we = 0;
          sr_we = 0;
        end
      endcase
      end
    end
endmodule

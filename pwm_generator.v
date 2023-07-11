`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2023 21:54:30
// Design Name: 
// Module Name: pwm_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm_generator (
  input wire clk,
  input wire reset,
  input wire enable,
  input wire [7:0] duty_cycle,
  input wire duty_inc,
  input wire duty_dec,
  input wire [15:0] frequency,
  output wire pwm_out
);

  reg [7:0] duty_cycle_reg;
  reg [15:0] counter;
  reg pwm_out_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 16'b0000000000000000;
      duty_cycle_reg <= 8'b00000000;
      pwm_out_reg <= 1'b0;
    end else if (enable) begin
      if (duty_inc) begin
        if (duty_cycle_reg < 8'b11111111) begin
          duty_cycle_reg <= duty_cycle_reg + 1;
        end
      end else if (duty_dec) begin
        if (duty_cycle_reg > 8'b00000000) begin
          duty_cycle_reg <= duty_cycle_reg - 1;
        end
      end
      
      if (counter < (frequency >> 1)) begin
        pwm_out_reg <= (counter < ((duty_cycle_reg * frequency) >> 8));
      end else begin
        pwm_out_reg <= 1'b0;
      end
      
      if (counter == frequency - 1) begin
        counter <= 16'b0000000000000000;
      end else begin
        counter <= counter + 1;
      end
    end
  end

  assign pwm_out = pwm_out_reg;

endmodule


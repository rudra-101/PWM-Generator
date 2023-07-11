`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2023 21:55:08
// Design Name: 
// Module Name: pwm_generator_tb
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


module pwm_generator_tb;

  reg clk;
  reg reset;
  reg enable;
  reg [7:0] duty_cycle;
  reg duty_inc;
  reg duty_dec;
  reg [15:0] frequency;
  wire pwm_out;

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    reset = 0;
    enable = 1;
    duty_cycle = 8'b01010101;  // Initial duty cycle value
    duty_inc = 0;
    duty_dec = 0;
    frequency = 16'b000110100100;  // Initial frequency value

    // Apply reset
    reset = 1;
    #10 reset = 0;

    // Display initial state
    $display("Time = %0t | Duty Cycle = %b | Frequency = %d | PWM Output = %b", $time, duty_cycle, frequency, pwm_out);

    // Wait for a few cycles
    #30;

    // Increase duty cycle
    duty_inc = 1;
    #20;
    duty_inc = 0;
    #20;
    
    // Decrease duty cycle
    duty_dec = 1;
    #20;
    duty_dec = 0;
    #20;

    // Change frequency
    frequency = 16'b111111111111;
    #20;

    // Finish simulation
    #20 $finish;
  end

  // Instantiate PWM generator module
  pwm_generator pwm_gen (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .duty_cycle(duty_cycle),
    .duty_inc(duty_inc),
    .duty_dec(duty_dec),
    .frequency(frequency),
    .pwm_out(pwm_out)
  );

endmodule






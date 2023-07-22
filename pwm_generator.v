`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2023 11:37:36
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
    input clk, // 100MHz clock input
    input increase_duty, // input to increase 1/16 duty cycle
    input decrease_duty, // input to decrease 1/16 duty cycle
    output PWM_OUT, // 10MHz PWM output signal
    output reg [3:0] DUTY_CYCLE_OUT, // Output to show the duty cycle (0-15)
    output reg INC_DUTY, // Output to show the increment signal
    output reg DEC_DUTY // Output to show the decrement signal
);

    reg slow_clk_enable; // 1-cycle pulse for debouncing buttons
    reg [27:0] counter_debounce = 0;
    reg tmp1, tmp2;
    reg [3:0] counter_PWM = 0;
    reg [3:0] DUTY_CYCLE = 5;

    always @(posedge clk)
    begin
        counter_debounce <= counter_debounce + 1;
        if (counter_debounce >= 1)
            counter_debounce <= 0;
    end

    always @(posedge clk)
    begin
        if (counter_debounce == 1)
            slow_clk_enable <= 1;
        else
            slow_clk_enable <= 0;
    end

    always @(posedge clk)
    begin
        if (slow_clk_enable) begin
            // Debounce the increase_duty and decrease_duty inputs
            tmp1 <= increase_duty;
            tmp2 <= decrease_duty;
        end
    end

   always @(posedge clk)
begin
    if (tmp1 && ~increase_duty && DUTY_CYCLE <= 15) begin
        DUTY_CYCLE <= DUTY_CYCLE + 1; // Increment duty cycle by 1/16
        INC_DUTY <= 1; // Set INC_DUTY to 1 for a 1-cycle pulse
        DEC_DUTY <= 0; // Clear DEC_DUTY
    end else if (tmp2 && ~decrease_duty && DUTY_CYCLE >= 1) begin
        DUTY_CYCLE <= DUTY_CYCLE - 1; // Decrement duty cycle by 1/16
        INC_DUTY <= 0; // Clear INC_DUTY
        DEC_DUTY <= 1; // Set DEC_DUTY to 1 for a 1-cycle pulse
    end else begin
        INC_DUTY <= 0;
        DEC_DUTY <= 0;
    end
end


    always @(posedge clk)
    begin
        counter_PWM <= counter_PWM + 1;
        if (counter_PWM >= 15)
            counter_PWM <= 0;
    end

    assign PWM_OUT = counter_PWM < DUTY_CYCLE ? 1 : 0;
    always @(posedge clk)
        DUTY_CYCLE_OUT <= DUTY_CYCLE;

endmodule



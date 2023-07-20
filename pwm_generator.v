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

module pwm_generator
(
    input clk, // 100MHz clock input
    input increase_duty, // input to increase 1/256 duty cycle (10%)
    input decrease_duty, // input to decrease 1/256 duty cycle (10%)
    output PWM_OUT, // 10MHz PWM output signal
    output reg [3:0] DUTY_CYCLE_OUT, // Output to show the duty cycle (0-9)
    output reg INC_DUTY, // Output to show the increment signal
    output reg DEC_DUTY // Output to show the decrement signal
);

    reg slow_clk_enable; // 1-cycle pulse for debouncing buttons
    reg [27:0] counter_debounce = 0;
    wire tmp1, tmp2, duty_inc;
    wire tmp3, tmp4, duty_dec;
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

    // debouncing FFs for increasing button
    DFF_PWM PWM_DFF1(clk, slow_clk_enable, increase_duty, tmp1);
    DFF_PWM PWM_DFF2(clk, slow_clk_enable, tmp1, tmp2);
    assign duty_inc = tmp1 & (~tmp2) & slow_clk_enable;

    // debouncing FFs for decreasing button
    DFF_PWM PWM_DFF3(clk, slow_clk_enable, decrease_duty, tmp3);
    DFF_PWM PWM_DFF4(clk, slow_clk_enable, tmp3, tmp4);
    assign duty_dec = tmp3 & (~tmp4) & slow_clk_enable;

    always @(posedge clk)
    begin
        if (duty_inc == 1 && DUTY_CYCLE <= 6)
        begin
            DUTY_CYCLE <= DUTY_CYCLE + 1; // Increment duty cycle by 1/256 (10%)
            INC_DUTY <= 1; // Set INC_DUTY to 1 for a 1-cycle pulse
            DEC_DUTY <= 0; // Clear DEC_DUTY
        end
        else if (duty_dec == 1 && DUTY_CYCLE >= 1)
        begin
            DUTY_CYCLE <= DUTY_CYCLE - 1; // Decrement duty cycle by 1/256 (10%)
            INC_DUTY <= 0; // Clear INC_DUTY
            DEC_DUTY <= 1; // Set DEC_DUTY to 1 for a 1-cycle pulse
        end
        else
        begin
            INC_DUTY <= 0;
            DEC_DUTY <= 0;
        end
    end

    always @(posedge clk)
    begin
        counter_PWM <= counter_PWM + 1;
        if (counter_PWM >= 9)
            counter_PWM <= 0;
    end

    assign PWM_OUT = counter_PWM < DUTY_CYCLE ? 1 : 0;
    always @(posedge clk)
        DUTY_CYCLE_OUT <= DUTY_CYCLE;

endmodule

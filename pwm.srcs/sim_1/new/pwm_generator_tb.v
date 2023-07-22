`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2023 11:38:31
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

    // Inputs
    reg clk;
    reg increase_duty;
    reg decrease_duty;

    // Outputs
    wire PWM_OUT;
    wire [3:0] DUTY_CYCLE_OUT;
    wire INC_DUTY;
    wire DEC_DUTY;

    // Instantiate the PWM Generator with variable duty cycle in Verilog
    pwm_generator DUT (
        .clk(clk),
        .increase_duty(increase_duty),
        .decrease_duty(decrease_duty),
        .PWM_OUT(PWM_OUT),
        .DUTY_CYCLE_OUT(DUTY_CYCLE_OUT),
        .INC_DUTY(INC_DUTY),
        .DEC_DUTY(DEC_DUTY)
    );

    // Create 100Mhz clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initial values for inputs
        increase_duty = 0;
        decrease_duty = 0;

        // Allow some time for the circuit to initialize
        #500;

        // Test all combinations of inputs
        // 1. Increment duty cycle once
        #100;
        increase_duty = 1;
        #100;
        increase_duty = 0;

        // 2. Decrement duty cycle once
        #100;
        decrease_duty = 1;
        #100;
        decrease_duty = 0;

        // 3. Increment duty cycle multiple times
        repeat (5) begin
            #100;
            increase_duty = 1;
            #100;
            increase_duty = 0;
        end

        // 4. Decrement duty cycle multiple times
        repeat (5) begin
            #100;
            decrease_duty = 1;
            #100;
            decrease_duty = 0;
        end

        // 5. Increment and decrement duty cycle multiple times
        repeat (5) begin
            #100;
            increase_duty = 1;
            #100;
            increase_duty = 0;
            #100;
            decrease_duty = 1;
            #100;
            decrease_duty = 0;
        end

        // 6. Increment and decrement duty cycle together (cancel each other)
        repeat (5) begin
            #100;
            increase_duty = 1;
            decrease_duty = 1;
            #100;
            increase_duty = 0;
            decrease_duty = 0;
        end

        // 7. No change in duty cycle
        #500;

        // 8. Random combination of inputs
        #100;
        increase_duty = 1;
        #100;
        decrease_duty = 1;
        #100;
        increase_duty = 0;
        decrease_duty = 0;

        // 9. Additional duty cycle decrements
        #100;
        decrease_duty = 1;
        #100;
        decrease_duty = 0;
        #100;
        decrease_duty = 1;
        #100;
        decrease_duty = 0;
        #100;
        decrease_duty = 1;
        #100;
        decrease_duty = 0;

        // End of simulation
        #100;
        $finish;
    end

endmodule


`timescale 1ns/1ps

module tb_pid_controller;

    reg clk;
    reg reset;

    reg signed [15:0] ref_in;
    reg signed [15:0] feedback_in;

    wire signed [15:0] control_out;

    pid_controller uut (
        .clk(clk),
        .reset(reset),
        .ref_in(ref_in),
        .feedback_in(feedback_in),
        .control_out(control_out)
    );
    always #5 clk=~clk;
    initial begin
    clk= 1'b0;
    reset= 1'b1;
    
        ref_in = 16'sd0;
        feedback_in = 16'sd0;

        #20;

        reset = 1'b0;

        ref_in = 16'sd4096;

        #100;

        feedback_in = 16'sd1024;

        #100;

        feedback_in = 16'sd2048;

        #100;

        feedback_in = 16'sd3072;

        #100;

        feedback_in = 16'sd4096;

        #100;

        $finish;
    end
    
endmodule

`timescale 1ns/1ns

module tb_GF_MUL();
    reg clk, en;
    reg [7:0] num1, num2;
    wire [7:0] result;
    wire done;

    top_GF_Mul Mul(
    .clk(clk), 
    .en(en),
    .i_state_1(num1),
    .i_state_2(num2),
    .o_state(result),
    .o_done(done)
    );

    initial begin
        clk <= 1'b1;
        en <= 1'b0;
        num1 <= 8'b00000000;
        num2 <= 8'b00000000;
    end

    always #10 clk <= ~clk;

    initial begin
        #20 en <= 1'b1; num1 <= 8'b00100110; num2 <= 8'b10011110;
    end
endmodule
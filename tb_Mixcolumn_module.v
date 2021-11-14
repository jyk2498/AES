`timescale 1ns/1ns

module tb_Mixcolumn();
    reg clk, start;
    reg [31 : 0] statew1, statew2, statew3, statew4;
    
    wire done;
    wire new_statew1, new_statew2, new_statew3, new_statew4;

    Mixcolumn_module Mixcolumn(
    .clk(clk),
    .start(start),
    .done(done),

    .statew1(statew1),
    .statew2(statew2),
    .statew3(statew3),
    .statew4(statew4),

    .new_statew1(new_statew1),
    .new_statew2(new_statew2),
    .new_statew3(new_statew3),
    .new_statew4(new_statew4)
    );

    initial begin
        clk <= 1'b1;
        start <= 1'b0;
        statew1 <= 8'b00000000;
        statew2 <= 8'b00000000;
        statew3 <= 8'b00000000;
        statew4 <= 8'b00000000;
    end

    always #10 clk <= ~clk;

    initial begin
        #20 statew1 <= 32'h00000001; statew2 <= 32'h00000001; statew3 <= 32'h00000001; statew4 <= 8'b00000001;
        #20 start <= 1'b1;
        #15000 start <= 1'b0;
    end
endmodule
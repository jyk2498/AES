module Mixcolumn_module(
    input wire [31 : 0] statew1,
    input wire [31 : 0] statew2,
    input wire [31 : 0] statew3,
    input wire [31 : 0] statew4,

    output wire [31 : 0] new_statew1,
    output wire [31 : 0] new_statew2,
    output wire [31 : 0] new_statew3,
    output wire [31 : 0] new_statew4
);
    wire [7 : 0] mixcolumn_constant [0 : 15];

    // Creating mixcolumn_constant matrix
    assign mixcolumn_constant[0] = 2;
    assign mixcolumn_constant[1] = 1;
    assign mixcolumn_constant[2] = 1;
    assign mixcolumn_constant[3] = 3; // 1st column

    assign mixcolumn_constant[4] = 3;
    assign mixcolumn_constant[5] = 2;
    assign mixcolumn_constant[6] = 1;
    assign mixcolumn_constant[7] = 1; // 2nd column

    assign mixcolumn_constant[8] = 1;
    assign mixcolumn_constant[9] = 3;
    assign mixcolumn_constant[10] = 2;
    assign mixcolumn_constant[11] = 1; // 3rd column

    assign mixcolumn_constant[12] = 1;
    assign mixcolumn_constant[13] = 1;
    assign mixcolumn_constant[14] = 3;
    assign mixcolumn_constant[15] = 2; // 4th column
endmodule
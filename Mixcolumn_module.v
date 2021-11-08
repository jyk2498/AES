// aes mixcolumn module
// 
// inputs
//  statew1 : first word of state matrix
//  statew2 : second word of state matrix
//  statew3 : third word of state matrix
//  statew4 : 4th word of state matrix
// outputs
//  shifted_statew1 : first word of translated first column
//  shifted_statew2 : second word of translated second column
//  shifted_statew3 : third word of translated third word
//  shifted_statew4 : 4th word of translated 4th word
// take state matrix by using 4 ports. each port take each column of state matrix
// and convert it into new matrix(mixcolumn) and output using 4 ports. again each port deliver each column

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
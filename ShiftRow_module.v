// aes shiftrow module
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
// and convert it into new matrix(shiftrow) and output using 4 ports. again each port deliver each column

module aes_shiftrow(
    input wire [31 : 0] statew1,
    input wire [31 : 0] statew2,
    input wire [31 : 0] statew3,
    input wire [31 : 0] statew4,

    output wire [31 : 0] shifted_statew1,
    output wire [31 : 0] shifted_statew2,
    output wire [31 : 0] shifted_statew3,
    output wire [31 : 0] shifted_statew4
);

    assign shifted_statew1 = {statew1[31 : 24], statew2[23 : 16], statew3[15 : 8], statew4[7 : 0]};
    assign shifted_statew2 = {statew2[31 : 24], statew3[23 : 16], statew4[15 : 8], statew1[7 : 0]};
    assign shifted_statew3 = {statew3[31 : 24], statew4[23 : 16], statew1[15 : 8], statew2[7 : 0]};
    assign shifted_statew4 = {statew4[31 : 24], statew1[23 : 16], statew2[15 : 8], statew3[7 : 0]};
    
endmodule
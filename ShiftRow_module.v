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
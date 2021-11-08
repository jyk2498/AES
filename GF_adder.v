// aes GF_Adder module
// 
// inputs
//  poly1 : polynomial 1 to be used in the operation
//  poly2 : polynomial 2 to be used in the operation
// outputs
//  GFadd_result : result of calculation
// take 2 polynomial and calculate GF(2^8) add and output the result
module GF_adder(
    input wire [7 : 0] poly1,
    input wire [7 : 0] poly2,

    output wire [7 : 0] GFadd_result
);

    assign gfadd_result = poly1 ^ poly2;

endmodule
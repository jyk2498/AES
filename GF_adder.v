module GF_adder(
    input wire [7 : 0] poly1,
    input wire [7 : 0] poly2,

    output wire [7 : 0] GFadd_result
);

    assign gfadd_result = poly1 ^ poly2;

endmodule
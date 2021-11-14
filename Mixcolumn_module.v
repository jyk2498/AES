// aes mixcolumn module
// 
// inputs
//  statew1 : first word of state matrix
//  statew2 : second word of state matrix
//  statew3 : third word of state matrix
//  statew4 : 4th word of state matrix
//
//  clk : clock and enable signal for GF_MUL module
//  start : start signal to start mixcolumn calculations.
// outputs
//  shifted_statew1 : first word of translated first column
//  shifted_statew2 : second word of translated second column
//  shifted_statew3 : third word of translated third word
//  shifted_statew4 : 4th word of translated 4th word
//
//  done : after new matrix created, done become 1
//
// take state matrix by using 4 ports. each port take each column of state matrix
// and convert it into new matrix(mixcolumn) and output using 4 ports. again each port deliver each column
// before giving start signal, statew1,2,3,4 must be ready

module Mixcolumn_module(
    input wire clk,
    input wire start,
    output wire done,

    input wire [31 : 0] statew1,
    input wire [31 : 0] statew2,
    input wire [31 : 0] statew3,
    input wire [31 : 0] statew4,

    output reg [31 : 0] new_statew1,
    output reg [31 : 0] new_statew2,
    output reg [31 : 0] new_statew3,
    output reg [31 : 0] new_statew4
);
    wire [7 : 0] mixcolumn_constant [0 : 15]; // mixcolumn constant matrix 

    reg en1, en2, en3, en4;
    reg [7 : 0] num1_e1, num2_e1, num1_e2, num2_e2, num1_e3, num2_e3, num1_e4, num2_e4;
    wire [7 : 0] result_e1, result_e2, result_e3, result_e4; 
    wire mul_temp_done_1, mul_temp_done_2, mul_temp_done_3, mul_temp_done_4; // wire for Multiplier IO

    wire [7 : 0] add_result1, add_result2, add_result3; // wire for adder IO

    reg [3 : 0] count;
    wire four_mul_finish;

    // Creating mixcolumn_constant matrix
    assign mixcolumn_constant[0] = 8'b00000010; // 2
    assign mixcolumn_constant[1] = 8'b00000001; // 1
    assign mixcolumn_constant[2] = 8'b00000001; // 1
    assign mixcolumn_constant[3] = 8'b00000011; // 3
    // 1st column

    assign mixcolumn_constant[4] = 8'b00000011; // 3
    assign mixcolumn_constant[5] = 8'b00000010; // 2
    assign mixcolumn_constant[6] = 8'b00000001; // 1
    assign mixcolumn_constant[7] = 8'b00000001; // 1 
    // 2nd column

    assign mixcolumn_constant[8] = 8'b00000001; // 1
    assign mixcolumn_constant[9] = 8'b00000011; // 3
    assign mixcolumn_constant[10] = 8'b00000010; // 2
    assign mixcolumn_constant[11] = 8'b00000001; // 1
    // 3rd column

    assign mixcolumn_constant[12] = 8'b00000001; // 1
    assign mixcolumn_constant[13] = 8'b00000001; // 1
    assign mixcolumn_constant[14] = 8'b00000011; // 3
    assign mixcolumn_constant[15] = 8'b00000010; // 2
    // 4th column

// ======================= module instantiation =======================
    top_GF_Mul Mul1(
    .clk(clk), 
    .en(en1),
    .i_state_1(num1_e1),
    .i_state_2(num2_e2),
    .o_state(result_e1),
    .o_done(mul_temp_done_1)
    ); // GF_multiplier for first element of each column/row

    top_GF_Mul Mul2(
    .clk(clk), 
    .en(en2),
    .i_state_1(num1_e2),
    .i_state_2(num2_e2),
    .o_state(result_e2),
    .o_done(mul_temp_done_2)
    ); // GF_multiplier for second element of each column/row

    top_GF_Mul Mul3(
    .clk(clk), 
    .en(en3),
    .i_state_1(num1_e3),
    .i_state_2(num2_e3),
    .o_state(result_e3),
    .o_done(mul_temp_done_3)
    ); // GF_multiplier for third element of each column/row

    top_GF_Mul Mul4(
    .clk(clk), 
    .en(en4),
    .i_state_1(num1_e4),
    .i_state_2(num2_e4),
    .o_state(result_e4),
    .o_done(mul_temp_done_4)
    ); // GF_multiplier for last element of each column/row

    GF_adder adder1(
    .poly1(result_e1),
    .poly2(result_e2),

    .GFadd_result(add_result1)
    ); // GF_adder used in matrix multiplication

    GF_adder adder2(
    .poly1(result_e3),
    .poly2(result_e4),

    .GFadd_result(add_result2)
    ); // GF_adder used in matrix multiplication

    GF_adder adder3(
    .poly1(add_result1),
    .poly2(add_result2),

    .GFadd_result(add_result3)
    ); // GF_adder used in matrix multiplication
// ========================================================================

    // give enable signal to 4 GF_multiplier when start signal is 1
    always@(posedge clk) begin
        if(!start) begin
            {en1, en2, en3, en4} <= 4'b0000;
        end else begin
            {en1, en2, en3, en4} <= 4'b1111;
        end
    end

    // DO GF_multiplying
    // give result of multiplying to GF_add(combinational circuit) 
    always@(posedge clk) begin
        if(start == 1'b1) begin
            if(count == 4'b0000) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[0], mixcolumn_constant[4], mixcolumn_constant[8], mixcolumn_constant[12]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew1[31 : 24], statew1[23 : 16], statew1[15 : 8], statew1[7 : 0]}; // making A11
            end else if(count == 4'b0001) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[0], mixcolumn_constant[4], mixcolumn_constant[8], mixcolumn_constant[12]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew2[31 : 24], statew2[23 : 16], statew2[15 : 8], statew2[7 : 0]}; // making A12
            end else if (count == 4'b0010) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[0], mixcolumn_constant[4], mixcolumn_constant[8], mixcolumn_constant[12]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew3[31 : 24], statew3[23 : 16], statew3[15 : 8], statew3[7 : 0]}; // making A13
            end else if (count == 4'b0011) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[0], mixcolumn_constant[4], mixcolumn_constant[8], mixcolumn_constant[12]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew4[31 : 24], statew4[23 : 16], statew4[15 : 8], statew4[7 : 0]}; // mkaing A14
            end else if(count == 4'b0100) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[1], mixcolumn_constant[5], mixcolumn_constant[9], mixcolumn_constant[13]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew1[31 : 24], statew1[23 : 16], statew1[15 : 8], statew1[7 : 0]}; // making A21
            end else if(count == 4'b0101) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[1], mixcolumn_constant[5], mixcolumn_constant[9], mixcolumn_constant[13]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew2[31 : 24], statew2[23 : 16], statew2[15 : 8], statew2[7 : 0]}; // making A22
            end else if (count == 4'b0110) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[1], mixcolumn_constant[5], mixcolumn_constant[9], mixcolumn_constant[13]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew3[31 : 24], statew3[23 : 16], statew3[15 : 8], statew3[7 : 0]}; // making A23
            end else if (count == 4'b0111) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[1], mixcolumn_constant[5], mixcolumn_constant[9], mixcolumn_constant[13]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew4[31 : 24], statew4[23 : 16], statew4[15 : 8], statew4[7 : 0]}; // making A24
            end else if(count == 4'b1000) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[2], mixcolumn_constant[6], mixcolumn_constant[10], mixcolumn_constant[14]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew1[31 : 24], statew1[23 : 16], statew1[15 : 8], statew1[7 : 0]}; // making A31
            end else if(count == 4'b1001) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[2], mixcolumn_constant[6], mixcolumn_constant[10], mixcolumn_constant[14]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew2[31 : 24], statew2[23 : 16], statew2[15 : 8], statew2[7 : 0]}; // making A32
            end else if (count == 4'b1010) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[2], mixcolumn_constant[6], mixcolumn_constant[10], mixcolumn_constant[14]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew3[31 : 24], statew3[23 : 16], statew3[15 : 8], statew3[7 : 0]}; // making A33
            end else if (count == 4'b1011) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[2], mixcolumn_constant[6], mixcolumn_constant[10], mixcolumn_constant[14]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew4[31 : 24], statew4[23 : 16], statew4[15 : 8], statew4[7 : 0]}; // making A34
            end else if(count == 4'b1100) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[3], mixcolumn_constant[7], mixcolumn_constant[11], mixcolumn_constant[15]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew1[31 : 24], statew1[23 : 16], statew1[15 : 8], statew1[7 : 0]}; // making A41
            end else if(count == 4'b1101) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[3], mixcolumn_constant[7], mixcolumn_constant[11], mixcolumn_constant[15]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew2[31 : 24], statew2[23 : 16], statew2[15 : 8], statew2[7 : 0]}; // making A42
            end else if (count == 4'b1110) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[3], mixcolumn_constant[7], mixcolumn_constant[11], mixcolumn_constant[15]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew3[31 : 24], statew3[23 : 16], statew3[15 : 8], statew3[7 : 0]}; // making A43
            end else if (count == 4'b1111) begin
                {num1_e1, num1_e2, num1_e3, num1_e4} <= {mixcolumn_constant[3], mixcolumn_constant[7], mixcolumn_constant[11], mixcolumn_constant[15]};
                {num2_e1, num2_e2, num2_e3, num2_e4} <= {statew4[31 : 24], statew4[23 : 16], statew4[15 : 8], statew4[7 : 0]}; // making A44
            end
        end
    end // 테스트벤치로 en(reset) 신호 켰다가 끄지 않고 1 로 유지한 채로 done 신호 나올 때마다 피연산자 바꾸면 제대로된 곱셈 결과 나오는지 check 요망됨

    assign four_mul_finish = (mul_temp_done_1 && mul_temp_done_2 && mul_temp_done_3 && mul_temp_done_4);
 
    // making count signal 0 1 2 3 ... 15 0 1 2...
    always@(posedge clk) begin
        if(!start) begin
            count <= 4'b0000;
        end else begin
            if(count == 4'b1111) begin
               if(four_mul_finish) begin
                   count <= 4'b0000;
               end  
            end else begin
                if(four_mul_finish) begin
                    count <= count + 1;
                end
            end
        end
    end

    // store result of calculation to the output reg new_statew
    always@(posedge clk) begin
        if(start) begin
            if(count == 4'b0000 && four_mul_finish) begin
                new_statew1[31 : 24] <= add_result3;
            end else if(count == 4'b0001 && four_mul_finish) begin
                new_statew2[31 : 24] <= add_result3;
            end else if (count == 4'b0010 && four_mul_finish) begin
                new_statew3[31 : 24] <= add_result3;
            end else if (count == 4'b0011 && four_mul_finish) begin
                new_statew4[31 : 24] <= add_result3;
            end else if (count == 4'b0100 && four_mul_finish) begin
                new_statew1[23 : 16] <= add_result3;
            end else if (count == 4'b0101 && four_mul_finish) begin
                new_statew2[23 : 16] <= add_result3;
            end else if (count == 4'b0110 && four_mul_finish) begin
                new_statew3[23 : 16] <= add_result3;
            end else if (count == 4'b0111 && four_mul_finish) begin
                new_statew4[23 : 16] <= add_result3;
            end else if (count == 4'b1000 && four_mul_finish) begin
                new_statew1[15 : 8] <= add_result3;
            end else if (count == 4'b1001 && four_mul_finish) begin
                new_statew2[15 : 8] <= add_result3;
            end else if (count == 4'b1010 && four_mul_finish) begin
                new_statew3[15 : 8] <= add_result3;
            end else if (count == 4'b1011 && four_mul_finish) begin
                new_statew4[15 : 8] <= add_result3;
            end else if (count == 4'b1100 && four_mul_finish) begin
                new_statew1[7 : 0] <= add_result3;
            end else if (count == 4'b1101 && four_mul_finish) begin
                new_statew2[7 : 0] <= add_result3;
            end else if (count == 4'b1110 && four_mul_finish) begin
                new_statew3[7 : 0] <= add_result3;
            end else if (count == 4'b1111 && four_mul_finish) begin
                new_statew4[7 : 0] <= add_result3;
            end
        end 
    end

    assign done = ((count == 4'b1111) && (four_mul_finish)); 

    

endmodule
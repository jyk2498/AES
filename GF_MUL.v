// Top_GF_Mul
// input : 
//      clk;
// input : 
//      en;
// input :
//      8bit_state_1;
// input :
//      8bit_state_2;
// output :
//      8bit_o_state;
// output :
//      o_done ( signal that that the output value 8bit_o_state is valid. )
//             ( waveform : 1 Tickle )
module Top_GF_Mul
(
    input clk,
    input en,
    input [7:0] i_state_1,
    input [7:0] i_state_2,
    output [7:0] o_state,
    output o_done
);

wire [7:0] o_state_0,o_state_1,o_state_2,o_state_3,o_state_4,o_state_5,o_state_6,o_state_7;
wire out_done_0,out_done_1,out_done_2,out_done_3,out_done_4,out_done_5,out_done_6,out_done_7;
GF_Mul u0(clk,en&&i_state_1[0],i_state_1[0],3'b000,i_state_2,o_state_0,out_done_0);
GF_Mul u1(clk,en&&i_state_1[1],i_state_1[1],3'b001,i_state_2,o_state_1,out_done_1);
GF_Mul u2(clk,en&&i_state_1[2],i_state_1[2],3'b010,i_state_2,o_state_2,out_done_2);
GF_Mul u3(clk,en&&i_state_1[3],i_state_1[3],3'b011,i_state_2,o_state_3,out_done_3);
GF_Mul u4(clk,en&&i_state_1[4],i_state_1[4],3'b100,i_state_2,o_state_4,out_done_4);
GF_Mul u5(clk,en&&i_state_1[5],i_state_1[5],3'b101,i_state_2,o_state_5,out_done_5);
GF_Mul u6(clk,en&&i_state_1[6],i_state_1[6],3'b110,i_state_2,o_state_6,out_done_6);
GF_Mul u7(clk,en&&i_state_1[7],i_state_1[7],3'b111,i_state_2,o_state_7,out_done_7);

wire [7:0] c_out_done1,c_out_done2,c_out_done3,c_out_done4,c_out_done5,c_out_done6;
GF_ADD_8bit u8(o_state_0,o_state_1,c_out_done1);
GF_ADD_8bit u9(c_out_done1,o_state_2,c_out_done2);
GF_ADD_8bit u10(c_out_done2,o_state_3,c_out_done3);
GF_ADD_8bit u11(c_out_done3,o_state_4,c_out_done4);
GF_ADD_8bit u12(c_out_done4,o_state_5,c_out_done5);
GF_ADD_8bit u13(c_out_done5,o_state_6,c_out_done6);
GF_ADD_8bit u14(c_out_done6,o_state_7,o_state);

wire cnt_done;
reg [2:0] cnt;
always @(posedge clk) begin
    if(!en) begin
        cnt <= 3'b0;
    end else if(cnt_done) begin
        cnt <= 3'b0;    
    end else begin
        cnt <= cnt +1;
    end
end

assign cnt_done = en && (cnt == 3'b111);
assign o_done = cnt_done;

endmodule


// GF_Mul
// input : 
//      clk
// input :
//      en
// input : 
//      i_state_1_num ( coefficient of each state_1's degree )
// input :
//      [2:0] i_state_1_cnt ( each degree of state_1 )
// input :
//      [7:0] i_state_2 
// output : 
//      reg [7:0] o_state
// output :
//      out_done ( signal that that the output value 8bit_o_state is valid. )
//               ( waveform : 1 Tickle )
module GF_Mul
(
    input clk,
    input en,
    input i_state_1_num,
    input [2:0] i_state_1_cnt,
    input [7:0] i_state_2,
    output reg [7:0] o_state,
    output out_done
);
reg o_done;
reg r_done;
reg [8:0] r_shift_i_state_2;
wire [8:0] w_shift_i_state_2;
wire [8:0] R_w_shift_i_state_2;
reg [2:0] cnt; 
wire shift_done;

always @(posedge clk) begin
   if(!en) begin
       o_state <= 8'b0;
       o_done <= 0;
       r_shift_i_state_2 <= {1'b0,i_state_2};
       cnt <= 3'b0;
   end else if(!i_state_1_num) begin
       o_state <= 8'b0;
       o_done <= 1;
   end else if(!shift_done) begin
        r_shift_i_state_2 <= ( R_w_shift_i_state_2 << 1 );
        cnt <= cnt + 1;
   end else begin
       o_state <= w_shift_i_state_2[7:0];
       o_done <= 1;
       cnt <= 0;
   end
end

always @(posedge clk) begin
    if(o_done == 1) begin
        r_done <= 1'b1;
    end else begin
        r_done <= 1'b0;
    end
end
assign out_done = (o_done ==1) && (r_done == 0); 



assign shift_done = en && (cnt == i_state_1_cnt) ;

wire [8:0] A_shift_i_state_2;
wire w_b;
GF_ADD_9bit u0 (9'b100011011,r_shift_i_state_2,A_shift_i_state_2);
MUX u1 (r_shift_i_state_2,A_shift_i_state_2,r_shift_i_state_2[8],w_shift_i_state_2);
MUX u2(w_shift_i_state_2,{1'b0,i_state_2},cnt==0,R_w_shift_i_state_2);

endmodule


// GF_ADDER_8bit
// input :
//      8bit state_1
// input :
//      8bit state_2
// output : 
//      8bit o_state
module GF_ADD_8bit
(
    input [7:0] i_state_1,
    input [7:0] i_state_2,
    output [7:0] o_state
);

assign o_state[0] = i_state_1[0] ^ i_state_2[0];
assign o_state[1] = i_state_1[1] ^ i_state_2[1];
assign o_state[2] = i_state_1[2] ^ i_state_2[2];
assign o_state[3] = i_state_1[3] ^ i_state_2[3];
assign o_state[4] = i_state_1[4] ^ i_state_2[4];
assign o_state[5] = i_state_1[5] ^ i_state_2[5];
assign o_state[6] = i_state_1[6] ^ i_state_2[6];
assign o_state[7] = i_state_1[7] ^ i_state_2[7];

endmodule


// GF_ADDER_9bit
// input :
//      9bit state_1
// input :
//      9bit state_2
// output : 
//      9bit o_state
module GF_ADD_9bit
(
    input [8:0] i_state_1,
    input [8:0] i_state_2,
    output [8:0] o_state
);

assign o_state[0] = i_state_1[0] ^ i_state_2[0];
assign o_state[1] = i_state_1[1] ^ i_state_2[1];
assign o_state[2] = i_state_1[2] ^ i_state_2[2];
assign o_state[3] = i_state_1[3] ^ i_state_2[3];
assign o_state[4] = i_state_1[4] ^ i_state_2[4];
assign o_state[5] = i_state_1[5] ^ i_state_2[5];
assign o_state[6] = i_state_1[6] ^ i_state_2[6];
assign o_state[7] = i_state_1[7] ^ i_state_2[7];
assign o_state[8] = i_state_1[8] ^ i_state_2[8];

endmodule

// 9bit 2-to-1 MUX
module MUX
(
    input [8:0] a,
    input [8:0] b,
    input c,
    output reg [8:0] out
);
always@(a,b,c) begin
    case(c)
    1'b0 : out = a;
    1'b1 : out = b;
    endcase
end
endmodule
 
    
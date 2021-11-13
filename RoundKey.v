//Roundkey
module Top_Roundkey(
    input clk,
    input areset_n,
    input en,
    input [31:0] init_word_1,
    input [31:0] init_word_2,
    input [31:0] init_word_3,
    input [31:0] init_word_4,
    input [3:0] round_num,
    input done,
    output reg [31:0] o_word_1,
    output reg [31:0] o_word_2,
    output reg [31:0] o_word_3,
    output reg [31:0] o_word_4
);
parameter IDLE = 4'b0000;
parameter Shift = 4'b0001;
parameter S_box = 4'b0010;
parameter Make_G = 4'b0011;
parameter ADD = 4'b0100;


reg [2:0] c_state;
reg [2:0] n_state;

wire Shift_done;
wire S_box_done;
wire Make_G_done;
wire ADD_done;

always @(posedge clk or negedge areset) begin
    if(!areset) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end


always @(*) begin
    n_state = IDLE;
    case(c_state)
    IDLE : if(en == 1'b1 && round_num == 4'b000) begin
                n_state = ADD;
            end else if(en == 1'b1) begin
                n_state = Shift;
            end
    Shift : if(Shift_done == 1)
                n_state = S_box;
    S_box : if(S_box_done == 1)
                n_state = Make_G;
    Make_G : if(Make_G_done  ==1)
                n_state = ADD;
    ADD : if(ADD_done == 1)
                n_state = IDLE; 
    endcase
end

//output
reg Shift_en;
wire [31:0] Shift_word_1,Shift_word_2,Shift_word_3,Shift_word_4;
always @(*) begin
    case(c_state)
    IDLE :  begin
            o_word_1 = 0;
            o_word_2 = 0;
            o_word_3 = 0;
            o_word_4 = 0;
            Shift_en = 0;
        end
    Shift : Shift_en = 1;
    S_box : begin end
    endcase
end

Shift u0 (clk,areset,round_num,Shift_en,i_word_1,i_word_2,i_word_3,i_word_4,Shift_word_1,Shift_word_2,Shift_word_3,Shift_word_4,Shift_done);
Mux u1 (init_word_1,init_word_2,init_word_3,init_word_4,save_word_1,save_word_2,save_word_3,save_word_4,round_num,i_word_1,i_word_2,i_word_3,i_word_4);




endmodule


module Shift(
    input clk,
    input areset,
    input [3:0] round_num,
    input en,
    input [31:0] i_word_1,
    input [31:0] i_word_2,
    input [31:0] i_word_3,
    input [31:0] i_word_4,
    output reg [31:0] Shift_word_1,
    output reg [31:0] Shift_word_2,
    output reg [31:0] Shift_word_3,
    output reg [31:0] Shift_word_4,
    output wire o_done
);

reg r_done;
always @(posedge clk or negedge areset) begin
    if(!areset) begin
        Shift_word_1 <= 32'b0;
        Shift_word_2 <= 32'b0;
        Shift_word_3 <= 32'b0;
        Shift_word_4 <= 32'b0;
        r_done <= 0;
    end else if(!en) begin
        Shift_word_1 <= 32'b0;
        Shift_word_2 <= 32'b0;
        Shift_word_3 <= 32'b0;
        Shift_word_4 <= 32'b0;
        r_done <= 0;
    end else if(round_num == 4'b000) begin
        Shift_word_1 <= i_word_1;
        Shift_word_2 <= i_word_2;
        Shift_word_3 <= i_word_3;
        Shift_word_4 <= i_word_4;
        r_done <= 1;
    end else begin
        Shift_word_1 <= i_word_2;
        Shift_word_2 <= i_word_3;
        Shift_word_3 <= i_word_4;
        Shift_word_4 <= i_word_1;
        r_done <= 1;
    end
end

reg c_done;
always @(posedge clk or negedge areset) begin
    if(!areset) begin
        c_done <= 0;
    end else begin
        c_done <= 1;
    end
end

assign o_done = en && ( (r_done == 1) && (c_done == 0) );
endmodule


module Mux(
    input [31:0] init_word_1,
    input [31:0] init_word_2,
    input [31:0] init_word_3,
    input [31:0] init_word_4,
    input [31:0] save_word_1,
    input [31:0] save_word_2,
    input [31:0] save_word_3,
    input [31:0] save_word_4,
    input [3:0] round_num,
    output reg [31:0] i_word_1,
    output reg [31:0] i_word_2,
    output reg [31:0] i_word_3,
    output reg [31:0] i_word_4
);
always @(*) begin
    if(round_num == 4'b0000) begin
            i_word_1 = init_word_1;
            i_word_2 = init_word_2;
            i_word_3 = init_word_3;
            i_word_4 = init_word_4;
    end else begin
            i_word_1 = save_word_1;
            i_word_2 = save_word_2;
            i_word_3 = save_word_3;
            i_word_4 = save_word_4;
    end
end
endmodule
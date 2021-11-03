
// Code your design here
module operation3(
    clk,
    rst,
    input_tp,
    op3_input_STB,
    op3_BUSY,
    output_x,
    op3_output_STB,
    output_module_BUSY
);

input clk;
input rst;
input input_tp;

input op3_input_STB;
output op3_BUSY;
output  op3_output_STB;
input output_module_BUSY;
output[31:0] output_x;

reg a;
reg op3_BUSY_reg, op3_output_STB_reg;
reg[31:0] output_x_temp;
assign output_x = output_x_temp; 
assign op3_output_STB =  op3_output_STB_reg;
assign op3_BUSY = op3_BUSY_reg;



parameter    state_0 = 3'b000;
parameter   state_1 = 3'b001;
parameter   state_2 = 3'b010;
parameter    state_3 = 3'b011;
parameter    finish = 3'b100;




reg [2:0] current_state;

always@(posedge clk)
begin
if(!rst)
begin
    case(current_state)

    state_0:
    begin
        op3_BUSY_reg<=0;
        if(op3_input_STB && !op3_BUSY_reg)
        begin
            a <= input_tp;
            op3_BUSY_reg<=1'b1;
            current_state <= state_1;
        end
    end

    state_1:
    begin
        if(a)
        begin
        current_state <= state_2;
        end        
        else
        begin
        current_state <=state_3;
        end
    end
    
    state_2:
    begin
        op3_output_STB_reg <= 1'b1;
        output_x_temp <= 32'b00111111100000000000000000000000;
        current_state <= finish;
    end

    state_3:
    begin
        op3_output_STB_reg <=1'b1;
        output_x_temp <=32'b00000000000000000000000000000000;
        current_state <=finish;
    end

    finish:
    begin
        if(op3_output_STB_reg && !output_module_BUSY)
        begin
            op3_output_STB_reg <= 1'b0;
            current_state <= state_0;
        end
    end
endcase

end

if(rst)
begin
op3_BUSY_reg <= 0;
op3_output_STB_reg <= 0;
current_state <= state_0;
end
    
end

endmodule: operation3

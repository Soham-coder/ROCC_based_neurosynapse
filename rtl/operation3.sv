// Code your design here
// Code your design here
module operation3(
    clk,
    rst,
    input_tp,
    op2_input_STB,
    op2_BUSY,
    output_x,
    op2_output_STB,
    output_module_BUSY
);

input clk;
input rst;
input input_tp;

input op2_input_STB;
input op2_BUSY;
output  op2_output_STB;
input output_module_BUSY;
output[31:0] output_x;

reg a;
reg op2_BUSY_reg, op2_output_STB_reg;
reg[31:0] output_x_temp;
assign output_x = output_x_temp; 
assign op2_output_STB =  op2_output_STB_reg;
assign op2_BUSY = op2_BUSY_reg;

typedef enum logic[4:0] 
{
    state_0 = 0,
    state_1 = 1,
    state_2 = 2,
    state_3 = 3,
    finish = 4
}
state_t;


state_t current_state;

always@(posedge clk)
begin
    case(current_state)

    state_0:
    begin
        op2_BUSY_reg<=0;
        if(op2_input_STB && !op2_BUSY)
        begin
            a <= input_tp;
            op2_BUSY_reg<=1'b1;
            current_state <= state_1;
        end
    end

    state_1:
    begin
        if(a)
        begin
            current_state <=state_2;
        end        
        else
        begin
            current_state <=state_3;
        end
    end
    
    state_2:
    begin
        op2_output_STB_reg <= 1'b1;
        output_x_temp <= 'h3f800000;
        current_state <= finish;
    end

    state_3:
    begin
        op2_output_STB_reg <=1'b1;
        output_x_temp <=0;
        current_state <=finish;
    end

    finish:
    begin
        if(op2_output_STB_reg && !output_module_BUSY)
        begin
            op2_output_STB_reg <= 1'b0;
            current_state <= state_0;
        end
    end
endcase

end

always@(posedge clk)
begin
  if(rst)
    begin
    op2_BUSY_reg <= 0;
    op2_output_STB_reg <= 0;
    current_state <= state_0;
    end
end

endmodule: operation3

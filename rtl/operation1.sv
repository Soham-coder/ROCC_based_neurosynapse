

module operation1(
    clk,
    rst,
    input_a,
    input_b,
    input_c,
    input_d,
    op1_input_STB,
    op1_BUSY,
    output_result,
    op1_output_STB,
    output_module_BUSY
   );

   input clk;
   input rst;
   
   input [31:0] input_a;
   input [31:0] input_b;
   input [31:0] input_c;
   input [31:0] input_d;
   
   input     op1_input_STB;
   output    op1_BUSY;
  
   output    [31:0] output_result;
  
   output    op1_output_STB;
   input     output_module_BUSY;
   


reg mult_input_STB1, mult_BUSY1;
reg [31:0] result1;
reg output_STB1, output_BUSY1;
reg [31:0] a, b;
multiplier mult_inst1 (
        .input_a(a),
        .input_b(b),
        .mult_input_STB(mult_input_STB1),
        .mult_BUSY(mult_BUSY1),
        .clk(clk),
        .rst(rst),
        .output_mult(result1),
        .mult_output_STB(output_STB1),
        .output_module_BUSY(output_BUSY1)
		);

reg mult_input_STB2, mult_BUSY2;
reg [31:0] result2;
reg output_STB2, output_BUSY2;
reg [31:0] c, d;
multiplier mult_inst2 (
        .input_a(c),
        .input_b(d),
        .mult_input_STB(mult_input_STB2),
        .mult_BUSY(mult_BUSY2),
        .clk(clk),
        .rst(rst),
        .output_mult(result2),
        .mult_output_STB(output_STB2),
        .output_module_BUSY(output_BUSY2)
		);

reg adder_input_STB, adder_BUSY;
reg [31:0] output_result_reg;
reg adder_output_STB, adder_output_module_BUSY;
reg [31:0] result1_reg, result2_reg;

adder adder_inst
        (
        .input_a(result1_reg),
        .input_b(result2_reg),
		.adder_input_STB(adder_input_STB),
		.adder_BUSY(adder_BUSY),
        .clk(clk),
        .rst(rst),
		.output_sum(output_result_reg),
        .adder_output_STB(adder_output_STB),
        .output_module_BUSY(adder_output_module_BUSY)
		);


//reg [31:0] a,b,c,d;
//reg mult_input_STB1, mult_input_STB2;
reg op1_BUSY_reg, op1_output_STB_reg;
reg [31:0] output_result_temp;

assign output_result = output_result_temp; 
assign op1_output_STB =  op1_output_STB_reg;
assign op1_BUSY = op1_BUSY_reg;

typedef enum logic[2:0] 
{
  get_a_b_start_mult = 0,
  wait_for_mult1_comp = 1,
  get_c_d_start_mult = 2,
  wait_for_mult2_comp = 3,
  start_add = 4,
  finish = 5,
  wait_for_add_comp = 6
}
state_t;

 

state_t current_state;

always@(posedge clk)
begin
  
case(current_state)

  
get_a_b_start_mult:
  begin
    op1_BUSY_reg <= 0;
    if(op1_input_STB && !op1_BUSY)
    begin
    a<= input_a;
    b<= input_b;
    mult_input_STB1 <= 1'b1;
    op1_BUSY_reg <= 1'b1;
    if(mult_input_STB1 && mult_BUSY1)
      begin
        mult_input_STB1 <= 1'b0;
        output_BUSY1 <= 1'b0;
        current_state <= wait_for_mult1_comp;
      end
    end
  end
  
wait_for_mult1_comp:
  begin
    if(output_STB1 && !output_BUSY1)
      begin
        result1_reg <= result1;
        output_BUSY1 <= 1'b1;
        current_state <= get_c_d_start_mult;
      end
  end

get_c_d_start_mult:
  begin
    c<= input_c;
    d<= input_d;
    mult_input_STB2<=1'b1;
    if(mult_input_STB2 && mult_BUSY2)
      begin
        mult_input_STB2 <= 1'b0;
        output_BUSY2<= 1'b0;
        current_state <= wait_for_mult2_comp;
      end
  end

wait_for_mult2_comp:
  begin
    if(output_STB2 && !output_BUSY2)
      begin
        result2_reg <= result2;
        output_BUSY2 <= 1'b1;
        current_state <= start_add;
      end
  end

start_add:
begin
    adder_input_STB <= 1'b1;
    if(adder_input_STB && !adder_BUSY)
      begin
        adder_input_STB <= 1'b0;
        adder_output_module_BUSY <= 1'b0;
        current_state <= wait_for_add_comp;
      end
end

wait_for_add_comp:
    begin
      if(adder_output_STB && !adder_output_module_BUSY)
        begin
            op1_output_STB_reg <= 1'b1;
            output_result_temp <= output_result_reg;
            adder_output_module_BUSY <= 1'b1;
            current_state <= finish;
        end
    end

finish:
  begin
    if(op1_output_STB_reg && !output_module_BUSY)
      begin
        op1_output_STB_reg <= 1'b0;
        current_state <= get_a_b_start_mult;
      end
  end

endcase

end

always@(posedge clk)
begin
  if(rst)
    begin
    op1_BUSY_reg <= 0;
    op1_output_STB_reg <= 0;
    adder_input_STB <= 0;
    mult_input_STB1 <= 0;
    mult_input_STB2 <= 0;
    current_state <= get_a_b_start_mult;
    end
end


endmodule : operation1









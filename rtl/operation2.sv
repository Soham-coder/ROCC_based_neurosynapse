





module operation2(
    clk,
    rst,
    input_a,
    input_b,
    input_c,
    input_d,
    op2_input_STB,
    op2_BUSY,
    output_result,
    op2_output_STB,
    output_module_BUSY
   );

   input clk;
   input rst;
   
   input [31:0] input_a;
   input [31:0] input_b;
   input [31:0] input_c;
   input [31:0] input_d;
   
   input     op2_input_STB;
   output    op2_BUSY;
  
   output    [31:0] output_result;
  
   output    op2_output_STB;
   input     output_module_BUSY;
   


reg div_input_STB1, div_BUSY1;
reg [31:0] result1;
reg output_STB1, output_BUSY1;
reg [31:0] a, b;
divider div_inst1 (
        .input_a(a),
        .input_b(b),
        .div_input_STB(div_input_STB1),
        .div_BUSY(div_BUSY1),
        .clk(clk),
        .rst(rst),
        .output_div(result1),
        .div_output_STB(output_STB1),
        .output_module_BUSY(output_BUSY1)
		);

reg div_input_STB2, div_BUSY2;
reg [31:0] result2;
reg output_STB2, output_BUSY2;
reg [31:0] c, d;
divider div_inst2 (
        .input_a(c),
        .input_b(d),
        .div_input_STB(div_input_STB2),
        .div_BUSY(div_BUSY2),
        .clk(clk),
        .rst(rst),
        .output_div(result2),
        .div_output_STB(output_STB2),
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
reg op2_BUSY_reg, op2_output_STB_reg;
reg [31:0] output_result_temp;

assign output_result = output_result_temp; 
assign op2_output_STB =  op2_output_STB_reg;
assign op2_BUSY = op2_BUSY_reg;



parameter  get_a_b_start_div = 3'b000;
parameter  deassert_div_input_STB1 = 3'b001;
parameter  wait_for_div1_comp = 3'b010;
parameter  get_c_d_start_div = 3'b011;
parameter  wait_for_div2_comp = 3'b100;
parameter  start_add = 3'b101;
parameter  finish = 3'b110;
parameter  wait_for_add_comp = 3'b111;
 

reg [2:0] current_state;

always@(posedge clk)
begin
  
if(!rst)
begin
  
case(current_state)

  
get_a_b_start_div:
  begin
    op2_BUSY_reg <= 0;
    if(op2_input_STB && !op2_BUSY_reg)
    begin
    a<= input_a;
    b<= input_b;
    div_input_STB1 <= 1'b1;
    op2_BUSY_reg <= 1'b1;
    current_state <= deassert_div_input_STB1;
    end
  end

deassert_div_input_STB1:
  begin
    if(div_input_STB1 && div_BUSY1)
      begin
        div_input_STB1 <= 1'b0;
        output_BUSY1 <= 1'b0;
        current_state <= wait_for_div1_comp;
      end

  end
  
wait_for_div1_comp:
  begin
    if(output_STB1 && !output_BUSY1)
      begin
        result1_reg <= result1;
        output_BUSY1 <= 1'b1;
        current_state <= get_c_d_start_div;
      end
  end

get_c_d_start_div:
  begin
    c<= input_c;
    d<= input_d;
    div_input_STB2<=1'b1;
    if(div_input_STB2 && div_BUSY2)
      begin
        div_input_STB2 <= 1'b0;
        output_BUSY2<= 1'b0;
        current_state <= wait_for_div2_comp;
      end
  end

wait_for_div2_comp:
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
            op2_output_STB_reg <= 1'b1;
            output_result_temp <= output_result_reg;
            adder_output_module_BUSY <= 1'b1;
            current_state <= finish;
        end
    end

finish:
  begin
    if(op2_output_STB_reg && !output_module_BUSY)
      begin
        op2_output_STB_reg <= 1'b0;
        current_state <= get_a_b_start_div;
      end
  end

endcase

end

if(rst)
begin
op2_BUSY_reg <= 0;
op2_output_STB_reg <= 0;
adder_input_STB <= 0;
div_input_STB1 <= 0;
div_input_STB2 <= 0;
current_state <= get_a_b_start_div;
end

end

endmodule : operation2



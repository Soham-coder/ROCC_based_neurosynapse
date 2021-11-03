module operation5(
    clk,
    rst,
    input_a,
    input_b,
    input_c,
    input_d,
    op5_input_STB,
    op5_BUSY,
    output_result,
    op5_output_STB,
    output_module_BUSY
   );

   input clk;
   input rst;
   
   input [31:0] input_a;
   input [31:0] input_b;
   input [31:0] input_c;
   input [31:0] input_d;
   
   input     op5_input_STB;
   output    op5_BUSY;
  
   output    [31:0] output_result;
  
   output    op5_output_STB;
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

reg mult_input_STB, mult_BUSY;
reg [31:0] output_result_reg;
reg mult_output_STB, mult_output_module_BUSY;
reg [31:0] result1_reg, result2_reg;

multiplier mult_inst3
        (
        .input_a(result1_reg),
        .input_b(result2_reg),
		.mult_input_STB(mult_input_STB),
		.mult_BUSY(mult_BUSY),
        .clk(clk),
        .rst(rst),
		.output_mult(output_result_reg),
        .mult_output_STB(mult_output_STB),
        .output_module_BUSY(mult_output_module_BUSY)
		);


//reg [31:0] a,b,c,d;
//reg mult_input_STB1, mult_input_STB2;
reg op5_BUSY_reg, op5_output_STB_reg;
reg [31:0] output_result_temp;

assign output_result = output_result_temp; 
assign op5_output_STB =  op5_output_STB_reg;
assign op5_BUSY = op5_BUSY_reg;


parameter  get_a_b_start_mult = 3'b000;
parameter  deassert_mult_input_STB1 = 3'b001;
parameter  wait_for_mult1_comp = 3'b010;
parameter  get_c_d_start_mult = 3'b011;
parameter  wait_for_mult2_comp = 3'b100;
parameter  start_mult = 3'b101;
parameter  finish = 3'b110;
parameter  wait_for_mult3_comp = 3'b111;

 

reg [2:0] current_state;

always@(posedge clk)
begin
if(!rst)
begin
case(current_state)

  
get_a_b_start_mult:
  begin
    op5_BUSY_reg <= 0;
    if(op5_input_STB && !op5_BUSY_reg)
    begin
    a<= input_a;
    b<= input_b;
    mult_input_STB1 <= 1'b1;
    op5_BUSY_reg <= 1'b1;
    //$display("debug1");
    current_state <= deassert_mult_input_STB1;
    end
  end
  
deassert_mult_input_STB1:
  begin
    if(mult_input_STB1 && mult_BUSY1)
      begin
        //$display("debug2");
        mult_input_STB1 <= 1'b0;
        output_BUSY1 <= 1'b0;
        current_state <= wait_for_mult1_comp;
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
        current_state <= start_mult;
      end
  end

start_mult:
begin
    mult_input_STB <= 1'b1;
    if(mult_input_STB && !mult_BUSY)
      begin
        mult_input_STB <= 1'b0;
        mult_output_module_BUSY <= 1'b0;
        current_state <= wait_for_mult3_comp;
      end
end

wait_for_mult3_comp:
    begin
      if(mult_output_STB && !mult_output_module_BUSY)
        begin
            op5_output_STB_reg <= 1'b1;
            output_result_temp <= output_result_reg;
            mult_output_module_BUSY <= 1'b1;
            current_state <= finish;
        end
    end

finish:
  begin
    if(op5_output_STB_reg && !output_module_BUSY)
      begin
        op5_output_STB_reg <= 1'b0;
        current_state <= get_a_b_start_mult;
      end
  end

endcase
end

if(rst)
begin
op5_BUSY_reg <= 0;
op5_output_STB_reg <= 0;
mult_input_STB <= 0;
mult_input_STB1 <= 0;
mult_input_STB2 <= 0;
current_state <= get_a_b_start_mult;
end
    
end


endmodule 

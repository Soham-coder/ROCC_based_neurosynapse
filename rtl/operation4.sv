module operation4(
    clk,
    rst,
    input_a,
    input_b,
    input_c,
    input_d,
    op4_input_STB,
    op4_BUSY,
    output_result,
    op4_output_STB,
    output_module_BUSY
   );

   input clk;
   input rst;
   
   input [31:0] input_a;
   input [31:0] input_b;
   input [31:0] input_c;
   input [31:0] input_d;
   
   input     op4_input_STB;
   output    op4_BUSY;
  
   output    [31:0] output_result;
  
   output    op4_output_STB;
   input     output_module_BUSY;
   


reg adder_input_STB1, adder_BUSY1;
reg [31:0] result1;
reg output_STB1, output_BUSY1;
reg [31:0] a, b;
adder adder_inst1
        (
        .input_a(a),
        .input_b(b),
		.adder_input_STB(adder_input_STB1),
		.adder_BUSY(adder_BUSY1),
        .clk(clk),
        .rst(rst),
		.output_sum(result1),
        .adder_output_STB(output_STB1),
        .output_module_BUSY(output_BUSY1)
		);

reg adder_input_STB2, adder_BUSY2;
reg [31:0] result2;
reg output_STB2, output_BUSY2;
reg [31:0] c, d;
adder adder_inst2
        (
        .input_a(c),
        .input_b(d),
		.adder_input_STB(adder_input_STB2),
		.adder_BUSY(adder_BUSY2),
        .clk(clk),
        .rst(rst),
		.output_sum(result2),
        .adder_output_STB(output_STB2),
        .output_module_BUSY(output_BUSY2)
		);

reg adder_input_STB, adder_BUSY;
reg [31:0] output_result_reg;
reg adder_output_STB, adder_output_module_BUSY;
reg [31:0] result1_reg, result2_reg;

adder adder_inst3
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
reg op4_BUSY_reg, op4_output_STB_reg;
reg [31:0] output_result_temp;

assign output_result = output_result_temp; 
assign op4_output_STB =  op4_output_STB_reg;
assign op4_BUSY = op4_BUSY_reg;


parameter  get_a_b_start_add = 3'b000;
parameter  deassert_add_input_STB1 = 3'b001;
parameter  wait_for_add1_comp = 3'b010;
parameter  get_c_d_start_add = 3'b011;
parameter  wait_for_add2_comp = 3'b100;
parameter  start_add = 3'b101;
parameter  finish = 3'b110;
parameter  wait_for_add3_comp = 3'b111;

 

reg [2:0] current_state;

always@(posedge clk)
begin
if(!rst)
begin
case(current_state)

  
get_a_b_start_add:
  begin
    op4_BUSY_reg <= 0;
    if(op4_input_STB && !op4_BUSY_reg)
    begin
    a<= input_a;
    b<= input_b;
    adder_input_STB1 <= 1'b1;
    op4_BUSY_reg <= 1'b1;
    //$display("debug1");
    current_state <= deassert_add_input_STB1;
    end
  end
  
deassert_add_input_STB1:
  begin
    if(adder_input_STB1 && adder_BUSY1)
      begin
        //$display("debug2");
        adder_input_STB1 <= 1'b0;
        output_BUSY1 <= 1'b0;
        current_state <= wait_for_add1_comp;
      end
    end
 
  
wait_for_add1_comp:
  begin
    if(output_STB1 && !output_BUSY1)
      begin
        result1_reg <= result1;
        output_BUSY1 <= 1'b1;
        current_state <= get_c_d_start_add;
      end
  end

get_c_d_start_add:
  begin
    c<= input_c;
    d<= input_d;
    adder_input_STB2<=1'b1;
    if(adder_input_STB2 && adder_BUSY2)
      begin
        adder_input_STB2 <= 1'b0;
        output_BUSY2<= 1'b0;
        current_state <= wait_for_add2_comp;
      end
  end

wait_for_add2_comp:
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
        current_state <= wait_for_add3_comp;
      end
end

wait_for_add3_comp:
    begin
      if(adder_output_STB && !adder_output_module_BUSY)
        begin
            op4_output_STB_reg <= 1'b1;
            output_result_temp <= output_result_reg;
            adder_output_module_BUSY <= 1'b1;
            current_state <= finish;
        end
    end

finish:
  begin
    if(op4_output_STB_reg && !output_module_BUSY)
      begin
        op4_output_STB_reg <= 1'b0;
        current_state <= get_a_b_start_add;
      end
  end

endcase
end

if(rst)
begin
op4_BUSY_reg <= 0;
op4_output_STB_reg <= 0;
adder_input_STB <= 0;
adder_input_STB1 <= 0;
adder_input_STB2 <= 0;
current_state <= get_a_b_start_add;
end
    
end


endmodule


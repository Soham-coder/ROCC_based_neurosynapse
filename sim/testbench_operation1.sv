module tb;
  
  logic clk;
  logic rst;
  logic [31:0] input_a, input_b, input_c, input_d;
  logic op1_input_STB;
  wire op1_BUSY;
  wire [31:0] output_result;
  wire op1_output_STB;
  logic output_module_BUSY;
  
  
 
///////////////////////////////////////////////////
///////Constraint class sending random data////////
///////////////////////////////////////////////////  
class rand_real ;

  rand bit[31:0] rand_var1;
  rand bit[31:0] rand_var2;
  rand bit[31:0] rand_var3;
  rand bit[31:0] rand_var4;

  constraint c1 {

    rand_var1 > 'h3f800000; rand_var1 < 'h40000000; rand_var1!= 'h00000000; //{1,2}
    rand_var2 > 'h3f800000; rand_var2 < 'h40000000; rand_var2!= 'h00000000; //{1,2]
    rand_var3 > 'h3f800000; rand_var3 < 'h40000000; rand_var3!= 'h00000000; //{1,2}
    rand_var4 > 'h3f800000; rand_var4 < 'h40000000; rand_var4!= 'h00000000; //{1,2}
  

  };
  endclass : rand_real
///////////////////////////////////////////////////
///////Constraint class sending random data////////
///////////////////////////////////////////////////  

  
  
  rand_real rand_real_inst;
 
  
  operation1 op1_inst(
    .clk(clk),
    .rst(rst),
    .input_a(input_a),
    .input_b(input_b),
    .input_c(input_c),
    .input_d(input_d),
    .op1_input_STB(op1_input_STB),
    .op1_BUSY(op1_BUSY),
    .output_result(output_result),
    .op1_output_STB(op1_output_STB),
    .output_module_BUSY(output_module_BUSY)
   );
  
  
  mailbox#(logic[31:0]) input_a_mb  = new(1);
  mailbox#(logic[31:0]) input_b_mb  = new(1);
  mailbox#(logic[31:0]) input_c_mb  = new(1);
  mailbox#(logic[31:0]) input_d_mb  = new(1);
  mailbox#(logic[31:0]) output_result_mb  = new(1);
 
  event given_inputs;
  
 
  
  
  task give_inputs();
  logic [31:0] input_a_reg, input_b_reg, input_c_reg, input_d_reg;
  @(posedge clk iff(op1_BUSY === 1'b0 && rst === 1'b0));
  rand_real_inst = new();
  assert (rand_real_inst.randomize());
            
  op1_input_STB = 1'b1;
  
  input_a_reg = rand_real_inst.rand_var1;
  input_a_mb.put(input_a_reg);
  input_a = input_a_reg;
  $display("storing a(hex):%h", input_a_reg);
  $display("storing a(float):%f", $bitstoshortreal(input_a_reg));
  input_b_reg = rand_real_inst.rand_var2;
  input_b_mb.put(input_b_reg);
  input_b = input_b_reg;
  $display("storing b(hex):%h", input_b_reg);
  $display("storing b(float):%f", $bitstoshortreal(input_b_reg));
  input_c_reg = rand_real_inst.rand_var3;
  input_c_mb.put(input_c_reg);
  input_c = input_c_reg;
  $display("storing c(hex):%h", input_c_reg);
  $display("storing c(float):%f", $bitstoshortreal(input_c_reg));
  input_d_reg = rand_real_inst.rand_var4;
  input_d_mb.put(input_d_reg);
  input_d = input_d_reg;
  $display("storing d(hex):%h", input_d_reg);
  $display("storing d(float):%f", $bitstoshortreal(input_d_reg));
 
  @(posedge clk iff(op1_BUSY === 1'b0 && rst === 1'b0));
  -> given_inputs;
  endtask:give_inputs
   
  task give_rst();
    @(posedge clk);
    rst <= 1'b1;
    $display("RESET HIGH @ %t", $time);
    repeat(3)@(posedge clk);
    $display("RESET LOW @ %t", $time);
    rst <= 1'b0;
    output_module_BUSY <= 1'b0;
  endtask:give_rst
        
  
        
  
  logic[31:0] output_result_reg;
  logic[31:0] a, b, c, d, result;
  real real_a, real_b, real_c, real_d, real_result;
  real expected_result;
  
  always begin//always checking
  
  @(given_inputs);
  
  @(posedge clk iff(op1_output_STB === 1'b1 && output_module_BUSY === 1'b0 && rst === 1'b0));
  output_result_reg = output_result;
  output_result_mb.put(output_result_reg);
  $display("storing out(hex):%h", output_result_reg);
  $display("storing out(float):%f", $bitstoshortreal(output_result_reg));
  if(input_a_mb.num()===1 && input_b_mb.num()===1 && input_c_mb.num()===1 && input_d_mb.num()===1 && output_result_mb.num()===1)begin//if
    input_a_mb.get(a);
    input_b_mb.get(b);
    input_c_mb.get(c);
    input_d_mb.get(d);
    output_result_mb.get(result);
    real_a = $bitstoshortreal(a);
    real_b = $bitstoshortreal(b);
    real_c = $bitstoshortreal(c);
    real_d = $bitstoshortreal(d);
    real_result = $bitstoshortreal(result);
    expected_result = ($bitstoshortreal(a)*$bitstoshortreal(b))+($bitstoshortreal(c)*$bitstoshortreal(d));
    $display("input_a=%f, input_b=%f, input_c=%f, input_d=%f <------> result=%f, expected_result=%f", real_a, real_b, real_c, real_d, real_result, expected_result);
  end//if
  
  end//always checking
      
        
  
  
  
  
 

        
  initial begin
  forever begin 
    fork : START
      give_inputs();
    join : START
  end
  end
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 1'b0;
    give_rst();
    #100000;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  
  
  endmodule:tb
  
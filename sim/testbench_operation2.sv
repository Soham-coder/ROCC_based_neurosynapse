module testbench_operation2;
  
  logic clk;
  logic rst;
  logic [31:0] input_a, input_b, input_c, input_d;
  logic op3_input_STB;
  wire op3_BUSY;
  wire [31:0] output_result;
  wire op3_output_STB;
  logic output_module_BUSY;
  
  operation2 op3_inst(
    .clk(clk),
    .rst(rst),
    .input_a(input_a),
    .input_b(input_b),
    .input_c(input_c),
    .input_d(input_d),
    .op3_input_STB(op3_input_STB),
    .op3_BUSY(op3_BUSY),
    .output_result(output_result),
    .op3_output_STB(op3_output_STB),
    .output_module_BUSY(output_module_BUSY)
   );
  
  
  
  logic[31:0] input_a_queue[$];
  logic[31:0] input_b_queue[$];
  logic[31:0] input_c_queue[$];
  logic[31:0] input_d_queue[$];
  
  logic[31:0] output_result_queue[$];
  
  
  task give_inputs();
    forever begin
        @(posedge clk iff(op3_BUSY === 1'b0 && rst === 1'b0));
          op3_input_STB <= 1'b1;
      input_a <= 'hc0800000;
      input_b <= 'h40000000;
      input_c <= 'h40000000;
      input_d <= 'h40000000;
    end
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
        
  task store_valid_inputs();
    forever begin
    @(posedge clk iff(op3_input_STB === 1'b1 && op3_BUSY === 1'b0 && rst === 1'b0));
        input_a_queue.push_front(input_a);
        input_b_queue.push_front(input_b);
        input_c_queue.push_front(input_c);
        input_d_queue.push_front(input_d);
    end
  endtask:store_valid_inputs
        
  task store_valid_outputs();
    forever begin
      @(posedge clk iff(op3_output_STB === 1'b1 && output_module_BUSY === 1'b0 && rst === 1'b0));
        output_result_queue.push_front(output_result);
    end
  endtask: store_valid_outputs
        
  logic[31:0] a, b, c, d, result;
  real real_a, real_b, real_c, real_d, real_result;
  
  task print_result();
      forever begin
      wait(input_a_queue.size()>0 && input_b_queue.size()>0 && input_c_queue.size()>0 && input_d_queue.size()>0 && output_result_queue.size()>0)begin
        a = input_a_queue.pop_back();
        b = input_b_queue.pop_back();
        c = input_c_queue.pop_back();
        d = input_d_queue.pop_back();
        result = output_result_queue.pop_back();
        real_a = $bitstoshortreal(a);
        real_b = $bitstoshortreal(b);
        real_c = $bitstoshortreal(c);
        real_d = $bitstoshortreal(d);
        real_result = $bitstoshortreal(result);
        $display("input_a=%f, input_b=%f, input_c=%f, input_d=%f <------> result=%f", real_a, real_b, real_c, real_d, real_result);
      end
      end
  endtask:print_result
        
  initial begin
    fork : START
      give_rst();
      give_inputs();
      store_valid_inputs();
      store_valid_outputs();
    join_none : START
    print_result();
  end
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 1'b0;
    #10000;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  endmodule:testbench_operation2

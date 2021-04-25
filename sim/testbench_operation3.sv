module  testbench_operation3;
    
    logic clk;
    logic rst;
    logic input_tp;
    logic op2_input_STB;
    wire op2_BUSY;
    wire[31:0] output_x;
    wire op2_output_STB; 
    logic output_module_BUSY;

    operation3 op2_inst(
        .clk(clk),
        .rst(rst),
        .input_tp(input_tp),
        .op2_input_STB(op2_input_STB),
        .op2_BUSY(op2_BUSY),
        .output_x(output_x),
        .op2_output_STB(op2_output_STB),
        .output_module_BUSY(output_module_BUSY)
    );

    logic input_tp_queue[$];
  
    logic[31:0] output_x_queue[$];

    task give_inputs();
    forever begin
        @(posedge clk iff(op2_BUSY === 1'b0 && rst === 1'b0));
            op2_input_STB <= 1'b1;
            input_tp=1'b1;
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
        @(posedge clk iff(op2_input_STB === 1'b1 && op2_BUSY === 1'b0 && rst === 1'b0));
            input_tp_queue.push_front(input_tp);
        end
    endtask:store_valid_inputs

    task store_valid_outputs();
    forever begin
        @(posedge clk iff(op2_output_STB === 1'b1 && output_module_BUSY === 1'b0 && rst === 1'b0));
            output_x_queue.push_front(output_x);
    end
    endtask: store_valid_outputs

    logic a;
    logic [31:0] result;
  	real real_result;
    task print_result();
    forever begin
        wait(input_tp_queue.size()>0 && output_x_queue.size()>0)begin
            a = input_tp_queue.pop_back();
            result = output_x_queue.pop_back();
          	real_result = $bitstoshortreal(result);
          $display("input_tp=%f <------> result=%f @ %t", a, real_result,$time);
        end
    end
    endtask: print_result

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
        #1000;
        $finish;
    end
  
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  
  endmodule:testbench_operation3
module TB;

reg clk, rst;
reg [31:5] inst;
reg [63:0] rs1, rs2;
reg  valid;
wire ready;

rocc_accel #( .INST_WIDTH(32), .DATA_WIDTH(64))
rocc_accel_inst 
(
   .clk(clk),
   .rst(rst),
   .inst(inst),
   .rs1(rs1),
   .rs2(rs2),
   .valid(valid),
   .ready(ready)  
);
    
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #10; rst = 0; inst = 0; valid = 0;
end
  
initial begin
  @(posedge clk iff ready === 1 && rst === 0);
  rst = 0;
  valid = 1;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, 5'b00001, 2'b00};
  rs1 = { 32'h40000000, 32'h40000000};
  rs2 = { 32'h40000000, 32'h40000000};
  @(posedge clk);
  wait(ready === 0);
  $display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  @(posedge clk);
  $display("Reg[%0d] = %0h", 5'b00001, rocc_accel_inst.reg_inst.Registers[5'b00001]);
  @(negedge clk);
  $stop;
end
  
/*initial begin
  $monitor("Reg[%0d] = %0h, time - %t", 5'b00001, rocc_accel_inst.reg_inst.Registers[5'b00001], $time);
end*/
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end
  
/*initial begin
 #3000;
 $finish; 
end*/



endmodule: TB
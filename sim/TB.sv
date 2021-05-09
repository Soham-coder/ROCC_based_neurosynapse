module TB;

reg clk, rst;
reg [31:5] inst;
reg [63:0] rs1, rs2;
reg  valid;
wire ready;

reg [4:0] destination;
reg [31:0] rs1_part1, rs1_part2;
reg [31:0] rs2_part1, rs2_part2;

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
    //rst = 1;
	//$display("RESET START @%0t", $time);
    //#10; rst = 0; inst = 0; valid = 0;
end
  
initial begin
  
  
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { 32'h40000000, 32'h40000000};
  rs2 = { 32'h40000000, 32'h40000000};
  @(posedge clk);
  wait(ready === 0);
  $display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  @(posedge clk);
  $display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  rs1_part1 = rocc_accel_inst.reg_inst.Registers[destination];
  rs1_part2 = rocc_accel_inst.reg_inst.Registers[destination];
  rs2_part1 = rocc_accel_inst.reg_inst.Registers[destination];
  rs2_part2 = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { rs1_part1, rs1_part2};
  rs2 = { rs2_part1, rs2_part2};
  @(posedge clk);
  wait(ready === 0);
  $display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  @(posedge clk);
  $display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  rs1_part1 = rocc_accel_inst.reg_inst.Registers[destination];
  rs1_part2 = rocc_accel_inst.reg_inst.Registers[destination];
  rs2_part1 = rocc_accel_inst.reg_inst.Registers[destination];
  rs2_part2 = rocc_accel_inst.reg_inst.Registers[destination];
  @(posedge clk);  
  
  
  $finish;

end
  
/*initial begin
  $monitor("Reg[%0d] = %0h, time - %t", 5'b00001, rocc_accel_inst.reg_inst.Registers[5'b00001], $time);
end*/
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end


task give_reset();
$display("RESET START @%0t", $time);
rst = 1;
valid = 0;
repeat(2) @(posedge clk);
rst = 0;
$display("RESET END @%0t", $time);
endtask : give_reset
  
/*initial begin
 #3000;
 $finish; 
end*/



endmodule: TB
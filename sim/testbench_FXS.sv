module TBFXS;
   

reg clk, rst;
reg [31:5] inst;
reg [63:0] rs1, rs2;
reg  valid;
wire ready;

reg [4:0] destination;
reg [31:0] rs1_part1, rs1_part2;
reg [31:0] rs2_part1, rs2_part2;

//Counter
integer n0,n1,n;

//Input
reg [31:0] tp0;
reg [31:0] td0;
reg [31:0] tp1;
reg [31:0] td1;

//registers
reg [31:0] RMtrace,RMtrace_new;
reg [31:0] Inh,Inh_new;
reg [31:0] A,A_new;
reg [31:0] D,D_new;
reg [31:0] W,W_new;
reg [31:0] Prel,p_rel_new;;
reg [31:0] Z,Z_new;
reg [31:0] Y,Y_new;
reg [31:0] I_syn_new;
reg [31:0] I_syn;

reg [31:0] Sm,Sm_new;
reg [31:0] Influx,Influx_new,I_syn_1;
reg [31:0] RM;


//Intermediate registers
reg [31:0] reg_a;
reg [31:0] reg_b;
reg [31:0] reg_c;
reg [31:0] reg_d;
reg [31:0] reg_e;
reg [31:0] reg_f;
reg [31:0] reg_g_a;
reg [31:0] reg_g;
reg [31:0] reg_h;
reg [31:0] reg_i;
reg [31:0] reg_t;
reg [31:0] reg_j;
reg [31:0] reg_k;

reg [31:0] reg_l;
reg [31:0] reg_la;
reg [31:0] reg_lb;
reg [31:0] reg_lc;
reg [31:0] reg_ld;
reg [31:0] reg_m;
reg [31:0] reg_n;
reg [31:0] reg_o;
reg [31:0] reg_p;
reg [31:0] reg_q;
reg [31:0] reg_qa;

reg [31:0] consta;
reg [31:0] constb;



//constants
reg [31:0] const_m1bytr;
reg [31:0] const1;
reg [31:0] const0;
reg [31:0] const_del;
reg [31:0] constm1bytinh;
reg [31:0] constm1bytc;
reg [31:0] const1bytc;
reg [31:0] constm1bytd;
reg [31:0] const1bytd;
reg [31:0] const_m1byt;
reg [31:0] const_neg1;
reg [31:0] time_const;
reg [31:0] constk0;
reg [31:0] const_1_1;
reg [31:0] const_neg_0_00001;
reg [31:0] const_neg_0_00007;
reg [31:0] const_2_5;
reg [31:0] const__neg_2_5;
reg [31:0] const0_25;

reg [31:0] const_influx;
reg [31:0] Kfmrp;
reg [31:0] mkt;


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
    n0 = 0;
    n1 = 0;
    n = 0;
    //////////
    
    tp0 = 32'b0;
    td0 = 32'b0;
    tp1 = 32'hf000000f;
    td1 = 32'hf000000f;
    
    
    ///////////////////
    RMtrace = 32'b0;
    RMtrace_new = 32'b0;
    Inh = 32'b0;
    Inh_new = 32'b0;
    A = 32'b0;
    A_new = 32'b0;
    D = 32'b0;
    D_new = 32'b0;
    W = 32'b0;
    W_new = 32'b0;
    Prel = 32'b0;
    p_rel_new = 32'b0;
    Z = 32'b0;
    Z_new = 32'b0;
    Y = 32'b0;
    Y_new = 32'b0;
    I_syn_new = 32'b0;
    I_syn = 32'b0;
    
    Influx = 32'b0;
    Influx_new = 32'b0;
    I_syn_1 = 32'b0;
    
    Sm = 32'b0;
    Sm_new = 32'b0;
    
    RM = 32'b00111111001100001110010101100000;
    
    ///////////////////
    reg_a = 32'b0;
    reg_b = 32'b0;
    reg_c = 32'b0;
    reg_d = 32'b0;
    reg_e = 32'b0;
    reg_f = 32'b0;
    reg_g_a = 32'b0;
    reg_g = 32'b0;
    reg_h = 32'b0;
    reg_i = 32'b0;
    reg_t = 32'b0;
    reg_j = 32'b0;
    reg_k = 32'b0;
    
    reg_l = 32'b0;
    reg_la = 32'b0;
    reg_lb = 32'b0;
    reg_lc = 32'b0;
    reg_ld = 32'b0;
    reg_m = 32'b0;
    reg_m = 32'b0;
    reg_o = 32'b0;
    reg_p = 32'b0;
    reg_q = 32'b0;
    reg_qa = 32'b0;
    
    consta = 32'b0;
    constb = 32'b0;
    
    ///////////////////
    const_m1bytr = 32'b11000000001000000000000000000000;
    const1 = 32'b00111111100000000000000000000000;
    const0 = 32'b0;
    const_del = 32'b00111010100000110001001001101110;
    constm1bytinh = 32'b11000001001000000000000000000000;
    constm1bytc = 32'b11000001001000000000000000000000;
    const1bytc = 32'b01000001001000000000000000000000;
    constm1bytd = 32'b11000010010010000000000000000000;
    const1bytd = 32'b01000010010010000000000000000000;
    const_m1byt = 32'b11000001001000000000000000000000;
    const_neg1 = 32'b10111111100000000000000000000000;
    time_const = 32'b00111101110011001100110011001100;
    constk0 = 32'b0;
    const_1_1 = 32'b00111111100011001100110011001100;
    const_neg_0_00001 = 32'b10110111001001111100010110101100;
    const_neg_0_00007 = 32'b10111000100100101100110011110110;
    const_2_5 = 32'b01000000001000000000000000000000;
    const__neg_2_5 = 32'b11000000001000000000000000000000;
    const0_25 = 32'b00111110100000000000000000000000;
    
    const_influx = 32'b0;
    Kfmrp = 32'b0;
    mkt = 32'b11000010001000000000000000000000;
    //rst = 1;
	  //$display("RESET START @%0t", $time);
    //#10; rst = 0; inst = 0; valid = 0;
end



class rand_real;
rand bit[30:0] rand_var1;
constraint c1 {
          rand_var1 > 31'b0111010100000110001001001101111; rand_var1 < 31'b1000000010000000000000000000000; 
        };
endclass : rand_real



rand_real rand_real_inst;

    event given_inputs;
 
    
    task give_inputs();
    logic sign;
    logic [30:0] input_a_reg;
    
    
    @(posedge clk);
    rand_real_inst = new();
    assert (rand_real_inst.randomize());
    
    sign=$random;
    input_a_reg = rand_real_inst.rand_var1;
    Kfmrp = {sign,input_a_reg};
    
    @(posedge clk);
    -> given_inputs;
    endtask:give_inputs



  
initial begin


for(n=0; n<4; n=n+1)
begin  
  

for(n0=0; n0<990; n0=n0+1)
begin   
  
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { RMtrace, const_m1bytr};
  rs2 = { RM, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  @(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_a = rocc_accel_inst.reg_inst.Registers[destination];
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { RMtrace, const1};
  rs2 = { const_del, reg_a};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  @(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  RMtrace_new = rocc_accel_inst.reg_inst.Registers[destination];
  ////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, constm1bytinh};
  rs2 = { RMtrace, A};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_b = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00100;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, const1};
  rs2 = { const_del, reg_b};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Inh_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00101;
  inst = {7'b0000011, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { tp0, tp0};
  rs2 = { tp0, tp0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_c = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset(); 
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00110;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { constm1bytc, A};
  rs2 = { const1bytc, reg_c};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_d = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00111;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { A, const1};
  rs2 = { const_del, reg_d};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  A_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01000;
  inst = {7'b0000011, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { td0, td0};
  rs2 = { td0, td0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_e = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset(); 
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { constm1bytd, D};
  rs2 = { const1bytd, reg_e};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_f = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { D, const1};
  rs2 = { const_del, reg_f};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  D_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { A, D};
  rs2 = { const0, const0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_g_a = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01100;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { reg_g_a, Prel};
  rs2 = { const0, const0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_g = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { W, const1};
  rs2 = { const_del, reg_g};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  W_new = rocc_accel_inst.reg_inst.Registers[destination];
  //////////////////////////////////////////////////////////
    
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Z, const_m1byt};
  rs2 = { reg_c, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_h = rocc_accel_inst.reg_inst.Registers[destination]; //[op1(Z,-1/t,const1,c)]
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Z, const1};
  rs2 = { const_del, reg_h};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Z_new = rocc_accel_inst.reg_inst.Registers[destination];//[op1(Z,const1,del,h)]
  /////////////////////////////////////////////////////////////////////////////////
  
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const1, const1};
  rs2 = { const_del, const_neg1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_i = rocc_accel_inst.reg_inst.Registers[destination];//op1(const1,const1,const-1,del)
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_del, Z};
  rs2 = { reg_i, Y};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Y_new = rocc_accel_inst.reg_inst.Registers[destination];//op1(del,Z,i,Y)
  /////////////////////////////////////////////////////////////////////////////////////

  give_reset();
  
     

        @(posedge clk iff ready === 1 && rst === 0);
        valid = 1;
        destination = 5'b00001;
        inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
        rs1 = { time_const, Y};
        rs2 = { const0, const0};
        @(posedge clk);
        wait(ready === 0);
        //$display("operation ongoing check 2");
        @(posedge clk);
        wait(ready === 1);
        //@(posedge clk);
        //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
        reg_t = rocc_accel_inst.reg_inst.Registers[destination];//op1(time_const,Y,0,0)
        
    
        give_reset();
        
        @(posedge clk iff ready === 1 && rst === 0);
        valid = 1;
        destination = 5'b00010;
        inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
        rs1 = { reg_t, W};
        rs2 = { reg_t, constk0};
        @(posedge clk);
        wait(ready === 0);
        //$display("operation ongoing");
        @(posedge clk);
        wait(ready === 1);
        //@(posedge clk);
        //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
        I_syn_new = rocc_accel_inst.reg_inst.Registers[destination];//op1(time_const*Y,W,time_const*Y,kO)
        
        

  
  /////////////////////////////////////////////////////////////////////////
  

     
   give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, const1};
  rs2 = { const_neg_0_00001, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_j = rocc_accel_inst.reg_inst.Registers[destination];//[op1(Inh,const1,-0.00001,const1)]
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000010, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_neg_0_00007, reg_j};
  rs2 = { const_1_1, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_k = rocc_accel_inst.reg_inst.Registers[destination];//[op2(-0.00007,j,1.1,const1)]
  
    
  give_reset();  


   @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_2_5, const1};
  rs2 = { const__neg_2_5, reg_k};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  p_rel_new = rocc_accel_inst.reg_inst.Registers[destination];//[op1(0.25,const1,-0.25,k)]

  
 
  if($bitstoshortreal(p_rel_new)>0.25)
    begin
      p_rel_new = const0_25;
    end
    
  
 else if($bitstoshortreal(p_rel_new)<0)
    begin
      p_rel_new = const0;
    end
  

/////////////////////////////////////////////////////////


/////////////FXS Syndrome////////////////////////////////
/////////////////////////////////////////////////////////

  
  give_reset(); 
  give_inputs(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { Kfmrp, mkt};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  consta = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { const_del, I_syn};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  constb = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { consta, constb};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  const_influx = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 

  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Influx, const1};
  rs2 = { const_influx, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Influx_new = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { I_syn, const1};
  rs2 = { Influx_new, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  I_syn_1 = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  
  /////////////////////////////////////////////////////


  
  give_reset();  
  
  
  RMtrace = RMtrace_new;
  Inh = Inh_new;
  A = A_new;
  D = D_new;
  W = W_new;
  Prel = p_rel_new; 
  Z = Z_new;
  Y = Y_new;
  I_syn = I_syn_new;
  Sm = Sm_new;
  Influx = Influx_new;
  
  give_reset();
  
  $display("Isyn = %0.12f , Influx = %0.12f , Isyn1 = %0.12f , n=%d ", $bitstoshortreal(I_syn),$bitstoshortreal(Influx),$bitstoshortreal(I_syn_1),n);
  //$display("RMtrace = %0f , A = %0f , D = %0f , Inh = %0f , Prel = %0f , Z = %0f , Y = %0f , W = %0f , Isyn = %0.12f , Sm = %0.12f , n=%d ", $bitstoshortreal(RMtrace),$bitstoshortreal(A),$bitstoshortreal(D),$bitstoshortreal(Inh),$bitstoshortreal(Prel),$bitstoshortreal(Z),$bitstoshortreal(Y),$bitstoshortreal(W),$bitstoshortreal(I_syn),$bitstoshortreal(Sm),n);
  //$display("%0f %0f %0f %0f %0f %0f %0f %0f %d", $bitstoshortreal(RMtrace),$bitstoshortreal(A),$bitstoshortreal(D),$bitstoshortreal(Inh),$bitstoshortreal(Prel),$bitstoshortreal(Z),$bitstoshortreal(Y),$bitstoshortreal(W),n);
  //$display("%b",I_syn);
  
  give_reset();
  
end ////////////end for loop with n0
  
  
  
  
for(n1=0; n1<10;n1=n1+1)
begin   
  
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { RMtrace, const_m1bytr};
  rs2 = { RM, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_a = rocc_accel_inst.reg_inst.Registers[destination];
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { RMtrace, const1};
  rs2 = { const_del, reg_a};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  RMtrace_new = rocc_accel_inst.reg_inst.Registers[destination];
  ////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, constm1bytinh};
  rs2 = { RMtrace, A};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_b = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00100;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, const1};
  rs2 = { const_del, reg_b};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Inh_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00101;
  inst = {7'b0000011, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { tp1, tp1};
  rs2 = { tp1, tp1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_c = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset(); 
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00110;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { constm1bytc, A};
  rs2 = { const1bytc, reg_c};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_d = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00111;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { A, const1};
  rs2 = { const_del, reg_d};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  A_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01000;
  inst = {7'b0000011, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { td1, td1};
  rs2 = { td1, td1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("(reg_e)Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_e = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset(); 
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { constm1bytd, D};
  rs2 = { const1bytd, reg_e};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("(reg_f)Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_f = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { D, const1};
  rs2 = { const_del, reg_f};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("(D_new)Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  D_new = rocc_accel_inst.reg_inst.Registers[destination];
  ///////////////////////////////////////////////////////////////////////////
    
  give_reset();  
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { A, D};
  rs2 = { const0, const0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_g_a = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();
  
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01100;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { reg_g_a, Prel};
  rs2 = { const0, const0};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_g = rocc_accel_inst.reg_inst.Registers[destination];
  
    
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { W, const1};
  rs2 = { const_del, reg_g};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  W_new = rocc_accel_inst.reg_inst.Registers[destination];
  //////////////////////////////////////////////////////////
    
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Z, const_m1byt};
  rs2 = { reg_c, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_h = rocc_accel_inst.reg_inst.Registers[destination]; //[op1(Z,-1/t,const1,c)]
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Z, const1};
  rs2 = { const_del, reg_h};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Z_new = rocc_accel_inst.reg_inst.Registers[destination];//[op1(Z,const1,del,h)]
  /////////////////////////////////////////////////////////////////////////////////
  
  give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const1, const1};
  rs2 = { const_del, const_neg1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_i = rocc_accel_inst.reg_inst.Registers[destination];//op1(const1,const1,const-1,del)
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_del, Z};
  rs2 = { reg_i, Y};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Y_new = rocc_accel_inst.reg_inst.Registers[destination];//op1(del,Z,i,Y)
  /////////////////////////////////////////////////////////////////////////////////////

  give_reset();
  
  
        constk0 = I_syn;/////////////
        
        @(posedge clk iff ready === 1 && rst === 0);
        valid = 1;
        destination = 5'b00001;
        inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
        rs1 = { time_const, Y};
        rs2 = { const0, const0};
        @(posedge clk);
        wait(ready === 0);
        //$display("operation ongoing check 1");
        @(posedge clk);
        wait(ready === 1);
        //@(posedge clk);
        //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
        reg_t = rocc_accel_inst.reg_inst.Registers[destination];//op1(time_const,Y,0,0)
    
        give_reset();

        @(posedge clk iff ready === 1 && rst === 0);
        valid = 1;
        destination = 5'b00010;
        constk0 = I_syn;
        inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
        rs1 = { reg_t, W};
        rs2 = { reg_t, constk0};
        @(posedge clk);
        wait(ready === 0);
        //$display("operation ongoing");
        @(posedge clk);
        wait(ready === 1);
        //@(posedge clk);
        //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
        I_syn_new = rocc_accel_inst.reg_inst.Registers[destination];//op1(time_const*Y,W,time_const*Y,kO)
        
        give_reset();
    

  
  /////////////////////////////////////////////////////////////////////////
  
  
   give_reset();
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00001;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Inh, const1};
  rs2 = { const_neg_0_00001, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_j = rocc_accel_inst.reg_inst.Registers[destination];//[op1(Inh,const1,-0.00001,const1)]
    
  
  give_reset();
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00010;
  inst = {7'b0000010, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_neg_0_00007, reg_j};
  rs2 = { const_1_1, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  reg_k = rocc_accel_inst.reg_inst.Registers[destination];//[op2(-0.00007,j,1.1,const1)]
  
    
  give_reset();  


   @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b00011;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const_2_5, const1};
  rs2 = { const__neg_2_5, reg_k};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  p_rel_new = rocc_accel_inst.reg_inst.Registers[destination];//[op1(0.25,const1,-0.25,k)]

  
  if($bitstoshortreal(p_rel_new)>0.25)
    begin
      p_rel_new = const0_25;
    end
    
  else if($bitstoshortreal(p_rel_new)<0)
    begin
      p_rel_new = const0;
    end

////////////////////////////////////////////////

/////////////FXS Syndrome////////////////////////////////
/////////////////////////////////////////////////////////

  
  give_reset(); 
  give_inputs(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { Kfmrp, mkt};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  consta = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { const_del, I_syn};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  constb = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { const0, const0};
  rs2 = { consta, constb};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  const_influx = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 

  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { Influx, const1};
  rs2 = { const_influx, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  Influx_new = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  give_reset(); 
  
  
  @(posedge clk iff ready === 1 && rst === 0);
  valid = 1;
  destination = 5'b01101;
  inst = {7'b0000001, 5'b00001, 5'b00000, 1'b0, 1'b1, 1'b1, destination, 2'b00};
  rs1 = { I_syn, const1};
  rs2 = { Influx_new, const1};
  @(posedge clk);
  wait(ready === 0);
  //$display("operation ongoing");
  @(posedge clk);
  wait(ready === 1);
  //@(posedge clk);
  //$display("Reg[%0d] = %0h (hex), %0f (float)", destination, rocc_accel_inst.reg_inst.Registers[destination], $bitstoshortreal(rocc_accel_inst.reg_inst.Registers[destination]));
  I_syn_1 = rocc_accel_inst.reg_inst.Registers[destination];
  
  
  
  /////////////////////////////////////////////////////



  
  give_reset();  
  
  RMtrace = RMtrace_new;
  Inh = Inh_new;
  A = A_new;
  D = D_new;
  W = W_new;
  Prel = p_rel_new; 
  Z = Z_new;
  Y = Y_new;
  I_syn = I_syn_new;
  Sm = Sm_new;
  Influx = Influx_new;
  
  give_reset();
  
  $display("Isyn = %0.12f , Influx = %0.12f , Isyn1 = %0.12f , n=%d ", $bitstoshortreal(I_syn),$bitstoshortreal(Influx),$bitstoshortreal(I_syn_1),n);
  //$display("RMtrace = %0f , A = %0f , D = %0f , Inh = %0f , Prel = %0f , Z = %0f , Y = %0f , W = %0f , Isyn = %0.12f , Sm = %0.12f , n=%d ", $bitstoshortreal(RMtrace),$bitstoshortreal(A),$bitstoshortreal(D),$bitstoshortreal(Inh),$bitstoshortreal(Prel),$bitstoshortreal(Z),$bitstoshortreal(Y),$bitstoshortreal(W),$bitstoshortreal(I_syn),$bitstoshortreal(Sm),n);
  //$display("%0f %0f %0f %0f %0f %0f %0f %0f %d", $bitstoshortreal(RMtrace),$bitstoshortreal(A),$bitstoshortreal(D),$bitstoshortreal(Inh),$bitstoshortreal(Prel),$bitstoshortreal(Z),$bitstoshortreal(Y),$bitstoshortreal(W),n);
  //RMtrace,A,D,Inh,Prel,Z,Y,W
  //$display("%b",I_syn);
  
end //////end for loop with n1


  

end ////// end for loop with n
  
   
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
//$display("RESET START @%0t", $time);
rst = 1;
valid = 0;
repeat(2) @(posedge clk);
rst = 0;
//$display("RESET END @%0t", $time);
endtask : give_reset
  
/*initial begin
 #3000;
 $finish; 
end*/



endmodule: TBFXS

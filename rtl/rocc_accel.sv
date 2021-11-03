module rocc_accel
#(
    parameter INST_WIDTH = 32,
    parameter DATA_WIDTH = 64
 ) 
(   
    clk,
    rst,
    inst,
    rs1,
    rs2,
    valid,
    ready
);

input clk;
input rst;

input [INST_WIDTH-1:5] inst;
input [DATA_WIDTH-1:0] rs1;
input [DATA_WIDTH-1:0] rs2;

input valid;
output ready;


reg ready_reg;

parameter  IF = 3'b000;
parameter  ID = 3'b001;
parameter  EXE_OP1 = 3'b010;
parameter  EXE_OP2 = 3'b011;
parameter  EXE_OP3 = 3'b100;
parameter  EXE_OP4 = 3'b101;
parameter  EXE_OP5 = 3'b110;
parameter  WB = 3'b111;



reg [2:0] current_state;

reg [31:0] oper1_op1, oper2_op1, oper3_op1, oper4_op1;
reg op1_inp_STB, op1_BUSY_reg;

reg [31:0] result_op1;

reg op1_out_STB;
reg out_op1_BUSY;
reg [31:0] oper1_op2, oper2_op2, oper3_op2, oper4_op2;
reg op2_inp_STB, op2_BUSY_reg;

reg [31:0] result_op2;

reg op2_out_STB;
reg out_op2_BUSY;





reg [31:0] oper1_op3, oper2_op3, oper3_op3, oper4_op3;
reg input_op3;
reg op3_inp_STB, op3_BUSY_reg;

reg [31:0] result_op3;

reg op3_out_STB;
reg out_op3_BUSY;




reg [31:0] oper1_op4, oper2_op4, oper3_op4, oper4_op4;
reg input_op4;
reg op4_inp_STB, op4_BUSY_reg;

reg [31:0] result_op4;

reg op4_out_STB;
reg out_op4_BUSY;




reg [31:0] oper1_op5, oper2_op5, oper3_op5, oper4_op5;
reg input_op5;
reg op5_inp_STB, op5_BUSY_reg;

reg [31:0] result_op5;

reg op5_out_STB;
reg out_op5_BUSY;




operation1 op1_inst(
    .clk(clk),
    .rst(rst),
    .input_a(oper1_op1),
    .input_b(oper2_op1),
    .input_c(oper3_op1),
    .input_d(oper4_op1),
    .op1_input_STB(op1_inp_STB),
    .op1_BUSY(op1_BUSY_reg),
    .output_result(result_op1),
    .op1_output_STB(op1_out_STB),
    .output_module_BUSY(out_op1_BUSY)
   );
   

operation2 op2_inst(
    .clk(clk),
    .rst(rst),
    .input_a(oper1_op2),
    .input_b(oper2_op2),
    .input_c(oper3_op2),
    .input_d(oper4_op2),
    .op2_input_STB(op2_inp_STB),
    .op2_BUSY(op2_BUSY_reg),
    .output_result(result_op2),
    .op2_output_STB(op2_out_STB),
    .output_module_BUSY(out_op2_BUSY)
   );

operation3 op3_inst(
    .clk(clk),
    .rst(rst),
    .input_tp(input_op3),
    .op3_input_STB(op3_inp_STB),
    .op3_BUSY(op3_BUSY_reg),
    .output_x(result_op3),
    .op3_output_STB(op3_out_STB),
    .output_module_BUSY(out_op3_BUSY)
);

operation4 op4_inst(
    .clk(clk),
    .rst(rst),
    .input_a(oper1_op4),
    .input_b(oper2_op4),
    .input_c(oper3_op4),
    .input_d(oper4_op4),
    .op4_input_STB(op4_inp_STB),
    .op4_BUSY(op4_BUSY_reg),
    .output_result(result_op4),
    .op4_output_STB(op4_out_STB),
    .output_module_BUSY(out_op4_BUSY)
);

operation5 op5_inst(
    .clk(clk),
    .rst(rst),
    .input_a(oper1_op5),
    .input_b(oper2_op5),
    .input_c(oper3_op5),
    .input_d(oper4_op5),
    .op5_input_STB(op5_inp_STB),
    .op5_BUSY(op5_BUSY_reg),
    .output_result(result_op5),
    .op5_output_STB(op5_out_STB),
    .output_module_BUSY(out_op5_BUSY)
);

reg [31:0] ReadData1, ReadData2, ReadData3, ReadData4;
reg [4:0] ReadReg1, ReadReg2, ReadReg3, ReadReg4;

reg [4:0] WriteReg;
reg [31:0] WriteData;
reg RegWrite;

RegisterFile 
#(.WORD_SIZE(32), .NUMBER_OF_REGISTERS(32))
reg_inst(
         .ReadData1(ReadData1), 
         .ReadData2(ReadData2), 
         .ReadData3(ReadData3),
         .ReadData4(ReadData4), 
         
         .ReadReg1(ReadReg1), 
         .ReadReg2(ReadReg2), 
         .ReadReg3(ReadReg3),
         .ReadReg4(ReadReg4), 
         
         
         
         .WriteReg(WriteReg), 
         .WriteData(WriteData), 
         .RegWrite(RegWrite), 
         .clk(clk)   
        );





reg [6:0] funct7;
reg [4:0] rs2_reg;
reg [4:0] rs1_reg;
reg xd;
reg xs1;
reg xs2;
reg [4:0] rd;
reg [1:0] opcode;

reg[63:0] rs1_oper;
reg[63:0] rs2_oper;


reg[31:0] result;


always@(posedge clk)//always
begin
if(!rst)
begin
    case(current_state)
      
    IF:
      begin
        ready_reg <= 1;
        if(valid && ready_reg)begin
          ready_reg <= 0;
          {funct7, rs2_reg, rs1_reg, xd, xs1, xs2, rd, opcode} <= inst[31:5];
           rs1_oper <= rs1;
           rs2_oper <= rs2;
           current_state <= ID;
        end
      end
        

    ID:
    begin//
      case(funct7)
                7'b0000001 : 
                begin
                    oper1_op1 <= rs1_oper[63:32];
                    oper2_op1 <= rs1_oper[31:0];
                    oper3_op1 <= rs2_oper[63:32];
                    oper4_op1 <= rs2_oper[31:0];
                    input_op3 <= rs1_oper[63];
                    
                    op1_inp_STB <= 1;
 
                    if(op1_inp_STB && op1_BUSY_reg) 
                    begin
                      op1_inp_STB <= 0;
                      current_state <= EXE_OP1;
                    end
                end
                
                7'b0000010 : 
                begin
                    oper1_op2 <= rs1_oper[63:32];
                    oper2_op2 <= rs1_oper[31:0];
                    oper3_op2 <= rs2_oper[63:32];
                    oper4_op2 <= rs2_oper[31:0];
                    
                    op2_inp_STB <= 1;
 
                    if(op2_inp_STB && op2_BUSY_reg) 
                    begin
                      op2_inp_STB <= 0;
                      current_state <= EXE_OP2;
                    end
                end
                
                7'b0000011 : 
                begin
                    oper1_op3 <= rs2_oper[63:32];
                    oper2_op3 <= rs1_oper[31:0];
                    oper3_op3 <= rs2_oper[63:32];
                    oper4_op3 <= rs2_oper[31:0];
                    input_op3 <= rs2_oper[63];
                    
                    op3_inp_STB <= 1;
 
                    if(op3_inp_STB && op3_BUSY_reg) 
                    begin
                      op3_inp_STB <= 0;
                      current_state <= EXE_OP3;
                    end
                end
                
                7'b0000100 : 
                begin
                    oper1_op4 <= rs2_oper[63:32];
                    oper2_op4 <= rs1_oper[31:0];
                    oper3_op4 <= rs2_oper[63:32];
                    oper4_op4 <= rs2_oper[31:0];
                    
                    op4_inp_STB <= 1;
 
                    if(op4_inp_STB && op4_BUSY_reg) 
                    begin
                      op4_inp_STB <= 0;
                      current_state <= EXE_OP4;
                    end
                end
                
                7'b0000101 : 
                begin
                    oper1_op5 <= rs2_oper[63:32];
                    oper2_op5 <= rs1_oper[31:0];
                    oper3_op5 <= rs2_oper[63:32];
                    oper4_op5 <= rs2_oper[31:0];
                                        
                    op5_inp_STB <= 1;
 
                    if(op5_inp_STB && op5_BUSY_reg) 
                    begin
                      op5_inp_STB <= 0;
                      current_state <= EXE_OP5;
                    end
                end
                
                
      
      endcase 

      
    end//
       
  

    EXE_OP1:
       begin
           out_op1_BUSY <= 0;
           if (op1_out_STB && !out_op1_BUSY)
           begin//
                out_op1_BUSY         <= 1;
                result               <= result_op1;
                current_state        <= WB;
           end//
       end 
       
    EXE_OP2:
       begin
           out_op2_BUSY <= 0;
           if (op2_out_STB && !out_op2_BUSY)
           begin//
                out_op2_BUSY         <= 1;
                result               <= result_op2;
                current_state        <= WB;
           end//
       end   
       
    
    EXE_OP3:
       begin
           out_op3_BUSY <= 0;
           if (op3_out_STB && !out_op3_BUSY)
           begin//
                out_op3_BUSY         <= 1;
                result               <= result_op3;
                current_state        <= WB;
           end//
       end   
       
    EXE_OP4:
       begin
           out_op4_BUSY <= 0;
           if (op4_out_STB && !out_op4_BUSY)
           begin//
                out_op4_BUSY         <= 1;
                result               <= result_op4;
                current_state        <= WB;
           end//
       end
       
    EXE_OP5:
       begin
           out_op5_BUSY <= 0;
           if (op5_out_STB && !out_op5_BUSY)
           begin//
                out_op5_BUSY         <= 1;
                result               <= result_op5;
                current_state        <= WB;
           end//
       end   
       
      
    
    WB:
       begin
           RegWrite          <= 1;
           WriteReg          <= rd;
           WriteData         <= result;
           current_state     <= IF;
       end
    endcase

end



if(rst)
begin
    ready_reg           <= 1; //op status ready - 1
    
    op1_inp_STB         <= 0; //no valid input to operation1 module
    op2_inp_STB         <= 0; //no valid input to operation2 module
    op3_inp_STB         <= 0; //no valid input to operation3 module
    op4_inp_STB         <= 0; //no valid input to operation4 module
    op5_inp_STB         <= 0; //no valid input to operation5 module
    RegWrite            <= 0; //no writing to register file

    current_state       <= IF;
end
end//always


assign ready = ready_reg;

endmodule : rocc_accel

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


typedef enum logic[2:0] 
{
  ID = 0,
  EXE = 1,
  WB = 2
}
state_t;

state_t current_state;

reg [31:0] oper1_op1, oper2_op1, oper3_op1, oper4_op1;
reg op1_inp_STB, op1_BUSY_reg;

reg [31:0] result_op1;

reg op1_out_STB;
reg out_op1_BUSY;



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
    case(current_state)

    ID:
    begin
        ready_reg <= 1;
        
        if(valid && ready_reg)
        
        begin//
            ready_reg <= 0;
            
            {funct7, rs2_reg, rs1_reg, xd, xs1, xs2, rd, opcode} <= inst[31:5];
            rs1_oper <= rs1;
            rs2_oper <= rs2;
            
            case(opcode)
                0:
                begin
                   // 
                end
            endcase

            case(xd)
                0:
                begin
                   // 
                end
            endcase

            case(xs1)
                1:
                begin
                   // 
                end
            endcase

            case(xs2)
                1:
                begin
                   // 
                end
            endcase

            case(rs1_reg)
                5'b00000:
                begin
                   // 
                end
            endcase

            case(rs2_reg)
                5'b00001:
                begin
                   // 
                end
            endcase

            
            case(funct7)
                7'b0000001 : 
                begin
                    oper1_op1 <= rs1_oper[63:32];
                    oper2_op1 <= rs1_oper[31:0];
                    oper3_op1 <= rs2_oper[63:32];
                    oper4_op1 <= rs2_oper[31:0];
                end
                //
                //...
            endcase 

            op1_inp_STB <= 1;

            if(op1_inp_STB && !op1_BUSY) 
            begin//
                op1_inp_STB <= 0;
                current_state <= EX;
            end//
        
        end//
    
    end

    EX:
       begin
           out_op1_BUSY <= 0;
           if (op1_out_STB && !out_op1_BUSY)
           begin//
                out_op1_BUSY         <= 1;
                result               <= result_op1;
                current_state        <= WB;
           end//
       end 
    
    WB:
       begin
           RegWrite          <= 1;
           WriteReg          <= rd;
           WriteData         <= result;
           cuurent_state     <= ID;
       end
    endcase

end//always


always@(posedge clk)
if(rst)
begin
    ready               <= 0; //op status ready - 0
    
    op1_inp_STB         <= 0; //no valid input to operation1 module
    RegWrite            <= 0; //no writing to register file

    current_state       <= ID;
end

endmodule : rocc_accel
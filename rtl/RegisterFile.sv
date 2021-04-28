/**
  * Register File module
  *
  * Output Ports:
  *   - ReadData1: 32 bit registered output
  *   - ReadData2: 32 bit registered output
  *   - ReadData3: 32 bit registered output
  *   - ReadData4: 32 bit registered output
  * 
  * Note- If Read Addresses i.e., if ReadReg1/ReadReg2/ReadReg3 = 0 then Read Data will always be 0.
  * 
  * Input ports:
  * 	- ReadReg1:  5-Bit address to select a register to be read
  *		- ReadReg2:  5-Bit address to select a register to be read
  *   - ReadReg3:  5-Bit address to select a register to be read
  *   - ReadReg4:  5-Bit address to select a register to be read

  *		- WriteReg:  5-Bit address to select a register to be written
  *		- WriteData: 32-Bit write input port
  *		- RegWrite:  1-Bit control input signal
  *
  */

module RegisterFile #(parameter WORD_SIZE = 32, NUMBER_OF_REGISTERS = 32)
(ReadData1, ReadData2, ReadData3, ReadData4, ReadReg1, ReadReg2, ReadReg3, ReadReg4, WriteReg, WriteData, RegWrite, clk);
  
  
  localparam ADDR_WIDTH = $clog2(NUMBER_OF_REGISTERS); //Cannot be changed from outside
  
  output reg [WORD_SIZE-1:0] ReadData1, ReadData2, ReadData3, ReadData4;
  input wire [ADDR_WIDTH-1:0] ReadReg1, ReadReg2, ReadReg3, ReadReg4; 
  input wire [ADDR_WIDTH-1:0] WriteReg;
  input wire [WORD_SIZE-1:0] WriteData;
  input wire RegWrite; 
  input wire clk;

  reg [WORD_SIZE-1:0] Registers[NUMBER_OF_REGISTERS - 1:0];

  always @ ( ReadReg1, ReadReg2, ReadReg3, ReadReg4 )
  begin
    ReadData1 <= (ReadReg1 == 0)? 32'b0 : Registers[ReadReg1];
    ReadData2 <= (ReadReg2 == 0)? 32'b0 : Registers[ReadReg2];
    ReadData3 <= (ReadReg3 == 0)? 32'b0 : Registers[ReadReg3];
    ReadData4 <= (ReadReg4 == 0)? 32'b0 : Registers[ReadReg4];
  end

  always @ ( posedge clk )
  begin
    if(RegWrite)
      begin
        Registers[WriteReg] <= WriteData;
      end
  end

endmodule : RegisterFile
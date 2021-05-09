library verilog;
use verilog.vl_types.all;
entity RegisterFile is
    generic(
        WORD_SIZE       : integer := 32;
        NUMBER_OF_REGISTERS: integer := 32
    );
    port(
        ReadData1       : out    vl_logic_vector;
        ReadData2       : out    vl_logic_vector;
        ReadData3       : out    vl_logic_vector;
        ReadData4       : out    vl_logic_vector;
        ReadReg1        : in     vl_logic_vector;
        ReadReg2        : in     vl_logic_vector;
        ReadReg3        : in     vl_logic_vector;
        ReadReg4        : in     vl_logic_vector;
        WriteReg        : in     vl_logic_vector;
        WriteData       : in     vl_logic_vector;
        RegWrite        : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WORD_SIZE : constant is 1;
    attribute mti_svvh_generic_type of NUMBER_OF_REGISTERS : constant is 1;
end RegisterFile;

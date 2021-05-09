library verilog;
use verilog.vl_types.all;
entity rocc_accel is
    generic(
        INST_WIDTH      : integer := 32;
        DATA_WIDTH      : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inst            : in     vl_logic_vector;
        rs1             : in     vl_logic_vector;
        rs2             : in     vl_logic_vector;
        valid           : in     vl_logic;
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INST_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end rocc_accel;

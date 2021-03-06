library verilog;
use verilog.vl_types.all;
entity adder is
    generic(
        get_a_and_b     : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        unpack          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        special_cases   : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        align           : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        add_0           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        add_1           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        normalise_1     : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        normalise_2     : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        round           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        pack            : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1);
        put_z           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi0)
    );
    port(
        input_a         : in     vl_logic_vector(31 downto 0);
        input_b         : in     vl_logic_vector(31 downto 0);
        adder_input_STB : in     vl_logic;
        adder_BUSY      : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        output_sum      : out    vl_logic_vector(31 downto 0);
        adder_output_STB: out    vl_logic;
        output_module_BUSY: in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of get_a_and_b : constant is 1;
    attribute mti_svvh_generic_type of unpack : constant is 1;
    attribute mti_svvh_generic_type of special_cases : constant is 1;
    attribute mti_svvh_generic_type of align : constant is 1;
    attribute mti_svvh_generic_type of add_0 : constant is 1;
    attribute mti_svvh_generic_type of add_1 : constant is 1;
    attribute mti_svvh_generic_type of normalise_1 : constant is 1;
    attribute mti_svvh_generic_type of normalise_2 : constant is 1;
    attribute mti_svvh_generic_type of round : constant is 1;
    attribute mti_svvh_generic_type of pack : constant is 1;
    attribute mti_svvh_generic_type of put_z : constant is 1;
end adder;

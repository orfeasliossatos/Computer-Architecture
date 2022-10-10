library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pipeline_reg_DE is
    port(
        clk           : in  std_logic;
        reset_n       : in  std_logic;
        a_in          : in  std_logic_vector(31 downto 0);
        b_in          : in  std_logic_vector(31 downto 0);
        d_imm_in      : in  std_logic_vector(31 downto 0);
        sel_b_in      : in  std_logic;
        op_alu_in     : in  std_logic_vector(5 downto 0);
        read_in       : in  std_logic;
        write_in      : in  std_logic;
        sel_pc_in     : in  std_logic;
        branch_op_in  : in  std_logic;
        sel_mem_in    : in  std_logic;
        rf_wren_in    : in  std_logic;
        mux_in        : in  std_logic_vector(4 downto 0);
        next_addr_in  : in  std_logic_vector(15 downto 0);
        a_out         : out std_logic_vector(31 downto 0);
        b_out         : out std_logic_vector(31 downto 0);
        d_imm_out     : out std_logic_vector(31 downto 0);
        sel_b_out     : out std_logic;
        op_alu_out    : out std_logic_vector(5 downto 0);
        read_out      : out std_logic;
        write_out     : out std_logic;
        sel_pc_out    : out std_logic;
        branch_op_out : out std_logic;
        sel_mem_out   : out std_logic;
        rf_wren_out   : out std_logic;
        mux_out       : out std_logic_vector(4 downto 0);
        next_addr_out : out std_logic_vector(15 downto 0)
    );
end pipeline_reg_DE;

architecture synth of pipeline_reg_DE is
    signal a_reg         : std_logic_vector(31 downto 0);
    signal b_reg         : std_logic_vector(31 downto 0);
    signal d_imm_reg     : std_logic_vector(31 downto 0);
    signal sel_b_reg     : std_logic;
    signal op_alu_reg    : std_logic_vector(5 downto 0);
    signal read_reg      : std_logic;
    signal write_reg     : std_logic;
    signal sel_pc_reg    : std_logic;
    signal branch_op_reg : std_logic;
    signal sel_mem_reg   : std_logic;
    signal rf_wren_reg   : std_logic;
    signal mux_reg       : std_logic_vector(4 downto 0);
    signal next_addr_reg : std_logic_vector(15 downto 0);

begin
    a_out         <= a_reg;
    b_out         <= b_reg;
    d_imm_out     <= d_imm_reg;
    sel_b_out     <= sel_b_reg;
    op_alu_out    <= op_alu_reg;
    read_out      <= read_reg;
    write_out     <= write_reg;
    sel_pc_out    <= sel_pc_reg;
    branch_op_out <= branch_op_reg;
    sel_mem_out   <= sel_mem_reg;
    rf_wren_out   <= rf_wren_reg;
    mux_out       <= mux_reg;
    next_addr_out <= next_addr_reg;

    process(reset_n, clk)
    begin
        if (reset_n = '0') then
            a_reg         <= (others => '0');
            b_reg         <= (others => '0');
            d_imm_reg     <= (others => '0');
            sel_b_reg     <= '0';
            op_alu_reg    <= (others => '0');
            read_reg      <= '0';
            write_reg     <= '0';
            sel_pc_reg    <= '0';
            branch_op_reg <= '0';
            sel_mem_reg   <= '0';
            rf_wren_reg   <= '0';
            mux_reg       <= (others => '0');
            next_addr_reg <= (others => '0');
        elsif (rising_edge(clk)) then
            a_reg         <= a_in;
            b_reg         <= b_in;
            d_imm_reg     <= d_imm_in;
            sel_b_reg     <= sel_b_in;
            op_alu_reg    <= op_alu_in;
            read_reg      <= read_in;
            write_reg     <= write_in;
            sel_pc_reg    <= sel_pc_in;
            branch_op_reg <= branch_op_in;
            sel_mem_reg   <= sel_mem_in;
            rf_wren_reg   <= rf_wren_in;
            mux_reg       <= mux_in;
            next_addr_reg <= next_addr_in;
        end if;
    end process;

end synth;

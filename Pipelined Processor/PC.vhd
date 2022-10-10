library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PC is
    port(
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        sel_a     : in  std_logic;
        sel_imm   : in  std_logic;
        branch    : in  std_logic;
        a         : in  std_logic_vector(15 downto 0);
        d_imm     : in  std_logic_vector(15 downto 0);
        e_imm     : in  std_logic_vector(15 downto 0);
        pc_addr   : in  std_logic_vector(15 downto 0);
        addr      : out std_logic_vector(15 downto 0);
        next_addr : out std_logic_vector(15 downto 0)
    );
end PC;

architecture synth of PC is
    signal reg   : std_logic_vector(15 downto 0);
    signal mux_1 : std_logic_vector(15 downto 0);
    signal mux_2 : std_logic_vector(15 downto 0);
    signal mux_3 : std_logic_vector(15 downto 0);
begin
    addr      <= mux_3;
    next_addr <= reg;

    mux_1 <= reg when branch = '0' else pc_addr;
    mux_2 <= conv_std_logic_vector(4, 16) when branch = '0' else (e_imm + 4);

    process(sel_imm, sel_a, mux_1, mux_2, a, d_imm)
    begin
        if (sel_imm = '0' and sel_a = '0') then
            mux_3 <= mux_1 + mux_2;
        elsif (sel_imm = '0' and sel_a = '1') then
            mux_3 <= conv_std_logic_vector(4, 16) + a;
        elsif (sel_imm = '1' and sel_a = '0') then
            mux_3 <= d_imm(13 downto 0) & "00";
        else
            mux_3 <= (others => '0');
        end if;
    end process;

    process(reset_n, clk)
    begin
        if (reset_n = '0') then
            reg <= (others => '0');
        elsif (rising_edge(clk)) then
            reg <= mux_3;
        end if;
    end process;
end synth;

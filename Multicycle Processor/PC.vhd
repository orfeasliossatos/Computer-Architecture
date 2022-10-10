library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
signal next_addr, curr_addr, addr16 : std_logic_vector(15 downto 0);
begin

addr16 <= curr_addr(15 downto 0);
-- only the 16 least significants bits are registered


next_addr <= addr16 when en = '0' else
		a when sel_a = '1' else
		imm(13 downto 0) & "00" when sel_imm = '1' else 
		std_logic_vector(unsigned(addr16) + unsigned(imm)) when add_imm = '1' else 
		std_logic_vector(unsigned(addr16) + to_unsigned(4, 16));

dff : process(clk, reset_n) is
begin
	if reset_n = '0' then curr_addr <= (others => '0');
	elsif rising_edge(clk) then
		curr_addr <= next_addr;
	end if;
end process dff;

addr <= x"0000" & curr_addr(15 downto 2) & "00"; -- then addr is always valid
		
end synth;

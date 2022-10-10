library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is

	-- Singals
	signal s_A33		: std_logic_vector(32 downto 0);
	signal s_B33		: std_logic_vector(32 downto 0);

	signal s_BInv 		: std_logic_vector(31 downto 0);
	signal s_Sum 		: std_logic_vector(32 downto 0);

	constant all_zeros : std_logic_vector(31 downto 0) := (others => '0');
begin

	-- Signals
	s_BInv <= b when sub_mode = '0' else not(b);
	r <= s_Sum(31 downto 0);
	zero  <= '1' when s_Sum(31 downto 0) = all_zeros else '0';
	
	s_A33 <= '0' & a(31 downto 0);
	s_B33 <= '0' & s_BInv(31 downto 0);

	-- Addition / Subtraction
	s_Sum <= std_logic_vector(unsigned(s_A33) + unsigned(s_B33)) when sub_mode = '0' 
			else std_logic_vector(unsigned(s_A33) + unsigned(s_B33) + 1);
		
	-- Carry out
	carry <= s_Sum(32);
	
end synth;

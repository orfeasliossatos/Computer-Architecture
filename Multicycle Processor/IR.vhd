library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is
signal next_state, curr_state : std_logic_vector(31 downto 0);

begin

next_state <= D when enable = '1' else curr_state;

dff : process(clk) is
begin
	if rising_edge(clk) then 
		curr_state <= next_state;
	end if;
end process dff;

q <= curr_state;
end synth;

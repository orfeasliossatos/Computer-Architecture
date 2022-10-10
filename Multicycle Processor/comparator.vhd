library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port(
        a_31    : in  std_logic;
        b_31    : in  std_logic;
        diff_31 : in  std_logic;
        carry   : in  std_logic;
        zero    : in  std_logic;
        op      : in  std_logic_vector(2 downto 0);
        r       : out std_logic
    );
end comparator;

architecture synth of comparator is
begin

comparator_pro : process (op, a_31, b_31, diff_31, carry, zero) IS
begin
case op is
	WHEN "001" => r <= (a_31 And Not(b_31)) or ((not(a_31 xor b_31)) AND (diff_31 or zero));
	WHEN "010" => r <= (not(a_31) and b_31) or ((not(a_31 xor b_31)) and (not(diff_31) and not(zero)));
	WHEN "011" => r <= not(zero);
	WHEN "100" => r <= zero;
	WHEN "101" => r <= not(carry) or zero;
	WHEN "110" => r <= carry and not(zero);
	WHEN OTHERS => r <= zero;
end case;
end process comparator_pro;
end synth;

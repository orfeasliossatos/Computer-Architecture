architecture rtl of bcd_to_7seg is

	signal s_disp : std_logic_vector(7 downto 0);

begin
	-- a 
	s_disp(7) <= '1' when bcd = "0000"
			or bcd = "0010"
			or bcd = "0011"
			or bcd = "0101"
			or bcd = "0110"
			or bcd = "0111"
			or bcd = "1000"
			or bcd = "1001" else '0';

	-- b
	s_disp(6) <= '1' when bcd = "0000"
			or bcd = "0001"
			or bcd = "0010"
			or bcd = "0011"
			or bcd = "0100"
			or bcd = "0111"
			or bcd = "1000"
			or bcd = "1001" else '0';

	-- c
	s_disp(5) <= '1' when bcd = "0000"
			or bcd = "0001"
			or bcd = "0011"
			or bcd = "0100"
			or bcd = "0101"
			or bcd = "0110"
			or bcd = "0111"
			or bcd = "1000"
			or bcd = "1001" else '0';
	-- d
	s_disp(4) <= '1' when bcd = "0000"
			or bcd = "0010"
			or bcd = "0011"
			or bcd = "0101"
			or bcd = "0110"
			or bcd = "1000"
			or bcd = "1001" else '0';
	-- e
	s_disp(3) <= '1' when bcd = "0000"
			or bcd = "0010"
			or bcd = "0110"
			or bcd = "1000" else '0';

	-- f
	s_disp(2) <= '1' when bcd = "0000"
			or bcd = "0100"
			or bcd = "0101"
			or bcd = "0110"
			or bcd = "1000"
			or bcd = "1001" else '0';

	-- g
	s_disp(1) <= '1' when bcd = "0010"
			or bcd = "0011"
			or bcd = "0100"
			or bcd = "0101"
			or bcd = "0110"
			or bcd = "1000"
			or bcd = "1001" else '0';

	-- p
	s_disp(0) <= '1' when point_on = '1' else '0';

	disp <= s_disp when en = '1' else "00000000";
end architecture rtl;


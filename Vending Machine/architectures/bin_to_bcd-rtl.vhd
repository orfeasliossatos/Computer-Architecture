architecture rtl of bin_to_bcd is
    --It is guaranteed that bin never exceeds two digits, i.e., 99.
	
	-- Signals --
	signal s_u_bcd : std_logic_vector(3 downto 0);
	signal s_l_bcd : std_logic_vector(7 downto 0);
	signal s_u_bcd10 : unsigned(7 downto 0);
	signal s_bin : unsigned(7 downto 0);
begin
	
	s_bin <= unsigned(bin);
	
	s_u_bcd <= "1001" when s_bin >= 90 else
			"1000" when s_bin >= 80 else
			"0111" when s_bin >= 70 else
			"0110" when s_bin >= 60 else	
			"0101" when s_bin >= 50 else
			"0100" when s_bin >= 40 else
			"0011" when s_bin >= 30 else
			"0010" when s_bin >= 20 else
			"0001" when s_bin >= 10 else
			"0000";
	u_bcd <= s_u_bcd;

	s_u_bcd10 <= to_unsigned(90, 8) when s_bin >= 90 else
			to_unsigned(80, 8) when s_bin >= 80 else
			to_unsigned(70, 8) when s_bin >= 70 else
			to_unsigned(60, 8) when s_bin >= 60 else	
			to_unsigned(50, 8) when s_bin >= 50 else
			to_unsigned(40, 8) when s_bin >= 40 else
			to_unsigned(30, 8) when s_bin >= 30 else
			to_unsigned(20, 8) when s_bin >= 20 else
			to_unsigned(10, 8) when s_bin >= 10 else
			to_unsigned(0, 8);
	s_l_bcd <= std_logic_vector(s_bin - s_u_bcd10);
	l_bcd <= s_l_bcd(3 downto 0);
	
end architecture rtl;

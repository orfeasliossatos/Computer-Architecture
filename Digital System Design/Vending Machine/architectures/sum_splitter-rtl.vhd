architecture rtl of sum_splitter is	

	-- Signal --
	signal s_frac : std_logic_vector(15 downto 0);
	signal s_frac6shift : std_logic_vector(15 downto 0);
	signal s_frac5shift : std_logic_vector(15 downto 0);
	signal s_frac2shift : std_logic_vector(15 downto 0);
	signal s_frac16bits : std_logic_vector(15 downto 0);
begin
	-- Whole part --
	whole <= sum(15 downto 7);

	-- Fractional part --
	
	s_frac <= "000000000" & sum(6 downto 0);
	
	s_frac6shift <= s_frac(9 downto 0) & "000000";
	s_frac5shift <= s_frac(10 downto 0) & "00000";
	s_frac2shift <= s_frac(13 downto 0) & "00"; 

	s_frac16bits <= std_logic_vector(unsigned(s_frac6shift) + unsigned(s_frac5shift) + unsigned(s_frac2shift));
	frac <= s_frac16bits(13 downto 7);

end architecture rtl;

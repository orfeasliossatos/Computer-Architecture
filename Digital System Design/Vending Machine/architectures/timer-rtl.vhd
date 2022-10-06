architecture rtl of timer is

	signal s_curr_tick 	: unsigned(31 downto 0) := to_unsigned(0, 32);
	signal s_curr_sec 	: unsigned(4 downto 0)  := to_unsigned(0, 5);
	signal s_done 		: std_logic := '0';
	signal s_half_freq	: unsigned(31 downto 0);
begin
	s_half_freq <= "0" & to_unsigned(FCLK, 32)(31 downto 1);


	done <= '1' when s_done = '1' else '0';
	pulse <= '1' when s_curr_tick >= s_half_freq else '0';

	

	tick : process(clk) is
	begin
		if(rising_edge(clk)) then
			if(clear = '1') then
				s_curr_tick	<= to_unsigned(0, 32);
				s_curr_sec 	<= to_unsigned(0, 5);
				s_done		<= '0';
			elsif(en = '1') then
				s_curr_tick	<= s_curr_tick + 1;
				if(s_curr_tick = to_unsigned(FCLK - 1, 32)) then
					s_curr_tick 	<= to_unsigned(0, 32);
					s_curr_sec 	<= s_curr_sec + 1;
				end if;

				if(s_curr_sec >= unsigned(timeout)) then
					s_done <= '1';
				end if;
			end if;
		end if;
	end process tick;

end architecture rtl;

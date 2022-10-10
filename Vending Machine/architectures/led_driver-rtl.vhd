architecture rtl of led_driver is

	-- Constants --
	constant fr: std_logic_vector(107 downto 0) :=
		  	"000000000000" & 
	        	"000000000000" & 
			"000011100000" & --3
			"000010010000" & --4
			"000011011000" & --5
			"000010010000" & --6
			"000010010100" & --7
			"000000000000" & 
			"000000000000";  

	constant drink: std_logic_vector(107 downto 0) :=
		  	"000000000000" &
	        	"000000000000" & 
			"001000000000" & --3
			"001101000100" & --4
			"111110111101" & --5
			"101101101110" & --6
			"111101101101" & --7
			"000000000000" &
			"000000000000";

	constant x_new: std_logic_vector(107 downto 0) :=
		  	"100000011100" &
	        	"000100010100" &
			"000000011100" &
			"010000010000" &
			"001000011100" &
			"010000000000" &
			"001001110101" &
			"100001010111" &
			"000101010111";

	constant cup: std_logic_vector(107 downto 0) :=
		  	"000000000000" &
	        	"000000000000" &
			"000000000000" &
			"000011000111" &
			"000010101101" &
			"000010101111" &
			"000011111100" &
			"000000000100" &
			"000000000000";

	constant ok: std_logic_vector(107 downto 0) :=
		  	"000000000000" &
	        	"000000000000" &
			"000001010100" &
			"000010110100" &
			"000010111000" &
			"000010110100" &
			"000001010100" &
			"000000000000" &
			"000000000000";

	constant donate: std_logic_vector(107 downto 0) :=
		  	"001011100000" &
	        	"010110100000" &
			"010110111100" &
			"010100001010" &
			"001001111101" &
			"001000111111" &
			"111001011100" &
			"101001111011" &
			"111000000000";

	constant zero : std_logic_vector(107 downto 0) :=
			"000000000000" &
	        	"000000000000" &
			"000000000000" &
			"000000000000" &
			"000000000000" &
			"000000000000" &
			"000000000000" &
			"000000000000" &
			"000000000000";

	-- Signals --
	signal s_progress_leds : std_logic_vector(107 downto 0);
	signal s_change_leds : std_logic_vector(107 downto 0);
	signal s_count_2_thermo : std_logic_vector(8 downto 0);
	signal s_count_1_thermo : std_logic_vector(8 downto 0);
	signal s_count_05_thermo : std_logic_vector(8 downto 0);
	signal s_count_02_thermo : std_logic_vector(8 downto 0);


begin

	s_count_2_thermo <= 	"000000000" when change_count_2 = "00000" else
				"000000001" when change_count_2 = "00001" else
				"000000011" when change_count_2 = "00010" else
				"000000111" when change_count_2 = "00011" else
				"000001111" when change_count_2 = "00100" else  
				"000011111" when change_count_2 = "00101" else  
				"000111111" when change_count_2 = "00110" else  
				"001111111" when change_count_2 = "00111" else  
				"011111111" when change_count_2 = "01000" else  
				"111111111" when change_count_2 = "01001" else "000000000";

	s_count_1_thermo <= 	"000000000" when change_count_1 = "00000" else
				"000000001" when change_count_1 = "00001" else
				"000000011" when change_count_1 = "00010" else
				"000000111" when change_count_1 = "00011" else
				"000001111" when change_count_1 = "00100" else  
				"000011111" when change_count_1 = "00101" else  
				"000111111" when change_count_1 = "00110" else  
				"001111111" when change_count_1 = "00111" else  
				"011111111" when change_count_1 = "01000" else  
				"111111111" when change_count_1 = "01001" else "000000000";

	s_count_05_thermo <= 	"000000000" when change_count_05 = "00000" else
				"000000001" when change_count_05 = "00001" else
				"000000011" when change_count_05 = "00010" else
				"000000111" when change_count_05 = "00011" else
				"000001111" when change_count_05 = "00100" else  
				"000011111" when change_count_05 = "00101" else  
				"000111111" when change_count_05 = "00110" else  
				"001111111" when change_count_05 = "00111" else  
				"011111111" when change_count_05 = "01000" else  
				"111111111" when change_count_05 = "01001" else "000000000";

	s_count_02_thermo <= 	"000000000" when change_count_02 = "00000" else
				"000000001" when change_count_02 = "00001" else
				"000000011" when change_count_02 = "00010" else
				"000000111" when change_count_02 = "00011" else
				"000001111" when change_count_02 = "00100" else  
				"000011111" when change_count_02 = "00101" else  
				"000111111" when change_count_02 = "00110" else  
				"001111111" when change_count_02 = "00111" else  
				"011111111" when change_count_02 = "01000" else  
				"111111111" when change_count_02 = "01001" else "000000000";

	s_change_leds(107) <= s_count_2_thermo(8);	s_change_leds(106) <= s_count_1_thermo(8);	s_change_leds(105) <= s_count_05_thermo(8); 	s_change_leds(104) <= s_count_02_thermo(8); 	s_change_leds(103 downto 96) <= ok(103 downto 96);
	s_change_leds(95) <= s_count_2_thermo(7); 	s_change_leds(94) <= s_count_1_thermo(7);	s_change_leds(93) <= s_count_05_thermo(7);	s_change_leds(92) <= s_count_02_thermo(7);	s_change_leds(91 downto 84) <= ok(91 downto 84);
	s_change_leds(83) <= s_count_2_thermo(6);	s_change_leds(82) <= s_count_1_thermo(6);	s_change_leds(81) <= s_count_05_thermo(6);	s_change_leds(80) <= s_count_02_thermo(6); 	s_change_leds(79 downto 72) <= ok(79 downto 72);
	s_change_leds(71) <= s_count_2_thermo(5);	s_change_leds(70) <= s_count_1_thermo(5);	s_change_leds(69) <= s_count_05_thermo(5);	s_change_leds(68) <= s_count_02_thermo(5);	s_change_leds(67 downto 60) <= ok(67 downto 60);
	s_change_leds(59) <= s_count_2_thermo(4);	s_change_leds(58) <= s_count_1_thermo(4);	s_change_leds(57) <= s_count_05_thermo(4);	s_change_leds(56) <= s_count_02_thermo(4);	s_change_leds(55 downto 48) <= ok(55 downto 48);
	s_change_leds(47) <= s_count_2_thermo(3);	s_change_leds(46) <= s_count_1_thermo(3);	s_change_leds(45) <= s_count_05_thermo(3);	s_change_leds(44) <= s_count_02_thermo(3); 	s_change_leds(43 downto 36) <= ok(43 downto 36);
	s_change_leds(35) <= s_count_2_thermo(2);	s_change_leds(34) <= s_count_1_thermo(2);	s_change_leds(33) <= s_count_05_thermo(2);	s_change_leds(32) <= s_count_02_thermo(2); 	s_change_leds(31 downto 24) <= ok(31 downto 24);
	s_change_leds(23) <= s_count_2_thermo(1);	s_change_leds(22) <= s_count_1_thermo(1);	s_change_leds(21) <= s_count_05_thermo(1);	s_change_leds(20) <= s_count_02_thermo(1);	s_change_leds(19 downto 12) <= ok(19 downto 12);
	s_change_leds(11) <= s_count_2_thermo(0);	s_change_leds(10) <= s_count_1_thermo(0);	s_change_leds(9) <= s_count_05_thermo(0);	s_change_leds(8) <= s_count_02_thermo(0); 	s_change_leds(7 downto 0) <= ok(7 downto 0);
	


	s_progress_leds <= zero(107 downto 1) & progress_led;

	leds <= zero 	when msg = "000" else
		fr	when msg = "001" else
		drink	when msg = "010" else
		x_new	when msg = "011" else
		cup	when msg = "100" else
		donate	when msg = "101" else
		s_change_leds	when msg = "110" else
		s_progress_leds	when msg = "111" else
		zero;

end architecture rtl;

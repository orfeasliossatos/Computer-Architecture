library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk          : in  std_logic;
        reset_n      : in  std_logic;
        en           : in  std_logic;
        sel_a        : in  std_logic;
        sel_imm      : in  std_logic;
        sel_ihandler : in  std_logic;
        add_imm      : in  std_logic;
        imm          : in  std_logic_vector(15 downto 0);
        a            : in  std_logic_vector(15 downto 0);
        addr         : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
    
	-- signals
	signal s_sel		: std_logic;
	signal s_imm		: std_logic_vector(15 downto 0);
	signal s_choice0 	: std_logic_vector(15 downto 0);
	signal s_choice1 	: std_logic_vector(15 downto 0);
	signal s_addr		: std_logic_vector(15 downto 0);
	signal s_next 		: std_logic_vector(15 downto 0);

	-- constants	
	constant c_addr_size	: std_logic_vector(15 downto 0) := x"0004";
	constant c_handler_addr : std_logic_vector(15 downto 0) := x"0004";

begin

	-- combinational logic
	s_sel <= sel_a OR sel_imm OR sel_ihandler;
	s_imm <= imm when (add_imm = '1') 
			else c_addr_size;
	s_choice0 <= std_logic_vector(unsigned(s_imm) + unsigned(s_addr));
	s_choice1 <= a when (sel_a = '1') 
			else (imm(13 downto 0) & "00") when (sel_imm = '1') 
			else c_handler_addr;
	s_next <= s_choice1 when (s_sel = '1') else s_choice0;
	addr <= x"0000" & s_addr;

	-- sequential logic
    	dff: process(clk, reset_n) begin -- decide whether en should be in sens. list
		if (reset_n = '0') then
			s_addr <= x"0000";
		elsif (en = '1' AND rising_edge(clk)) then
			s_addr <= s_next;
		end if;
	end process;

	

end synth;

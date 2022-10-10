library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_registers is
    port(
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        write_n   : in  std_logic;
        backup_n  : in  std_logic;
        restore_n : in  std_logic;
        address   : in  std_logic_vector(2 downto 0);
        irq       : in  std_logic_vector(31 downto 0);
        wrdata    : in  std_logic_vector(31 downto 0);

        ipending  : out std_logic;
        rddata    : out std_logic_vector(31 downto 0)
    );
end control_registers;

architecture synth of control_registers is

	-- signals

	-- ctl0
	signal s_PIE		: std_logic;	-- ctl1
	signal s_EPIE		: std_logic;		
	-- ctl3
	signal s_ienable 	: std_logic_vector(31 downto 0);

begin
	-- combinational logic


	ipending <= '1' when s_PIE = '1' AND ((irq AND s_ienable) /= x"00000000") 
				else '0'; -- not a real register


	-- read process, asynchronous
	rddata <= std_logic_vector(to_unsigned(0, 31)) & s_PIE when address = "000"
			else std_logic_vector(to_unsigned(0, 31)) & s_EPIE when address = "001"
			else s_ienable when address = "011"
			else (irq AND s_ienable) when address = "100"
			else (others => '0');

	-- sequential logic

	-- write_process
	write_process : process(clk, reset_n)
	begin
		if (reset_n = '0') then 
			s_PIE <= '0';
			s_EPIE <= '0';
			s_ienable <= (others => '0');
		elsif (rising_edge(clk)) then
			if (write_n = '0') then				
				if (address = "000") then
					s_PIE <= wrdata(0);
				elsif (address = "001") then
					s_EPIE <= wrdata(0);
				elsif (address = "011") then
					s_ienable <= wrdata;
				end if;
			elsif (backup_n = '0') then
				s_EPIE <= s_PIE;
				s_PIE <= '0';
			elsif (restore_n = '0') then
				s_PIE <= s_EPIE;
			end if;
		end if;
	end process write_process;
	
end synth;

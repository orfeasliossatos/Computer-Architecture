library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
	-- Memory
	-- 4KB = 32000b = 1024 x 32
	type reg_type is array(0 to 1023) of std_logic_vector(31 downto 0); 
	signal reg: reg_type; 
	
	--
	signal s_address : std_logic_vector(9 downto 0);
	signal s_read : std_logic;
	signal s_rddata : std_logic_vector(31 downto 0);
	
begin
	-- tristate buffer

	-- read
	read_process : process(clk)
	begin
		-- synchronous read
		if (rising_edge(clk)) then
			-- cycle 0
			s_address <= address;
			s_read <= read and cs;
		end if;
	end process read_process;

	-- cycle 1
	process(s_read, s_address)
	begin
		if (s_read = '0') then
			rddata <= (others => 'Z');
		else
			rddata <= reg(to_integer(unsigned(s_address)));
		end if;
	end process;

	-- write
	write_process : process(clk)
	begin
		if (rising_edge(clk)) then
			if (write = '1' and cs = '1') then
				reg(to_integer(unsigned(address))) <= wrdata;
			end if;
		end if;
	end process write_process;
	
end synth;

library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
	component ROM_Block
	port 
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);	
	end component;
	signal s_q  : std_logic_vector(31 downto 0);
	signal s_en : std_logic;
begin
	ROM_Block_component : ROM_Block
	PORT MAP (
		address => address,
		clock => clk,
		q => s_q
	);

	rddata <= s_q when s_en = '1' else (others => 'Z');

	read_process : process(clk) is
	begin
		if rising_edge(clk) then
			s_en <= cs AND read;
		end if;
	end process read_process;


end synth;

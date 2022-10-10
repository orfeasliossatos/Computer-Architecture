library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity data_ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end data_ROM;

architecture synth of data_ROM is
    component data_ROM_Block is
        port(
            address : in  std_logic_vector(9 downto 0);
            clock   : in  std_logic;
            q       : out std_logic_vector(31 downto 0)
        );
    end component;

    -- internal signal for the ROM rddata
    signal in_rddata : std_logic_vector(31 downto 0);
    signal reg_read  : std_logic;

begin
    data_rom_block_0 : data_ROM_Block port map(
            address => address,
            clock   => clk,
            q       => in_rddata);

    -- 1 cycle latency
    process(clk)
    begin
        if (rising_edge(clk)) then
            reg_read <= read and cs;
        end if;
    end process;

    -- read in memory
    process(reg_read, in_rddata)
    begin
        rddata <= (others => 'Z');

        if (reg_read = '1') then
            rddata <= in_rddata;
        end if;
    end process;

end synth;

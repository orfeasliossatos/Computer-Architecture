library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
    signal b_s          : std_logic_vector(31 downto 0);
    signal sub_mode_vec : std_logic_vector(31 downto 0);
    signal result       : std_logic_vector(32 downto 0);

begin

    -- b_s is the output of the xor between b and sub_mode.
    -- here a vector of 32 bits of sub_mode has been created
    b_s <= b xor (31 downto 0 => sub_mode);

    sub_mode_vec <= (31 downto 1 => '0') & sub_mode;

    -- result of the adder will be on 33 bits to keep the carry.
    result <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b_s) + unsigned('0' & sub_mode_vec));

    -- The carry is extracted from the most significant bit of the result
    carry <= result(32);

    -- the r output is the 32 least significant bits of result
    r <= result(31 downto 0);

    -- zero is 1 when r = 0. r is an output, it can't be read.
    -- We have to compare the 32 least significant bits of result
    zero <= '1' when unsigned(result(31 downto 0)) = 0 else '0';

end synth;

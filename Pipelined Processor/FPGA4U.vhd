-- Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Altera and sold by Altera or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"
-- CREATED		"Thu Feb  4 16:28:20 2016"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY FPGA4U IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset_n :  IN  STD_LOGIC;
		in_buttons :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		out_LEDs :  OUT  STD_LOGIC_VECTOR(95 DOWNTO 0)
	);
END FPGA4U;

ARCHITECTURE bdf_type OF FPGA4U IS 

COMPONENT buttons
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 write : IN STD_LOGIC;
		 address : IN STD_LOGIC;
		 buttons : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 wrdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rddata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder
	PORT(address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 cs_RAM : OUT STD_LOGIC;
		 cs_ROM : OUT STD_LOGIC;
		 cs_Buttons : OUT STD_LOGIC;
		 cs_LEDs : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT cpu
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 D_rddata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 I_rddata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 D_read : OUT STD_LOGIC;
		 D_write : OUT STD_LOGIC;
		 D_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 D_wrdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 I_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT data_rom
	PORT(clk : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 rddata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instruction_rom
	PORT(clk : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 rddata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT leds
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 write : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 wrdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 LEDs : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
		 rddata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(clk : IN STD_LOGIC;
		 cs : IN STD_LOGIC;
		 write : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 wrdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rddata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	address :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	cs_Buttons :  STD_LOGIC;
SIGNAL	cs_LEDs :  STD_LOGIC;
SIGNAL	cs_RAM :  STD_LOGIC;
SIGNAL	cs_ROM :  STD_LOGIC;
SIGNAL	I_addr :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	rddata :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	wrdata :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_12 <= '1';



b2v_buttons_0 : buttons
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 cs => cs_Buttons,
		 read => SYNTHESIZED_WIRE_10,
		 write => SYNTHESIZED_WIRE_11,
		 address => address(2),
		 buttons => in_buttons,
		 wrdata => wrdata,
		 rddata => rddata);


b2v_decoder_0 : decoder
PORT MAP(address => address,
		 cs_RAM => cs_RAM,
		 cs_ROM => cs_ROM,
		 cs_Buttons => cs_Buttons,
		 cs_LEDs => cs_LEDs);


b2v_inst : cpu
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 D_rddata => rddata,
		 I_rddata => SYNTHESIZED_WIRE_2,
		 D_read => SYNTHESIZED_WIRE_10,
		 D_write => SYNTHESIZED_WIRE_11,
		 D_addr => address,
		 D_wrdata => wrdata,
		 I_addr => I_addr);


b2v_inst3 : data_rom
PORT MAP(clk => clk,
		 cs => cs_ROM,
		 read => SYNTHESIZED_WIRE_10,
		 address => address(11 DOWNTO 2),
		 rddata => rddata);


b2v_inst4 : instruction_rom
PORT MAP(clk => clk,
		 cs => SYNTHESIZED_WIRE_12,
		 read => SYNTHESIZED_WIRE_12,
		 address => I_addr(11 DOWNTO 2),
		 rddata => SYNTHESIZED_WIRE_2);



b2v_LEDs_0 : leds
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 cs => cs_LEDs,
		 write => SYNTHESIZED_WIRE_11,
		 read => SYNTHESIZED_WIRE_10,
		 address => address(3 DOWNTO 2),
		 wrdata => wrdata,
		 LEDs => out_LEDs,
		 rddata => rddata);


b2v_RAM_0 : ram
PORT MAP(clk => clk,
		 cs => cs_RAM,
		 write => SYNTHESIZED_WIRE_11,
		 read => SYNTHESIZED_WIRE_10,
		 address => address(11 DOWNTO 2),
		 wrdata => wrdata,
		 rddata => rddata);


END bdf_type;
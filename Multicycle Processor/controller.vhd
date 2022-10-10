library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is

type state is(FETCH1, FETCH2, DECODE, R_OP, RI_OP, STORE, BREAK, LOAD1, LOAD2, I_OP, UI_OP, BRANCH, CALL, CALLR, JMP, JMPI);
signal curr_state, next_state, state_after_decode : state;

begin

--reg next state depending of the current one----------
next_state <=  FETCH2 when curr_state = FETCH1 else
					DECODE when curr_state = FETCH2 else
					BREAK  when curr_state = BREAK  else
					-- 'execute' states
					FETCH1 when curr_state = R_OP or curr_state = RI_OP or curr_state = STORE or curr_state = LOAD2 or curr_state = I_OP or curr_state = UI_OP or curr_state = BRANCH or curr_state = CALL or curr_state = CALLR or curr_state = JMP or curr_state = JMPI else
					LOAD2  when curr_state = LOAD1  else
					state_after_decode;
					
state_after_decode <= 	BREAK  when (op = "111010" and opx = "110100") else
								RI_OP when op = "111010" and (opx = "010010" or opx = "011010" or opx = "111010" or opx = "000010") else 
								
								LOAD1  when op = "010111" else
								STORE  when op = "010101" else
								BRANCH when (op = "000110" or op = "001110" or op = "010110" or op = "011110" or op = "100110" or op = "101110" or op = "110110") else
								CALL   when op = "000000" else
								CALLR  when (op = "111010" and opx = "011101") else
								JMP	 when (op = "111010" and (opx = "000101" or opx = "001101")) else
								JMPI	 when op = "000001" else
								R_OP   when op = "111010" else
								UI_OP when  op = "001100"   or op = "010100" or op = "011100" 
										   or op = "101000"   or op = "110000" else
								I_OP;
								
--multiplexers----------------------------------------

													--immediate when I_OP or STORE or LOAD1, register output when R_OP
sel_b    <= '0' when curr_state = I_OP or curr_state = UI_OP or curr_state = RI_OP
					  or curr_state = STORE or curr_state = LOAD1 else '1';

sel_rC   <= '0' when curr_state = I_OP or curr_state = UI_OP or curr_state = LOAD2 or curr_state = CALL or curr_state = CALLR or curr_state = JMP or curr_state = JMPI else '1'; --B when I_OP or UI_OP or LOAD2, C when R_OP

sel_mem  <= '1' when curr_state = LOAD2 else '0'; --rddata when LOAD2

sel_addr <= '1' when curr_state = STORE or curr_state = LOAD1 else '0'; -- alu output when STORE or LOAD1

sel_ra 	<= '1' when curr_state = CALL or curr_state = CALLR else '0';

sel_pc	<= '1' when curr_state = CALL or curr_state = CALLR else '0';

--memory---------------------------------------------------
read <= '1'  when curr_state = FETCH1 or curr_state = LOAD1 else '0';

write <= '1' when curr_state = STORE else '0';
--en--------------------------------------------------

imm_signed <= '1' when curr_state = LOAD1 or curr_state = STORE or curr_state = I_OP else '0';

pc_en      <= '1' when curr_state = FETCH2 or curr_state = CALL or curr_state = CALLR or curr_state = JMP or curr_state = JMPI else '0';

ir_en      <= '1' when curr_state = FETCH2 else '0';

rf_wren    <= '1' when curr_state = LOAD2 or curr_state = R_OP or curr_state = I_OP 
						  or curr_state = CALL or curr_state = CALLR or curr_state = UI_OP or curr_state = RI_OP else '0';

branch_op  <= '1' when curr_state = BRANCH else '0';

--pc--------------------------------------------------

pc_add_imm  <= '1' when curr_state = BRANCH else '0';

pc_sel_imm 	<= '1' when curr_state = CALL or curr_state = JMPI else '0';

pc_sel_a 	<= '1' when curr_state = CALLR or curr_state = JMP else '0';

--alu---------------------------------------------------------
op_alu <= "000100" when op = "010111" or op =  "010101" else --STORE AND LOAD1
			 "011100" when op = "000110" else -- no condition
			 "011001" when op = "001110" else -- ble
			 "011010" when op = "010110" else -- bgt
			 "011011" when op = "011110" else -- bne
			 "011100" when op = "100110" else -- beq
			 "011101" when op = "101110" else -- bleu
			 "011110" when op = "110110" else -- bgtu
			 "000000" when op = "000100" or (op = "111010" and opx = "110001") else -- addi or add
			 "10--01" when op = "001100" or (op = "111010" and opx = "001110") else -- andi or and
			 "10--10" when op = "010100" or (op = "111010" and opx = "010110") else -- ori or or
			 "10--11" when op = "011100" or (op = "111010" and opx = "011110") else -- xnori or xnor
			 "011001" when op = "001000" or (op = "111010" and opx = "001000") else -- cmplei or cmple
			 "011010" when op = "010000" or (op = "111010" and opx = "010000") else -- cmpgti or cmpgt
			 "011011" when op = "011000" or (op = "111010" and opx = "011000") else -- cmpnei or cmpne
			 "011100" when op = "100000" or (op = "111010" and opx = "100000") else -- cmpeqi or cmpeq
			 "011101" when op = "101000" or (op = "111010" and opx = "101000") else -- cmpleui or cmpleu
			 "011110" when op = "110000" or (op = "111010" and opx = "110000") else -- cmpgtui or cmpgtu
			 "001---" when op = "111010" and opx = "111001" else -- sub
			 "10--00" when op = "111010" and opx = "000110" else -- nor
			 "11-010" when op = "111010" and (opx = "010011" or opx = "010010") else -- sll or slli
			 "11-011" when op = "111010" and (opx = "011011" or opx = "011010") else -- srl or srli 
			 "11-111" when op = "111010" and (opx = "111011" or opx = "111010") else -- sra or srai
			 "11-000" when op = "111010" and (opx = "000011" or opx = "000010") else -- rol or roli
			 "11-001" when op = "111010" and opx = "001011" else -- ror
			 opx;
			
-------------------------------------------------							
dff : process(clk, reset_n) is
begin

	if reset_n = '0' then curr_state <= FETCH1;
	elsif rising_edge(clk) then curr_state <= next_state;
	end if;
	
end process dff;
	
end synth;

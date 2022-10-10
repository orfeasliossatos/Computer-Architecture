library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port(
        -- bus interface
        clk     : in  std_logic;
        reset_n : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(1 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);

        irq     : out std_logic;
        rddata  : out std_logic_vector(31 downto 0)
    );
end timer;

architecture synth of timer is
		-- signals
		
		-- address read
		signal s_read 		: std_logic;
		signal s_address	: std_logic_vector(1 downto 0); 
		
		-- status registers
		signal s_TO		: std_logic; -- 1 : 1 when counter is 0
		signal s_RUN		: std_logic; -- 0 : 1 when counter is running (read-only)
		
		-- control register
		signal s_ITO		: std_logic; -- 1 : if 1, timer generates IRQ, else doesn't
		signal s_CONT		: std_logic; -- 0 : 1 -> counter runs continuously unless STOP
		
		-- period register ("actual timer period"-1 because counter stays 0 for 1 cycle)
		signal s_period	: std_logic_vector(31 downto 0); -- on write reload and stop counter
		
		-- counter register
		signal s_counter	: std_logic_vector(31 downto 0); -- when 0, reloads with period
		
		
		-- constants
		
		-- word-aligned addresses for each register
		constant c_counter_adr	: std_logic_vector(1 downto 0) := "00";
		constant c_period_adr	: std_logic_vector(1 downto 0) := "01";
		constant c_control_adr	: std_logic_vector(1 downto 0) := "10";
		constant c_status_adr	: std_logic_vector(1 downto 0) := "11";
		
begin

		-- logic (implicit combinational processes)

		-- interrupt behaviour
		irq <= s_TO and s_ITO;
		
		
		-- read and write processes
		
		-- read_process, cycle 0 synchronized with clock
		read_process : process(clk)
		begin
			-- synchronous read
			if (rising_edge(clk)) then
				s_address <= address;
				s_read <= read and cs;
			end if;
		end process read_process;
		
		-- read_process, during cycle 1 whenever something changes
		process(s_read, s_address, s_RUN, s_TO, s_ITO, s_CONT, s_counter, s_period)
		begin
			if (s_read = '0') then
				rddata <= (others => 'Z');
			else
				if (s_address = c_counter_adr) then
						rddata <= s_counter;
						
				elsif (s_address = c_period_adr) then
						rddata <= s_period;
						
				elsif (s_address = c_control_adr) then
						-- START and STOP are write-only, so reading returns 0
						rddata <= (others => '0');
						rddata(1) <= s_ITO;
						rddata(0) <= s_CONT;
						
				elsif (s_address = c_status_adr) then
						rddata <= (others => '0');
						rddata(1) <= s_TO;
						rddata(0) <= s_RUN;
				end if;
			end if;
		end process;
		
		-- write_process
		write_process : process(clk, reset_n)
		begin
			if (reset_n = '0') then 
				s_RUN 	<= '0';
				s_TO		<= '0';
				s_ITO		<= '0';
				s_CONT 	<= '0';
				s_counter(31 downto 0) 	<= (others => '0');
				s_period(31 downto 0) 	<= (others => '0');
				
			elsif (rising_edge(clk)) then
				-- "finite state machine"
				if (s_RUN = '1') then
					if (s_counter(31 downto 0) = x"00000000") then
						s_TO 	<= '1';
						s_RUN <= s_CONT; -- continue running if s_CONT is 1
						s_counter(31 downto 0) <= s_period(31 downto 0);
					else
						s_counter(31 downto 0) <= std_logic_vector(unsigned(s_counter) - 1);
					end if;				
				end if;
				
				if (write = '1' and cs = '1') then
					-- s_counter is read-only, so do nothing if address = c_counter_adr
					
					if (address(1 downto 0) = c_period_adr) then
						s_period 	<= wrdata;
						
						-- write-to-period resets the counter
						s_counter 	<= wrdata;
						s_RUN 		<= '0';
						
					elsif (address(1 downto 0) = c_control_adr(1 downto 0)) then
						
						-- if stopped and wrdata(3) == '1' -> start running!
						if (wrdata(3) = '1') then
							s_RUN 	<= '1';
						end if;
							
						-- if wrdata(2) == '1' -> run should be 0
						if (wrdata(2) = '1') then
							s_RUN 	<= '0';
						end if;
							
						s_ITO 	<= wrdata(1);
						s_CONT 	<= wrdata(0);
						
					elsif (address(1 downto 0) = c_status_adr(1 downto 0)) then
						-- s_RUN is read-only, so another chip must not write to it!
						-- s_TO can only be written to 0 from here.
						-- "Write zero to the status register to clear the TO bit"
						-- means that we should look at the run bit..
						s_TO <= wrdata(0) and s_TO;
					end if;
				end if;
			end if;
		end process write_process;
		
end synth;

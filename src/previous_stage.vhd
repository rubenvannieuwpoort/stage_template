library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.stage_interfaces.all;


entity previous_stage is
	port(
		clk: in std_logic;
		output: out previous_stage_output_type := DEFAULT_PREVIOUS_STAGE_OUTPUT;
		hold_in: in std_logic
	);
end previous_stage;


architecture Behavioral of previous_stage is
	signal count: std_logic_vector(3 downto 0) := "0000";
begin
	process(clk)
		variable v_new_count: std_logic_vector(3 downto 0);
	begin
		if rising_edge(clk) then
			if hold_in = '0' then
				output.valid <= '1';
				output.tag <= count;
				output.number <= std_logic_vector(15 - unsigned(count));
				count <= std_logic_vector(unsigned(count) + 1);
			end if;
		end if;
	end process;
end Behavioral;

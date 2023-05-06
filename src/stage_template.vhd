library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.stage_interfaces.all;


entity stage_template is
	port(
		clk: in std_logic;
		input: in previous_stage_output_type;
		output: out stage_output_type := DEFAULT_STAGE_OUTPUT;
		transient_output: out stage_output_type := DEFAULT_STAGE_OUTPUT;
		should_stall: in std_logic;
		hold_in: in std_logic;
		hold_out: out std_logic
	);
end stage_template;


architecture Behavioral of stage_template is
	signal buffered_input: previous_stage_output_type := DEFAULT_PREVIOUS_STAGE_OUTPUT;

	--function should_stall(input: previous_stage_output_type) return boolean is
	--begin
	--	return false;
	--end function;

	function f(input: previous_stage_output_type) return stage_output_type is
		variable output: stage_output_type;
	begin
		if input.valid = '0' then
			return DEFAULT_STAGE_OUTPUT;
		end if;
		
		output.valid := '1';
		output.tag := input.tag;
		output.number := std_logic_vector(15 - unsigned(input.number));

		return output;
	end function;


begin
	hold_out <= buffered_input.valid;

	process(clk)
		variable v_input: previous_stage_output_type;
		variable v_should_stall: boolean;
	begin
		if rising_edge(clk) then
			if buffered_input.valid = '1' then
				v_input := buffered_input;
			else
				v_input := input;
			end if;

			if hold_in = '0' then
				-- normally this should be computed as v_should_stall := should_stall(v_input); but this is easier for testing
				v_should_stall := should_stall = '1';
				if v_should_stall then
					output <= DEFAULT_STAGE_OUTPUT;
				end if;
			end if;

			if hold_in = '0' and not(v_should_stall) then
				output <= f(v_input);
				transient_output <= f(v_input);
				buffered_input <= DEFAULT_PREVIOUS_STAGE_OUTPUT;
			else
				transient_output <= DEFAULT_STAGE_OUTPUT;
				buffered_input <= v_input;
			end if;
		end if;
	end process;
end Behavioral;

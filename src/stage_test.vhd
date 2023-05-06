library ieee;
use ieee.std_logic_1164.all;

use work.stage_interfaces.all;


entity stage_test is
end stage_test;


architecture behavior of stage_test is
	component stage_template is
		port(
			clk: in std_logic;
			input: in previous_stage_output_type;
			output: out stage_output_type := DEFAULT_STAGE_OUTPUT;
			transient_output: out stage_output_type := DEFAULT_STAGE_OUTPUT;
			should_stall: in std_logic;
			hold_in: in std_logic;
			hold_out: out std_logic
		);
	end component;

	component previous_stage is
		port(
			clk: in std_logic;
			output: out previous_stage_output_type := DEFAULT_PREVIOUS_STAGE_OUTPUT;
			hold_in: in std_logic
		);
	end component;

	signal clk: std_logic := '0';
	signal hold: std_logic := '0';
	signal hold_in: std_logic := '0';
	signal should_stall: std_logic := '0';
	signal data: previous_stage_output_type := DEFAULT_PREVIOUS_STAGE_OUTPUT;
	signal output: stage_output_type := DEFAULT_STAGE_OUTPUT;
	signal transient_output: stage_output_type := DEFAULT_STAGE_OUTPUT;

	constant clk_period : time := 10 ns;
begin
	previous_stage_inst: previous_stage port map(clk => clk, hold_in => hold, output => data);
	stage_inst: stage_template port map(clk => clk, input => data, output => output, transient_output => transient_output, should_stall => should_stall, hold_in => hold_in, hold_out => hold);

	clk_process :process
	begin
		clk <= '1';
		wait for clk_period / 2;
		clk <= '0';
		wait for clk_period / 2;
	end process;

	stim_process :process
	begin
		wait for 1ps;
		wait for clk_period * 3;
		should_stall <= '1';
		wait for clk_period * 2;
		should_stall <= '0';
		wait for clk_period * 3;
		hold_in <= '1';
		wait for clk_period * 2;
		hold_in <= '0';
		wait for clk_period * 2;
		should_stall <= '1';
		wait for clk_period * 1;
		hold_in <= '1';
		wait for clk_period * 2;
		hold_in <= '0';
		should_stall <= '0';
		wait;
	end process;
end;

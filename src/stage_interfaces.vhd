library ieee;
use ieee.std_logic_1164.all;


package stage_interfaces is
	type previous_stage_output_type is record
		valid: std_logic;
		tag: std_logic_vector(3 downto 0);
		number: std_logic_vector(3 downto 0);
	end record previous_stage_output_type;

	constant DEFAULT_PREVIOUS_STAGE_OUTPUT: previous_stage_output_type := (
		valid => '0',
		tag => "0000",
		number => "0000"
	);

	type stage_output_type is record
		valid: std_logic;
		tag: std_logic_vector(3 downto 0);
		number: std_logic_vector(3 downto 0);
	end record stage_output_type;

	constant DEFAULT_STAGE_OUTPUT: stage_output_type := (
		valid => '0',
		tag => "0000",
		number => "0000"
	);
end package stage_interfaces;

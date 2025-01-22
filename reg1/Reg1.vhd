LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Reg1 is

	generic( W: integer := 2);
	port(
		clk, enable : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end Reg1;

architecture comportamental of Reg1 is

	signal reg: std_logic;
	begin
	process(clk)
		begin
		
		if rising_edge(clk) then 
			if enable = '1' then
				reg <= D;
			end if;
		end if;
	end process;
	
	Q <= reg;
	
end comportamental;
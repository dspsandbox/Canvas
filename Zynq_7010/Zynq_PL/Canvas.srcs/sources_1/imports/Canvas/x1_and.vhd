----------------------------------------------------------------------------------
--x1_and module
 
--MIT License
--Copyright (c) 2019 DSPsandbox (Pau Gomez pau.gomez@dspsandbox.org)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity x1_and is
    Port ( clk : in STD_LOGIC;
           dataIn0 : in STD_LOGIC;
           dataIn1 : in STD_LOGIC;
           dataOut : out STD_LOGIC
           );
end x1_and;

architecture Behavioral of x1_and is

begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			dataOut<= (dataIn0 and dataIn1);				
		end if;

	end process;

end Behavioral;

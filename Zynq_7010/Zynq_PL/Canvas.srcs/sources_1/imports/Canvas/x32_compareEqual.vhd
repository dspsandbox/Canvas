----------------------------------------------------------------------------------
--x32_compareEqual module
 
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

entity x32_compareEqual is
	Generic(PORT_WIDTH : integer := 32);
    Port ( clk : in STD_LOGIC;
           dataIn0 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataIn1 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC
           );
end x32_compareEqual;

architecture Behavioral of x32_compareEqual is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if dataIn0=dataIn1 then
				dataOut<='1';
			else
				dataOut<='0';
			end if;
		end if;
	end process;
end Behavioral;

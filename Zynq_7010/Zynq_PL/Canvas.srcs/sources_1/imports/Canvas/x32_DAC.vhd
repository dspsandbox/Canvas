----------------------------------------------------------------------------------
--x32_DAC module
 
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

entity x32_DAC is
	Generic(PORT_WIDTH : integer := 32
	);
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR (13 downto 0)
           );
     
end x32_DAC;

architecture Behavioral of x32_DAC is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			dataOut(13)<=dataIn(PORT_WIDTH-1);
			dataOut(12 downto 0)<=not(dataIn((PORT_WIDTH-2) downto (PORT_WIDTH-14)));
		end if;
	end process;
			

end Behavioral;


----------------------------------------------------------------------------------
--x32_sign module
 
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

entity x32_sign is
	Generic(PORT_WIDTH : integer := 32);
    Port ( dataIn : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC
           );
end x32_sign;

architecture Behavioral of x32_sign is

begin

dataOut<=dataIn((PORT_WIDTH-1));
	
end Behavioral;

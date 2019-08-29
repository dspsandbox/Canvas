----------------------------------------------------------------------------------
--x32_sampleHold module
 
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

entity x32_sampleHold is
    Generic(PORT_WIDTH : integer := 32);
    Port ( clk : in STD_LOGIC;
    	   hold: in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
end x32_sampleHold;

architecture Behavioral of x32_sampleHold is
signal dataHold : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0) := (others=>'0'); 
begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			if hold='0' then
				dataOut<= dataIn;
				dataHold<=dataIn;
			else
				dataOut<=dataHold;
			end if;
		end if;

	end process;

end Behavioral;
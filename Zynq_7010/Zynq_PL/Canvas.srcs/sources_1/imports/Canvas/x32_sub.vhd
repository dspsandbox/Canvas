----------------------------------------------------------------------------------
--x32_sub module
 
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

entity x32_sub is
	Generic(PORT_WIDTH : integer := 32
	);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataIn0 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataIn1 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
     
           
end x32_sub;

architecture Behavioral of x32_sub is
begin
	process(clk)
	begin
		if rising_edge(clk) then
            if reset='1' then
                dataOut<=(others=>'0');
            else
                dataOut<=STD_LOGIC_VECTOR(signed(dataIn0)-signed(dataIn1));
            end if;
        end if;
    end process;
end Behavioral;

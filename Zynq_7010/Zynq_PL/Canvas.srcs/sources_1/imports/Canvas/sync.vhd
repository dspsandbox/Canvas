----------------------------------------------------------------------------------
--sync module

--MIT License
--Copyright (c) 2019 DSPsandbox (Pau Gomez pau.gomez@dspsandbox.org)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync is
	Generic(PORT_WIDTH : integer := 8;
			CONSTANT_REGISTER_DEPTH : integer := 8);
    Port ( clk : in STD_LOGIC;
           dataIn: in STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           dataOut: out STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0)
         );
end sync;

architecture Behavioral of sync is

signal dataMeta: STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');



begin
	process(clk)
	
	begin
		if rising_edge(clk) then
            dataMeta<=dataIn;
            dataOut<=dataMeta;
		end if;
	end process;


end Behavioral;

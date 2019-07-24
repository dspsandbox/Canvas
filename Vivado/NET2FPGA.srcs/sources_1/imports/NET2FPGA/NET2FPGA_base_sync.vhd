----------------------------------------------------------------------------------
--NET2FPGA_base_sync module

--MIT License
--Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
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

entity NET2FPGA_base_sync is
	Generic(PORT_WIDTH : integer := 8;
			CONSTANT_REGISTER_DEPTH : integer := 8);
    Port ( clk125 : in STD_LOGIC;
           dataIn: in STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0);
           dataOut: out STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0)
         );
end NET2FPGA_base_sync;

architecture Behavioral of NET2FPGA_base_sync is

signal dataMeta: STD_LOGIC_VECTOR (PORT_WIDTH-1 downto 0):= (others=>'0');



begin
	process(clk125)
	
	begin
		if rising_edge(clk125) then
            dataMeta<=dataIn;
            dataOut<=dataMeta;
		end if;
	end process;


end Behavioral;

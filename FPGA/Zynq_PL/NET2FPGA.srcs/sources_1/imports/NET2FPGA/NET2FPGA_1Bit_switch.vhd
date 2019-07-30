----------------------------------------------------------------------------------
--NET2FPGA_1Bit_switch module
 
--MIT License
--Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NET2FPGA_1Bit_switch is
    Port ( clk : in STD_LOGIC;
           dataInSwitch : in STD_LOGIC;
           dataIn0 : in STD_LOGIC;
           dataIn1 : in STD_LOGIC;
           dataOut : out STD_LOGIC
           );
end NET2FPGA_1Bit_switch;

architecture Behavioral of NET2FPGA_1Bit_switch is

begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			if dataInSwitch='0' then
				dataOut<= dataIn0;
			else
				dataOut<= dataIn1;
			end if;
		end if;

	end process;

end Behavioral;


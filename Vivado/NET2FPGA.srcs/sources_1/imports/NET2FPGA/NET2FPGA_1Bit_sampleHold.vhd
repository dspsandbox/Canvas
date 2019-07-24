----------------------------------------------------------------------------------
--NET2FPGA_1Bit_sampleHold module
 
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

entity NET2FPGA_1Bit_sampleHold is
    Port ( clk : in STD_LOGIC;
    	   hold: in STD_LOGIC;
           dataIn : in STD_LOGIC;
           dataOut : out STD_LOGIC
           );
end NET2FPGA_1Bit_sampleHold;

architecture Behavioral of NET2FPGA_1Bit_sampleHold is
signal dataHold : STD_LOGIC:= '0'; 
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

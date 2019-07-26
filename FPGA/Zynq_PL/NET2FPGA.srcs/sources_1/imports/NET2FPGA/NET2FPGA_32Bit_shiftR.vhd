----------------------------------------------------------------------------------
--NET2FPGA_32Bit_shiftR module
 
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

entity NET2FPGA_32Bit_shiftR is
	Generic(PORT_WIDTH : integer := 32);
    Port ( clk : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataShiftR : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
end NET2FPGA_32Bit_shiftR;

architecture Behavioral of NET2FPGA_32Bit_shiftR is

begin

	process(clk)
	variable shiftR : integer;
	begin
		if rising_edge(clk) then
			shiftR:=to_integer(unsigned(dataShiftR(4 downto 0)));
			dataOut<=STD_LOGIC_VECTOR(shift_right(signed(dataIn),shiftR));
		end if;

	end process;

end Behavioral;


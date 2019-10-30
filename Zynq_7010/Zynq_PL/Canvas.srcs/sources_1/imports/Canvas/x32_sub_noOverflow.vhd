----------------------------------------------------------------------------------
--x32_sub_noOverflow module
 
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

entity x32_sub_noOverflow is
	Generic(PORT_WIDTH : integer := 32;
		MAX_VAL: STD_LOGIC_VECTOR (31 downto 0) := (31=>'0',others=>'1');
		MIN_VAL: STD_LOGIC_VECTOR (31 downto 0) := (31=>'1',others=>'0')
	);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dataIn0 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataIn1 : in STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0);
           dataOut : out STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0)
           );
           
     
           
end x32_sub_noOverflow;

architecture Behavioral of x32_sub_noOverflow is
begin
	process(clk)
		variable sign0 : STD_LOGIC :='0';
		variable sign1 : STD_LOGIC :='0';
		variable sub : STD_LOGIC_VECTOR ((PORT_WIDTH-1) downto 0) := (others=>'0');
	begin
		if rising_edge(clk) then
            if reset='1' then
                dataOut<=(others=>'0');
            else
            	sign0:=dataIn0(PORT_WIDTH-1);
            	sign1:=dataIn1(PORT_WIDTH-1);
                sub:=STD_LOGIC_VECTOR(signed(dataIn0)-signed(dataIn1));
                
                if sign0='0' and sign1='1' then      --First input positive, second negative
                	if sub(PORT_WIDTH-1)='0' then    --Output positive
                		dataOut<=sub;
                	else                             --Output negative
                		dataOut<=MAX_VAL;
                	end if;
                elsif sign0='1' and sign1='0' then   --First input negative, second positive
                	if sub(PORT_WIDTH-1)='1' then    --Output negative
                		dataOut<=sub;
                	else                             --Output positive
                		dataOut<=MIN_VAL;
                	end if;
                else							     --Inputs have equal signs
                	dataOut<=sub;	
                end if;
            end if;
        end if;
    end process;
    
    
    
end Behavioral;

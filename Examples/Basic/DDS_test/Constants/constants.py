#########################################################################
# NET2FPGA constants file
# MIT License# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
#########################################################################
# Please set the 1Bit and 32Bit constant registers you need (by default they are set to 0). 

# For 1Bit constants registers use:
# const1Bit[<regAddr>]=<regVal>  where <regAddr>=0,1,...,255    and  <regVal>=0,1

# For 32Bit constants registers use:
# const32Bit[<regAddr>]=<regVal>  where <regAddr>=0,1,...,255    and  <regVal>=-2^31,...,0,...,2^31-1

# Example:

pInc=84e3/125e6*2**32
pOff=0
const32Bit[0]=pInc 
const32Bit[2]=pOff

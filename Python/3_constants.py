###########################################################################
# NET2FPGA 3_constants
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
###########################################################################
import NET2FPGA
import settings                                                            #Load settings                                                                      
############################################################################
fpga=NET2FPGA.FPGA.FPGA_CLASS(settings)                                    #Instantiate NET2FPGA FPGA class object 

fpga.connect()
const1Bit=np.zeros(256)                                                    #Init 1 bit constants (DO NOT CHANGE)
const32Bit=np.zeros(256)                                                   #Init 32 bit constants (DO NOT CHANGE)
execfile(settings.filePathConstants)                                       #Executes constants file. Overwrites selected entries of const1Bit and const32Bit)
fpga.transferConstants()                                                   #Transfers constants to FPGA (PS)
fpga.loadConstants()                                                       #Loads constants into FPGA (PL)
fpga.disconnect()                                                          #Disconnect form FPGA


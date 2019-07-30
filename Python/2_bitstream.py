############################################################################
# NET2FPGA 2_bitstream
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
############################################################################
import NET2FPGA
import settings                                                            #Load settings
############################################################################
fpga=NET2FPGA.FPGA.FPGA_CLASS(settings)                                    #Instantiate NET2FPGA FPGA class object 

fpga.connect()                                                             #Connect to FPGA via SSH
fpga.transferBitstream()                                                   #Transfers bitstream to FPGA (PS)
fpga.loadBitstream()                                                       #Loads bitstream into FPGA (PL)
fpga.disconnect()                                                          #Disconnect form FPGA


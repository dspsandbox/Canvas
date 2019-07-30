############################################################################
# NET2FPGA 1_config
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
############################################################################
import NET2FPGA
import settings                                                            #Load settings
############################################################################
fpga=NET2FPGA.FPGA.FPGA_CLASS(settings)                                    #Instantiate NET2FPGA FPGA class object 

fpga.connect()                                                             #Connect to FPGA via SSH
fpga.initFileStructure()                                                   #Initiates required file structure on FPGA
fpga.initBitstreamLoader()                                                 #Uploads and makes executable Zynq_PS -> Zynq_PL bitstream loader     
fpga.initConstantsLoader()                                                 #Uploads, compiles and makes executable the Zynq_PS -> Zynq_PL constants loader     
fpga.configBoot()                                                          #Configures the boot to automatically load bitstream/constants
fpga.disconnect()                                                          #Disconnect form FPGA
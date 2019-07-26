#################################################################################
# NET2FPGA settings file
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
#################################################################################
import os

#NET2FPGA git location
pathBase=".."                                                                   #Path to NET2FPGA git folder

#NET2FPGA server settings 
SERVER_TCP_IP = 'localhost'                                                     #Do NOT change  
SERVER_TCP_PORT = 5000                                                          #Do NOT change

#################################################################################

#FPGA SSH settings  
FPGA_SSH_IP='10.9.1.150'                                                        #IP address of your Redpitaya 
FPGA_SSH_USERNAME="root"                                                        #SSH username 
FPGA_SSH_PASSWORD="root"                                                        #SSH password

#FPGA CONFIG
filePathSetBitstream=os.path.join(pathBase,"FPGA","Zynq_PS","setBitstream.sh")  #DO NOT change
filePathSetConstants=os.path.join(pathBase,"FPGA","Zynq_PS","setConstants.c")   #DO NOT change
filePathRcLocal=os.path.join(pathBase,"FPGA","Zynq_PS","rc.local")              #DO NOT change
filePathConst1Bit=os.path.join(pathBase,"FPGA","Zynq_PS","const1Bit.txt")       #DO NOT change
filePathConst32Bit=os.path.join(pathBase,"FPGA","Zynq_PS","const32Bit.txt")     #DO NOT change

autoBitstream=True                                                              #Flag for loading bitstream after reboot
autoConstants=True                                                              #Flag for loading constants after reboot

#################################################################################

#Folder paths for INPUT/OUTPUT/CONSTANTS 
filePathNetInput="Examples/Example1/Input/mainCircuit.net"                      #Path to .net file to be implemented on FPGA
pathOutput="Examples/Example1/Output"                                           #Path to place NET2FPGA output products
filePathBitstream="Examples/Example1/Output/Bitstream/bitstream.bit"            #Path to bitstream.bit file.  
filePathConstants="Examples/Example1/Constants/constants.py"                    #Path to constants.py file. If not present an empty file will be created. 


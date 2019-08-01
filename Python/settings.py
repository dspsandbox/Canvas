######################################################################################
# NET2FPGA settings file
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
######################################################################################

import os

######################################################################################

#NET2FPGA git location
pathBase=".."                                                                        #Path to NET2FPGA git folder

#NET2FPGA server settings 
SERVER_TCP_IP = '82.223.15.170'                                                      #DO NOT CHANGE  
SERVER_TCP_PORT = 5000                                                               #DO NOT CHANGE

######################################################################################

#FPGA SSH settings  
FPGA_SSH_IP='10.9.1.150'                                                             #IP address of your Redpitaya 
FPGA_SSH_USERNAME="root"                                                             #SSH username 
FPGA_SSH_PASSWORD="root"                                                             #SSH password

#FPGA CONFIG
filePathSetBitstream=os.path.join(pathBase,"FPGA","Zynq_PS","bitstreamLoader.sh")    #DO NOT CHANGE
filePathSetConstants=os.path.join(pathBase,"FPGA","Zynq_PS","constantsLoader.c")     #DO NOT CHANGE
filePathRcLocal=os.path.join(pathBase,"FPGA","Zynq_PS","rc.local")                   #DO NOT CHANGE
filePathDebianConf=os.path.join(pathBase,"FPGA","Zynq_PS","debian.conf")             #DO NOT CHANGE
filePathConst1Bit=os.path.join(pathBase,"FPGA","Zynq_PS","const1Bit.txt")            #DO NOT CHANGE
filePathConst32Bit=os.path.join(pathBase,"FPGA","Zynq_PS","const32Bit.txt")          #DO NOT CHANGE

autoBitstream=True                                                                   #Flag for loading bitstream after reboot
autoConstants=True                                                                   #Flag for loading constants after reboot

######################################################################################

#Folder paths for INPUT/OUTPUT/CONSTANTS 
filePathNetInput="../Examples/Basic/ledBlink/Input/input.net"                        #Path to .net file to be implemented on FPGA
pathOutput="../Examples/Basic/ledBlink/Output"                                       #Path to place NET2FPGA output products
filePathBitstream="../Examples/Basic/ledBlink/Output/Bitstream/bitstream.bit"        #Path to bitstream.bit file.  
filePathConstants="../Examples/Basic/ledBlink/Constants/constants.py"                #Path to constants.py file. If not present an empty file will be created. 


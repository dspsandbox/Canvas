######################################################################################
# NET2FPGA run3_setConstants
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
######################################################################################
import paramiko
import numpy as np
######################################################################################
execfile("SETTINGS.py")                                                              #Load settings

ssh = paramiko.SSHClient()
ssh.load_system_host_keys()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(FPGA_SSH_IP, username=FPGA_SSH_USERNAME,password=FPGA_SSH_PASSWORD)      #Connect to FPGA via SSH

#GET CONSTANTS
const1Bit=np.zeros(256)                                                              #Initialize 1Bit constants
const32Bit=np.zeros(256)                                                             #Initialize 32Bit constants
execfile(filePathConstants)                                                          #Load constants file

#CONSTRUCT 1BIT/32BIT CONSTANTS FILES
f1Bit=open(filePathConst1Bit,"wb+")                                                  
f32Bit=open(filePathConst32Bit,"wb+")
for i in range(0,256):
    f1Bit.write("%d   %d\r\n"%(i,const1Bit[i]))
    f32Bit.write("%d   %d\r\n"%(i,const32Bit[i]))
f1Bit.close()
f32Bit.close()

#SEND/SET ON FPGA
sftp = ssh.open_sftp()                                                               #Opens SFTP (SSH File Transfer Protocol)
sftp.put(filePathConst1Bit,"/home/NET2FPGA/const1Bit.txt")                           #Send const1Bit.txt to FPGA (PS)
sftp.put(filePathConst32Bit,"/home/NET2FPGA/const32Bit.txt")                         #Send const32Bit.txt to FPGA (PS)
ssh.exec_command("/home/NET2FPGA/setConstants")                                      #Set constants on FPGA (PL)
ssh.close()

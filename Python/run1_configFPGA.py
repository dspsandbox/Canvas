######################################################################################
# NET2FPGA run1_configFPGA
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
######################################################################################
import paramiko

######################################################################################
execfile("SETTINGS.py")                                                              #Load setting
ssh = paramiko.SSHClient()
ssh.load_system_host_keys()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(FPGA_SSH_IP, username=FPGA_SSH_USERNAME,password=FPGA_SSH_PASSWORD)      #Connect to FPGA via SSH

#MAKE FILE STRUCTURE
ssh.exec_command("rm -r /home/NET2FPGA")                                             #Remove existing NET2FPGA folder
ssh.exec_command("mkdir /home/NET2FPGA")                                             #Creates new NET2FPGA folder           

#TRANSFER/COMPILE setBitstream.sh
sftp = ssh.open_sftp()                                                               #Opens SFTP (SSH File Transfer Protocol)
sftp.put(filePathSetBitstream,"/home/NET2FPGA/setBitstream.sh")                      #Sends setBitstream.sh
ssh.exec_command("sed -i -e 's/\r$//' /home/NET2FPGA/setBitstream.sh"  )             #Remove spurious CR characters
ssh.exec_command("chmod +x /home/NET2FPGA/setBitstream.sh")                          #Makes setBitstream.sh executable

#TRANSFER/COMPILE setConstants.c
sftp.put(filePathSetConstants,"/home/NET2FPGA/setConstants.c")                       #Sends setConstants.c
ssh.exec_command("gcc /home/NET2FPGA/setConstants.c -o /home/NET2FPGA/setConstants") #Compiles setConstants.c

#CONFIGURE BOOT BEHAVIOUR
rcLocalContent=""
rcLocalContent+="#!bin/sh -e\n"
if autoBitstream:
    rcLocalContent+="/home/NET2FPGA/setBitstream.sh \n"
# if autoConstants:
    # rcLocalContent+="/home/NET2FPGA/setConstants\n"
rcLocalContent+="exit 0\n"

f=open(filePathRcLocal,"wb+")
f.write(rcLocalContent)
f.close()

sftp.put(filePathRcLocal,"/etc/rc.local")                                            #Configures rc.local file (is executed after boot of PS)

# sftp.put("../FPGA/Zynq_PS/const32Bit.txt","/home/NET2FPGA/const32Bit.txt")
# sftp.put("../FPGA/Zynq_PS/const1Bit.txt","/home/NET2FPGA/const1Bit.txt")
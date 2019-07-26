######################################################################################
# NET2FPGA run2_configFPGA
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


#TRANSFER/RUN bitstream.bit
sftp = ssh.open_sftp()                                                               #Open SFTP (SSH File Transfer Protocol)
sftp.put(filePathBitstream,"/home/NET2FPGA/bitstream.bit")                           #Send bitstream.bit to FPGA (PS)
ssh.exec_command("/home/NET2FPGA/setBitstream.sh")                                   #Run bitstream.bit on FPGA (PL)
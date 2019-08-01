###############################################################################
# NET2FPGA FPGA lib
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
###############################################################################

import paramiko


class FPGA_CLASS: 
   
    def __init__(self,settings):
        #SSH objects
        self.ssh=None
        self.sftp=None
        #settings
        self.settings=settings
        #Debug
        self.debug=True
        return
    
    def connect(self):
        if self.debug:
            print("Connect to FPGA")
        self.ssh = paramiko.SSHClient()
        self.ssh.load_system_host_keys()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.ssh.connect(self.settings.FPGA_SSH_IP, username=self.settings.FPGA_SSH_USERNAME,password=self.settings.FPGA_SSH_PASSWORD)      
        self.sftp = self.ssh.open_sftp() 
        return
        
    def disconnect(self):
        if self.debug:
            print("Disconnect from FPGA\n")
        self.ssh.close()
        return
    
    def execCommand(self,command):
        stdin, stdout,stderr=self.ssh.exec_command(command)
        if self.debug:
            stdoutContent=stdout.read()
            stderrContent=stderr.read()
            if len(stdoutContent)>0:
                print(stdoutContent)
            if len(stderrContent)>0:
                print(stderrContent)
        return
    
    def initFileStructure(self):
        if self.debug:
            print("Init FPGA file structure")
        self.execCommand("rm -r /home/NET2FPGA") #Remove existing NET2FPGA folder
        self.execCommand("mkdir /home/NET2FPGA") #Creates new NET2FPGA folder   
        return
    
    def initConstantsLoader(self):
        if self.debug:
            print("Init constants loader")
        self.sftp.put(self.settings.filePathSetConstants,"/home/NET2FPGA/constantsLoader.c") #Sends constantsLoader.c
        self.execCommand("gcc /home/NET2FPGA/constantsLoader.c -o /home/NET2FPGA/constantsLoader") #Compiles constantsLoader.c
        self.execCommand("chmod +x /home/NET2FPGA/constantsLoader") #Makes constantsLoader executable
        return
        
    def initBitstreamLoader(self):
        if self.debug:
            print("Init bitstream loader")
        self.sftp.put(self.settings.filePathSetBitstream,"/home/NET2FPGA/bitstreamLoader.sh") #Sends bitstreamLoader.sh
        self.execCommand("sed -i -e 's/\r$//' /home/NET2FPGA/bitstreamLoader.sh") #Remove spurious CR characters
        self.execCommand("chmod +x /home/NET2FPGA/bitstreamLoader.sh") #Makes bitstreamLoader.sh executable
        return
        
    def configBoot(self):
        rcLocalContent=""
        rcLocalContent+="#!bin/sh -e\n"
        if self.settings.autoBitstream:
            rcLocalContent+="/home/NET2FPGA/bitstreamLoader.sh \n"
        if self.settings.autoConstants:
            rcLocalContent+="/home/NET2FPGA/constantsLoader \n"
        rcLocalContent+="exit 0\n"

        f=open(self.settings.filePathRcLocal,"wb+")
        f.write(rcLocalContent)
        f.close()
        self.sftp.put(self.settings.filePathRcLocal,"/etc/rc.local")    
        return
        
    def transferBitstream(self):
        self.sftp.put(self.settings.filePathBitstream,"/home/NET2FPGA/bitstream.bit") #Send bitstream.bit to FPGA (PS)
        return
        
        
    def loadBitstream(self):
        self.execCommand("/home/NET2FPGA/bitstreamLoader.sh") #Execute PS -> PL bitstream loader
        return
        
    def constructConstantsFiles(self,const1Bit,const32Bit):
        f1Bit=open(self.settings.filePathConst1Bit,"wb+")                                                  
        f32Bit=open(self.settings.filePathConst32Bit,"wb+")
        for i in range(0,256):
            f1Bit.write("%d   %d\r\n"%(i,const1Bit[i]))
            f32Bit.write("%d   %d\r\n"%(i,const32Bit[i]))
        f1Bit.close()
        f32Bit.close()
            
        
    def transferConstants(self):
        self.sftp.put(self.settings.filePathConst1Bit,"/home/NET2FPGA/const1Bit.txt") #Send const1Bit.txt to FPGA (PS)
        self.sftp.put(self.settings.filePathConst32Bit,"/home/NET2FPGA/const32Bit.txt") #Send const32Bit.txt to FPGA (PS)
        return
        
        
    def loadConstants(self):
        self.execCommand("/home/NET2FPGA/constantsLoader") #Execute PS -> PL constants loader    
        return
        
        
        
    
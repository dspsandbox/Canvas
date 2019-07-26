###############################################################################
# NET2FPGA library
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
###############################################################################

import socket
import re
import os
import time
from shutil import copyfile,rmtree



class CLIENT: 
    ###########################################################################
    #INTERNAL METHODS
    ###########################################################################
    def __init__(self,TCP_IP,TCP_PORT):
        #TCP communication settings
        self.TCP_IP=TCP_IP
        self.TCP_PORT=TCP_PORT
        self.BUFFER_SIZE=1024
        #TCP communication delimiters
        self.TCP_START="\n__TCP_START__\n"
        self.TCP_END="\n__TCP_END__\n"
        self.TCP_ITEM_DELIMITER=   "\n__TCP_ITEM_DELIMITER__\n"
        self.TCP_SUBITEM_DELIMITER="\n__TCP_SUBITEM_DELIMITER__\n"
        #Workspace settings (server side)
        self.process=""
        self.pathWorkspace=""
        self.key=""
        #Debug
        self.debug=True
        
      
    
    
    def TCP_transmit(self,message):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((self.TCP_IP, self.TCP_PORT))
        s.send(message)
        data=""
        while(1):
            recv = s.recv(self.BUFFER_SIZE)
            data+=recv
            if not recv: break 
            
        s.close()
        return data
    
    def recvDataParser(self,recvData):
        if re.findall("^"+self.TCP_START+".*"+self.TCP_END+"$",recvData,re.DOTALL):
            recvData=recvData[len(self.TCP_START):-len(self.TCP_END)]
            recvDataParsed=recvData.split(self.TCP_ITEM_DELIMITER)
            for i in range(0,len(recvDataParsed)):
                recvDataParsed[i]= (recvDataParsed[i] ).split(self.TCP_SUBITEM_DELIMITER)   
            return recvDataParsed
        else:
            print "ERROR: cannot parse: "+recvData
            return [[]]
            

    def sendDataParser(self,sendData):
        sendDataParsed=[]
        for i in range(0,len(sendData)):
            sendDataParsed+=[self.TCP_SUBITEM_DELIMITER.join(sendData[i])]
        sendDataParsed=self.TCP_ITEM_DELIMITER.join(sendDataParsed)
        
        sendDataParsed=self.TCP_START+sendDataParsed+self.TCP_END
        return sendDataParsed
    
    ###########################################################################
    #CLIENT METHODS
    ###########################################################################
        
    def createWorkspace(self):
        if self.debug:
            print "CREATE WORKSPACE"
        sendData=[["CREATE WORKSPACE"]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process],[self.pathWorkspace],[self.key]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print ("Workspace: %s"%self.pathWorkspace)
            print ("Key: %s"%self.key) 
            print("")
        return
        
        
    def setNetInput(self,filePathNetInput):
        if self.debug:
            print("SET NET INPUT")
        f=open(filePathNetInput,"rb")
        fileContent=f.read()
        f.close()
        sendData=[["SET NET INPUT"],[self.pathWorkspace],[self.key],[fileContent]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return
  

    def runNetParser(self):
        
        if self.debug:
            print("RUN NET PARSER")
        sendData=[["RUN NET PARSER"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return
    
    def checkDatabase(self):
        if self.debug:
            print("CHECK DATABASE")
        sendData=[["CHECK DATABASE"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process],[pathDatabaseEntry]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print ("Database entry: %s"%pathDatabaseEntry)
            print("")
        return pathDatabaseEntry
   
    def getContentDatabaseEntry(self,databaseEntry):
        if self.debug:
            print("GET CONTENT DATABASE ENTRY")
        sendData=[["GET CONTENT DATABASE ENTRY"],[self.pathWorkspace],[self.key],[databaseEntry]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return
   
   
   
    def runNet2Vhdl(self):
        if self.debug:
            print("RUN NET2VHDL")
        sendData=[["RUN NET2VHDL"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return
        

    def requestImplementation(self):
        if self.debug:
            print("REQUEST IMPLEMENTATION")
        sendData=[["REQUEST IMPLEMENTATION"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return
    
        
    def getActiveProcess(self):
        if self.debug:
            print("GET ACTIVE PROCESS")
        sendData=[["GET ACTIVE PROCESS"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return self.process

    def getWorkspaceContent(self,pathOutput,filePathConstants):
        if self.debug:
            print("GET WORKSPACE CONTENT")
        sendData=[["GET WORKSPACE CONTENT"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process],dirNameList,filePathList,fileContentList]=recvDataParsed
        
        for dirName in dirNameList:
            dirName=os.path.join(pathOutput,dirName)
            if os.path.isdir(dirName):
                rmtree(dirName)
            os.makedirs(dirName)
        for filePath,fileContent in zip(filePathList,fileContentList):
            filePath=os.path.join(pathOutput,filePath)
            f=open(filePath,"wb+")
            f.write(fileContent)
            f.close()
            
            pathConstants=os.path.dirname(filePathConstants)
            if not os.path.isdir(pathConstants):
                os.makedirs(pathConstants)
            if not os.path.isfile(filePathConstants):
                fileName=os.path.join(pathConstants,"constants.py")
                f=open(fileName,"wb+")
                f.write("# CONSTANTS FILE\r\n")
                f.write("# Please set the 1Bit and 32Bit constant registers you need (by default they are set to 0). \r\n")
                f.write("\r\n# For 1Bit constants registers use:\r\n") 
                f.write("# const1Bit[<regAddr>]=<regVal>  where <regAddr>=0,1,...,255    and  <regVal>=0,1\r\n")
                f.write("\r\n# For 32Bit constants registers use:\r\n")
                f.write("# const32Bit[<regAddr>]=<regVal>  where <regAddr>=0,1,...,255    and  <regVal>=-2^31,...,0,...,2^31-1\r\n")
                f.write("\r\n# Example:\r\n\r\n")
                f.write("# const1Bit[0]=0 \r\n")
                f.write("# const1Bit[3]=1 \r\n")
                f.write("# const32Bit[0]=-52 \r\n")
                f.write("# const32Bit[1]=1024 \r\n")
                f.close()
        if self.debug:   
            print ("Response/process: %s"%self.process)
            print ("Workspace content written to: %s"%pathOutput)
            print("")
        return 
    
    def clearWorkspace(self):
        if self.debug:
            print("CLEAR WORKSPACE")
        sendData=[["CLEAR WORKSPACE"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return self.process
    
    
    def eraseWorkspace(self):
        if self.debug:
            print("ERASE WORKSPACE")
        sendData=[["ERASE WORKSPACE"],[self.pathWorkspace],[self.key]]
        sendDataParsed=self.sendDataParser(sendData)
        recvData=self.TCP_transmit(sendDataParsed)
        recvDataParsed=self.recvDataParser(recvData)
        [[self.process]]=recvDataParsed
        if self.debug:
            print ("Response/process: %s"%self.process)
            print("")
        return self.process
    
    
    
    



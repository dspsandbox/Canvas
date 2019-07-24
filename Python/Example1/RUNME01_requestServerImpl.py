######################################################################
# NET2FPGA 
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
######################################################################
import NET2FPGA
import time


######################################################################
# PARAMETERS
######################################################################
#SERVER SETTINGS (please do not change)
TCP_IP_SERVER = 'localhost'  
TCP_PORT_SERVER = 5000

#Path to the input .net file
filePathNetInput="../LTSpice/FPGA/ExampleCircuits/Example1/mainCircuit.net"

#Path to the output folder (will beautomatically created)
pathOutput="OUTPUT/LED" 


######################################################################
c=NET2FPGA.CLIENT(TCP_IP_SERVER,TCP_PORT_SERVER)                      #Instantiate NET2FPGA class object 


c.createWorkspace()                                                   #Create new workspace on server
c.setNetInput(filePathNetInput)                                       #Send .net input file to server
c.runNetParser()                                                      #Parse .net file
databaseEntry=c.checkDatabase()                                       #Check database for existing project
databaseEntry=False
if databaseEntry:                                                     #DATABASE ENTRY MATCH 
    c.getContentDatabaseEntry(databaseEntry)                          #Copy contents of database entry to workspace 

else:                                                                 #NO DATABASE ENTRY MATCH    
    c.runNet2Vhdl()                                                   #Convert parsed .net file to DSP_core.vhd 
    c.requestImplementation()                                         #Request implementation. 
    print("Waiting for synthesis/implementation.\nCoffee time...\n")  
    c.debug=False                                                     #Turn OFF print of messages 
    while(1): 
        time.sleep(1)                                                 #Wait 1s
        activeProcess=c.getActiveProcess()                            #Get active process/status of the workspace on the server side
        if activeProcess=="OK/IDLE" or activeProcess=="ERROR":        #Waits for synthesis/implementation ready or an error flag
            break
    c.debug=True                                                      #Turn ON print of messages
    
    
    
c.getWorkspaceContent(pathOutput)                                     #Get workspace contents and save it locally
# c.eraseWorkspace()                                                    #Erase workspace on server side 

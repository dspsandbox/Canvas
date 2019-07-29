######################################################################
# NET2FPGA run0_server
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
######################################################################
import NET2FPGA
import time

######################################################################
execfile("SETTINGS.py")                                               #Load settings
c=NET2FPGA.CLIENT(SERVER_TCP_IP,SERVER_TCP_PORT)                      #Instantiate NET2FPGA class object 


c.createWorkspace()                                                   #Create new workspace on server
c.setNetInput(filePathNetInput)                                       #Send .net input file to server
c.runNetParser()                                                      #Parse .net file
databaseEntry=c.checkDatabase()                                       #Check database for existing project
if databaseEntry:                                                     #DATABASE ENTRY MATCH 
    c.getContentDatabaseEntry(databaseEntry)                          #Copy contents of database entry to workspace 

else:                                                                 #NO DATABASE ENTRY MATCH    
    c.runNet2Vhdl()                                                   #Convert parsed .net file to DSP_core.vhd 
    c.requestImplementation()                                         #Request implementation. 
    print("Waiting for synthesis/implementation.\nCoffee time...\n")  
    c.debug=False                                                     #Turn OFF print of messages 
    while(1): 
        time.sleep(5)                                                 #Wait 5s
        activeProcess=c.getActiveProcess()                            #Get active process/status of the workspace on the server side
        if activeProcess=="OK/IDLE" or activeProcess=="ERROR":        #Waits for synthesis/implementation ready or an error flag
            break
    c.debug=True                                                      #Turn ON print of messages
    
    
    
c.getWorkspaceContent(pathOutput,filePathConstants)                   #Get workspace contents, save it locally and creates constants.py file (in case it does not exist)
c.eraseWorkspace()                                                    #Erase workspace on server side 

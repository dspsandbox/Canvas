############################################################################
# NET2FPGA 0_server
#
# MIT License
# Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
############################################################################
import NET2FPGA
import time
import settings                                                            #Load settings
############################################################################
server=NET2FPGA.SERVER.SERVER_CLASS(settings)                              #Instantiate NET2FPGA server class object 

server.createWorkspace()                                                   #Create new workspace on server
server.setNetInput(settings.filePathNetInput)                              #Send .net input file to server
server.runNetParser()                                                      #Parse .net file
databaseEntry=server.checkDatabase()                                       #Check database for existing project
if databaseEntry:                                                          #DATABASE ENTRY MATCH 
    server.getContentDatabaseEntry(databaseEntry)                          #Copy contents of database entry to workspace 

else:                                                                      #NO DATABASE ENTRY MATCH    
    server.runNet2Vhdl()                                                   #Convert parsed .net file to DSP_core.vhd 
    server.requestImplementation()                                         #Request implementation. 
    print("Waiting for synthesis/implementation.\nCoffee time...\n")  
    server.debug=False                                                     #Turn OFF print of messages 
    while(1):                                                             
        activeProcess=server.getActiveProcess()                            #Get active process/status of the workspace on the server side
        if activeProcess=="OK/IDLE" or activeProcess=="ERROR":             #Checks if synthesis/implementation is ready or an error flag has been raised
            break
        time.sleep(5)                                                      #Wait 5s
    server.debug=True                                                      #Turn ON print of messages
    
server.getWorkspaceContent(setings.pathOutput,settings.filePathConstants)  #Get workspace contents, save it locally and creates constants.py file (in case it does not exist)
server.eraseWorkspace()                                                    #Erase workspace on server side 

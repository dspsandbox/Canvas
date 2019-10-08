#######################################################################
# Canvas main.py (GUI interface)
#
# MIT License
# Copyright (c) 2019 DSPsandbox (Pau Gomez pau.gomez@dspsandbox.org)
#######################################################################


import sys
from PyQt5 import uic, QtWidgets , QtGui , QtCore
import socket
import xml.etree.ElementTree as ET
import traceback
import os
import sys
import subprocess
from shutil import copyfile,rmtree, copytree
import re
import ctypes
import numpy as np
import ast
import paramiko
from datetime import datetime


pathResoures="Resources"
myappid = 'canvas.gui'
if sys.platform.startswith('win'):
    ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)

qtInterfaceFile = os.path.join(pathResoures,"GUI","interface.ui" )
Ui_MainWindow, QtBaseClass = uic.loadUiType(qtInterfaceFile)



class CanvasApp(QtWidgets.QMainWindow, Ui_MainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        Ui_MainWindow.__init__(self)
        self.setupUi(self)
        #TCP communication
        self.frameTag="communicationContainer"
        self.BUFFER_SIZE=1024
        self.xmlSend=None
        self.xmlRecv=None
        self.lastLogMessageList=[]
        #Bistream (escape decoding)
        self.bitstream=""
        #init log an file strucures
        self.logList=[]
        self.projectName=""
        self.projectDirPath=""
        self.projectFilePath=""
        self.setWindowIcon(QtGui.QIcon(os.path.join(pathResoures,"GUI","iconWhiteBackground.png")))
        #Timer
        self.timerSynthImpl = QtCore.QTimer()
        #SSH objects
        self.ssh=None
        self.sftp=None
        #constants dict
        self.x1ConstDict={}
        self.x32ConstDict={}
        #init message
        self.forceClose=False
        self.timerInit = QtCore.QTimer()
        #callbacks
        self.connectCallbacks()
        #start init timer (welcome message)
        self.timerInit.start(100)
        return

###############################################################################
    def closeEvent(self, event):
        if not self.forceClose:
            msgBox = QtWidgets.QMessageBox()
            msgBox.setWindowTitle("Save")
            msgBox.setWindowFlags(QtCore.Qt.CustomizeWindowHint | QtCore.Qt.WindowTitleHint) #Remove logo

            msgBox.setIcon(QtWidgets.QMessageBox.Question)
            msgBox.setText("Save project ?")
            msgBox.setInformativeText(self.projectDirPath)
            msgBox.setStandardButtons(QtWidgets.QMessageBox.Yes| QtWidgets.QMessageBox.No| QtWidgets.QMessageBox.Cancel  )
            msgBox.setDefaultButton(QtWidgets.QMessageBox.Yes)
            reply = msgBox.exec_()

            if reply == QtWidgets.QMessageBox.Yes:
                self.saveCallback()
            elif reply== QtWidgets.QMessageBox.Cancel:
                event.ignore()
            else:
                pass

        return
###############################################################################
    def connectCallbacks(self):
        #Project
        self.actionNew.triggered.connect(self.newCallback)
        self.actionOpen.triggered.connect(self.openCallback)
        self.actionSaveAs.triggered.connect(self.saveAsCallback)
        self.actionSave.triggered.connect(self.saveCallback)
        self.actionQuit.triggered.connect(self.close)
        self.actionInspectProjectDirectory.triggered.connect(self.inspectProjectDirectoryCallback)
        self.actionLoadDefaultSettings.triggered.connect(self.loadDefaultSettingsCallback)
        self.actionInspectSettingsDirectory.triggered.connect(self.inspectSettingsDirectoryCallback)
        #SERVER
        self.pushButton_serverVerify.clicked.connect(self.verifyServerCallback)
        self.pushButton_requestNetVhdl.clicked.connect(self.requestNetVhdlCallback)
        self.pushButton_requestSynthImpl.clicked.connect(self.requestSynthImplCallback)
        self.pushButton_serverRunSelected.clicked.connect(self.serverRunSelectedCallback)
        self.pushButton_abort.clicked.connect(self.abortCallback)
        #FPGA
        self.pushButton_fpgaVerify.clicked.connect(self.fpgaVerifyCallback)
        self.pushButton_fpgaReboot.clicked.connect(self.fpgaRebootCallback)
        self.tableWidget_x1_const.itemChanged.connect(self.x1ItemChangedCallback)
        self.tableWidget_x32_const.itemChanged.connect(self.x32ItemChangedCallback)
        self.pushButton_sshConfigFpga.clicked.connect(self.sshConfigFpgaCallback)
        self.pushButton_sshLoadBitstream.clicked.connect(self.sshLoadBitstreamCallback)
        self.pushButton_sshLoadConstants.clicked.connect(self.sshLoadConstantsCallback)
        self.pushButton_fpgaRunSelected.clicked.connect(self.fpgaRunSelectedCallback)
        #TIMER
        self.timerSynthImpl.timeout.connect(self.timerSynthImplCallback)
        self.timerInit.timeout.connect(self.timerInitCallback)
        return

    def loadDefaultSettingsCallback(self):
        try:
            tree = ET.parse(os.path.join(pathResoures,"Settings","defaultSettings.xml"))
            root = tree.getroot()
            if len(root.findall("SERVER"))>0:
                serverTag=root.findall("SERVER")[0]
                if len(serverTag.findall("IP"))>0 : self.lineEdit_serverIP.setText(serverTag.findall("IP")[0].text)
                if len(serverTag.findall("Port"))>0 : self.lineEdit_serverPort.setText(serverTag.findall("Port")[0].text)
                if len(serverTag.findall("Id"))>0 : self.lineEdit_workspaceId.setText(serverTag.findall("Id")[0].text)
                if len(serverTag.findall("Key"))>0 : self.lineEdit_workspaceKey.setText(serverTag.findall("Key")[0].text)
                if len(serverTag.findall("checkBox_requestNetVhdl"))>0 : self.checkBox_requestNetVhdl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestNetVhdl")[0].text))
                if len(serverTag.findall("checkBox_requestSynthImpl"))>0 : self.checkBox_requestSynthImpl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestSynthImpl")[0].text))
            if len(root.findall("FPGA"))>0:
                fpgaTag=root.findall("FPGA")[0]
                if len(fpgaTag.findall("IP"))>0 : self.lineEdit_fpgaIP.setText(fpgaTag.findall("IP")[0].text)
                if len(fpgaTag.findall("Port"))>0 : self.lineEdit_fpgaPort.setText(fpgaTag.findall("Port")[0].text)
                if len(fpgaTag.findall("User"))>0 : self.lineEdit_fpgaUser.setText(fpgaTag.findall("User")[0].text)
                if len(fpgaTag.findall("Pwd"))>0 : self.lineEdit_fpgaPwd.setText(fpgaTag.findall("Pwd")[0].text)
                if len(serverTag.findall("checkBox_requestNetVhdl"))>0 : self.checkBox_requestNetVhdl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestNetVhdl")[0].text))
                if len(serverTag.findall("checkBox_requestSynthImpl"))>0 : self.checkBox_requestSynthImpl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestSynthImpl")[0].text))
            self.appendLogMessage("Load default settings",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Load default settings",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def timerInitCallback(self):
        self.timerInit.stop()
        msgBox = QtWidgets.QMessageBox()
        msgBox.setWindowFlags(QtCore.Qt.CustomizeWindowHint | QtCore.Qt.WindowTitleHint) #Remove logo
        msgBox.setWindowTitle("Welcome to Canvas")
        msgBox.setIcon(QtWidgets.QMessageBox.Question)
        msgBox.setText("OPEN or NEW project?")
        pButtonOpen = msgBox.addButton("Open",QtWidgets.QMessageBox.YesRole);
        pButtonNew = msgBox.addButton("New",QtWidgets.QMessageBox.YesRole);
        pButtonCancel = msgBox.addButton("Cancel",QtWidgets.QMessageBox.YesRole);
        msgBox.setDefaultButton(pButtonOpen)
        reply = msgBox.exec_()
        if reply == 0:
            self.openCallback()
        elif reply==1:
            self.newCallback()
        if self.projectDirPath=="":
            self.forceClose=True
            self.close()
        return
###############################################################################
    def inspectSettingsDirectoryCallback(self):
        try:
            if sys.platform.startswith('win'):
                os.startfile(os.path.join(pathResoures,"Settings"))
            else:
                opener ="open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, os.path.join(pathResoures,"Settings")])
            self.appendLogMessage("Inspect settings directory",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Inspect settings directory",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def inspectProjectDirectoryCallback(self):
        try:
            if sys.platform.startswith('win'):
                os.startfile(self.projectDirPath)
            else:
                opener ="open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, self.projectDirPath])
            self.appendLogMessage("Inspect project directory",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Inspect project directory",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def newCallback(self):
        try:
            #FileDialog
            fileDialog=QtWidgets.QFileDialog(self)
            projectFilePath = fileDialog.getSaveFileName(self, 'New project', os.path.join(self.projectDirPath,'*.prj'))[0]
            #parsing response
            projectName=re.sub("\.\w*", "", os.path.basename(projectFilePath)) #removing any termination
            if len(projectName)>0:
                self.projectName=projectName
                if os.path.isfile(os.path.join(os.path.dirname(projectFilePath),(self.projectName+".prj"))):
                    self.projectFilePath=os.path.abspath(os.path.join(os.path.dirname(projectFilePath),(self.projectName+".prj")))
                    self.projectDirPath=os.path.dirname(self.projectFilePath)
                else:
                    self.projectDirPath=os.path.abspath(os.path.join(os.path.dirname(projectFilePath),self.projectName))
                    self.projectFilePath=os.path.join(self.projectDirPath,(self.projectName+".prj"))
                #Create project folder if necessary
                if not(os.path.isdir( self.projectDirPath)): os.mkdir(self.projectDirPath)
                #Init input folder
                inputDirPath=os.path.join(self.projectDirPath,"Input")
                inputFilePath=os.path.join(inputDirPath,"mainCircuit.asc")
                if os.path.isdir(inputDirPath): rmtree(inputDirPath)
                os.mkdir(inputDirPath)
                f=open(inputFilePath,"wb+")
                f.close()
                #Create .prj
                root=ET.Element("Canvas")
                f=open(self.projectFilePath,"wb+")
                f.write(ET.tostring(root))
                f.close()
                #Update window title
                self.setWindowTitle("Canvas - "+(self.projectDirPath))

                self.appendLogMessage("New project",messageType="OK")
            else:
                self.appendLogMessage("New project",messageType="WARNING",message="Empty project name.")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("New project",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def openCallback(self,log=True):
        try:
            #FileDialog
            fileDialog=QtWidgets.QFileDialog(self)
            projectFilePath = fileDialog.getOpenFileName(self, 'Open project', os.path.join(self.projectDirPath,'*.prj'))[0]
            #parsing response
            if len(projectFilePath)>0:
                self.projectFilePath=os.path.abspath(projectFilePath)
                self.projectDirPath=os.path.dirname(projectFilePath)
                self.projectName=re.sub("\.\w*", "", os.path.basename(projectFilePath))
                #Update window title
                self.setWindowTitle("Canvas - "+(self.projectDirPath))

                tree = ET.parse(self.projectFilePath)
                root = tree.getroot()
                if len(root.findall("SERVER"))>0:
                    serverTag=root.findall("SERVER")[0]
                    if len(serverTag.findall("IP"))>0 : self.lineEdit_serverIP.setText(serverTag.findall("IP")[0].text)
                    if len(serverTag.findall("Port"))>0 : self.lineEdit_serverPort.setText(serverTag.findall("Port")[0].text)
                    if len(serverTag.findall("Id"))>0 : self.lineEdit_workspaceId.setText(serverTag.findall("Id")[0].text)
                    if len(serverTag.findall("Key"))>0 : self.lineEdit_workspaceKey.setText(serverTag.findall("Key")[0].text)
                    if len(serverTag.findall("checkBox_requestNetVhdl"))>0 : self.checkBox_requestNetVhdl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestNetVhdl")[0].text))
                    if len(serverTag.findall("checkBox_requestSynthImpl"))>0 : self.checkBox_requestSynthImpl.setChecked(ast.literal_eval(serverTag.findall("checkBox_requestSynthImpl")[0].text))
                if len(root.findall("FPGA"))>0:
                    fpgaTag=root.findall("FPGA")[0]
                    if len(fpgaTag.findall("IP"))>0 : self.lineEdit_fpgaIP.setText(fpgaTag.findall("IP")[0].text)
                    if len(fpgaTag.findall("Port"))>0 : self.lineEdit_fpgaPort.setText(fpgaTag.findall("Port")[0].text)
                    if len(fpgaTag.findall("User"))>0 : self.lineEdit_fpgaUser.setText(fpgaTag.findall("User")[0].text)
                    if len(fpgaTag.findall("Pwd"))>0 : self.lineEdit_fpgaPwd.setText(fpgaTag.findall("Pwd")[0].text)
                    if len(fpgaTag.findall("radioButton_autoBitstreamConstantsOff"))>0 : self.radioButton_autoBitstreamConstantsOff.setChecked(ast.literal_eval(fpgaTag.findall("radioButton_autoBitstreamConstantsOff")[0].text))
                    if len(fpgaTag.findall("radioButton_autoBitstreamConstantsOn"))>0 : self.radioButton_autoBitstreamConstantsOn.setChecked(ast.literal_eval(fpgaTag.findall("radioButton_autoBitstreamConstantsOn")[0].text))
                    x1ConstList=[]
                    x32ConstList=[]
                    self.x1ConstDict={}
                    self.x32ConstDict={}
                    if len(fpgaTag.findall("x1ConstList"))>0 : x1ConstList=ast.literal_eval(fpgaTag.findall("x1ConstList")[0].text)
                    if len(fpgaTag.findall("x32ConstList"))>0 : x32ConstList=ast.literal_eval(fpgaTag.findall("x32ConstList")[0].text)
                    if len(fpgaTag.findall("x1ConstDict"))>0 : self.x1ConstDict=ast.literal_eval(fpgaTag.findall("x1ConstDict")[0].text)
                    if len(fpgaTag.findall("x32ConstDict"))>0 : self.x32ConstDict=ast.literal_eval(fpgaTag.findall("x32ConstDict")[0].text)
                    self.generateTab()
                    for row in range(len(x1ConstList)):
                        self.tableWidget_x1_const.item(row, 0).setText(x1ConstList[row])
                    for row in range(len(x32ConstList)):
                        self.tableWidget_x32_const.item(row, 0).setText(x32ConstList[row])
                    if len(fpgaTag.findall("checkBox_sshConfigFpga"))>0 : self.checkBox_sshConfigFpga.setChecked(ast.literal_eval(fpgaTag.findall("checkBox_sshConfigFpga")[0].text))
                    if len(fpgaTag.findall("checkBox_sshLoadBitstream"))>0 : self.checkBox_sshLoadBitstream.setChecked(ast.literal_eval(fpgaTag.findall("checkBox_sshLoadBitstream")[0].text))
                    if len(fpgaTag.findall("checkBox_sshLoadConstants"))>0 : self.checkBox_sshLoadConstants.setChecked(ast.literal_eval(fpgaTag.findall("checkBox_sshLoadConstants")[0].text))
                self.appendLogMessage("Open project",messageType="OK")
            else:
                self.appendLogMessage("Open project",messageType="WARNING",message="Empty project name.")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Open project",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def saveCallback(self):
        try:
            root=ET.Element("Canvas")
            serverTag=ET.SubElement(root,"SERVER")
            ET.SubElement(serverTag,"IP").text=self.lineEdit_serverIP.text()
            ET.SubElement(serverTag,"Port").text=self.lineEdit_serverPort.text()
            ET.SubElement(serverTag,"Id").text=self.lineEdit_workspaceId.text()
            ET.SubElement(serverTag,"Key").text=self.lineEdit_workspaceKey.text()
            ET.SubElement(serverTag,"checkBox_requestNetVhdl").text=str(self.checkBox_requestNetVhdl.isChecked())
            ET.SubElement(serverTag,"checkBox_requestSynthImpl").text=str(self.checkBox_requestSynthImpl.isChecked())

            fpgaTag=ET.SubElement(root,"FPGA")
            ET.SubElement(fpgaTag,"IP").text=self.lineEdit_fpgaIP.text()
            ET.SubElement(fpgaTag,"Port").text=self.lineEdit_fpgaPort.text()
            ET.SubElement(fpgaTag,"User").text=self.lineEdit_fpgaUser.text()
            ET.SubElement(fpgaTag,"Pwd").text=self.lineEdit_fpgaPwd.text()
            ET.SubElement(fpgaTag,"radioButton_autoBitstreamConstantsOff").text=str(self.radioButton_autoBitstreamConstantsOff.isChecked())
            ET.SubElement(fpgaTag,"radioButton_autoBitstreamConstantsOn").text=str(self.radioButton_autoBitstreamConstantsOn.isChecked())
            x1ConstList=[]
            for row in range(self.tableWidget_x1_const.model().rowCount()):
               x1ConstList+=[self.tableWidget_x1_const.item(row, 0).text()]

            ET.SubElement(fpgaTag,"x1ConstList").text=str(x1ConstList)
            x32ConstList=[]
            for row in range(self.tableWidget_x32_const.model().rowCount()):
               x32ConstList+=[self.tableWidget_x32_const.item(row, 0).text()]
            ET.SubElement(fpgaTag,"x32ConstList").text=str(x32ConstList)
            ET.SubElement(fpgaTag,"x1ConstDict").text=str(self.x1ConstDict)
            ET.SubElement(fpgaTag,"x32ConstDict").text=str(self.x32ConstDict)
            ET.SubElement(fpgaTag,"checkBox_sshConfigFpga").text=str(self.checkBox_sshConfigFpga.isChecked())
            ET.SubElement(fpgaTag,"checkBox_sshLoadBitstream").text=str(self.checkBox_sshLoadBitstream.isChecked())
            ET.SubElement(fpgaTag,"checkBox_sshLoadConstants").text=str(self.checkBox_sshLoadConstants.isChecked())

            f=open(self.projectFilePath,"wb+")
            f.write(ET.tostring(root))
            f.close()
            self.appendLogMessage("Save project",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Save project",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def saveAsCallback(self):
        try:
            projectDirPath_ =self.projectDirPath
            inputDirPath_=os.path.join(projectDirPath_,"Input")
            netInputDirPath_=os.path.join(projectDirPath_,"NET_input")
            netParsedDirPath_=os.path.join(projectDirPath_,"NET_parsed")
            vhdlDirPath_=os.path.join(projectDirPath_,"VHDL")
            zynqDirPath_=os.path.join(projectDirPath_,"Zynq_7010")

            #FileDialog
            fileDialog=QtWidgets.QFileDialog(self)
            projectFilePath = fileDialog.getSaveFileName(self, 'Save project as', os.path.join(self.projectDirPath,'*.prj'))[0]
            #parsing response
            projectName=re.sub("\.\w*", "", os.path.basename(projectFilePath)) #removing any termination
            if len(projectName)>0:
                self.projectName=projectName
                if os.path.isfile(os.path.join(os.path.dirname(projectFilePath),(self.projectName+".prj"))):
                    self.projectFilePath=os.path.abspath(os.path.join(os.path.dirname(projectFilePath),(self.projectName+".prj")))
                    self.projectDirPath=os.path.dirname(self.projectFilePath)
                else:
                    self.projectDirPath=os.path.abspath(os.path.join(os.path.dirname(projectFilePath),self.projectName))
                    self.projectFilePath=os.path.join(self.projectDirPath,(self.projectName+".prj"))

                inputDirPath=os.path.join(self.projectDirPath,"Input")
                netInputDirPath=os.path.join(self.projectDirPath,"NET_input")
                netParsedDirPath=os.path.join(self.projectDirPath,"NET_parsed")
                vhdlDirPath=os.path.join(self.projectDirPath,"VHDL")
                zynqDirPath=os.path.join(self.projectDirPath,"Zynq_7010")

                if os.path.isdir(inputDirPath): rmtree(inputDirPath)
                if os.path.isdir(inputDirPath_): copytree(inputDirPath_,inputDirPath)

                if os.path.isdir(netInputDirPath): rmtree(netInputDirPath)
                if os.path.isdir(netInputDirPath_): copytree(netInputDirPath_,netInputDirPath)

                if os.path.isdir(netParsedDirPath): rmtree(netParsedDirPath)
                if os.path.isdir(netParsedDirPath_): copytree(netParsedDirPath_,netParsedDirPath)

                if os.path.isdir(vhdlDirPath): rmtree(vhdlDirPath)
                if os.path.isdir(vhdlDirPath_): copytree(vhdlDirPath_,vhdlDirPath)

                if os.path.isdir(zynqDirPath): rmtree(zynqDirPath)
                if os.path.isdir(zynqDirPath_): copytree(zynqDirPath_,zynqDirPath)

                #Save .prj file
                self.saveCallback()

                #Update window title
                self.setWindowTitle("Canvas - "+(self.projectDirPath))
                self.appendLogMessage("Save project as",messageType="OK")

            else:
                self.appendLogMessage("Save project as",messageType="WARNING",message="Empty project name.")

        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("Save as",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def verifyServerCallback(self):
        self.appendLogMessage("Verify server connection")
        self.initXmlSend()
        ET.SubElement(self.xmlSend,"processRequest").text="Verify"
        ET.SubElement(self.xmlSend,"workspace").text=self.lineEdit_workspaceId.text()
        ET.SubElement(self.xmlSend,"key").text=self.lineEdit_workspaceKey.text()
        self.TCP_transmit()
        self.logReceivedStatus()
        if ("ERROR" in np.array(self.lastLogMessageList)[:,1] or ("WARNING" in np.array(self.lastLogMessageList)[:,1])):
            self.label_license.setText("unknown")
            self.label_usage.setText("unknown")
        else:
            self.label_license.setText(self.xmlRecv.findall("license")[0].text)
            self.label_usage.setText(self.xmlRecv.findall("usage")[0].text)
        return
###############################################################################
    def requestNetVhdlCallback(self):
        self.appendLogMessage("Request NET/VHDL")
        self.initXmlSend()
        ET.SubElement(self.xmlSend,"processRequest").text="Request NET/VHDL"
        ET.SubElement(self.xmlSend,"workspace").text=self.lineEdit_workspaceId.text()
        ET.SubElement(self.xmlSend,"key").text=self.lineEdit_workspaceKey.text()
        inputDirPath=os.path.join(self.projectDirPath,"Input")

        for dirName, subdirList, fileList in os.walk(inputDirPath):
            for fname in fileList:
                if fname[0] != ".": #Avoids hidden files
                    f=open(os.path.join(dirName,fname),"r")
                    fileContent=f.read()
                    f.close()
                    fileRelPath= (os.path.relpath(os.path.join(dirName,fname),inputDirPath))
                    fileTag=ET.SubElement(self.xmlSend,"file")
                    ET.SubElement(fileTag,"path").text=fileRelPath
                    ET.SubElement(fileTag,"content").text=fileContent
        self.TCP_transmit()
        if len(self.xmlRecv.findall("license"))>0 : self.label_license.setText(self.xmlRecv.findall("license")[0].text)
        if len(self.xmlRecv.findall("usage"))>0 : self.label_usage.setText(self.xmlRecv.findall("usage")[0].text)
        self.logReceivedStatus()
        self.updateFiles()
        try:
            self.generateConstantsDict()
            self.generateTab()
            self.appendLogMessage("|___Update FPGA constants table",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Update FPGA constants table",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def requestSynthImplCallback(self):
        self.appendLogMessage("Request SYNTH/IMPL")
        self.initXmlSend()
        ET.SubElement(self.xmlSend,"processRequest").text="Request SYNTH/IMPL"
        ET.SubElement(self.xmlSend,"workspace").text=self.lineEdit_workspaceId.text()
        ET.SubElement(self.xmlSend,"key").text=self.lineEdit_workspaceKey.text()
        self.TCP_transmit()
        if len(self.xmlRecv.findall("license"))>0 : self.label_license.setText(self.xmlRecv.findall("license")[0].text)
        if len(self.xmlRecv.findall("usage"))>0 : self.label_usage.setText(self.xmlRecv.findall("usage")[0].text)
        self.logReceivedStatus()
        if "No match found in database." in np.array(self.lastLogMessageList)[:,2]:
            self.timerSynthImpl.start(5000)
            self.timerSynthImplCallback()
        else:
            self.updateFiles()
        return

###############################################################################
    def timerSynthImplCallback(self):
        self.initXmlSend()
        ET.SubElement(self.xmlSend,"processRequest").text="Request status SYNTH/IMPL"
        ET.SubElement(self.xmlSend,"workspace").text=self.lineEdit_workspaceId.text()
        ET.SubElement(self.xmlSend,"key").text=self.lineEdit_workspaceKey.text()
        self.TCP_transmit()
        self.updateStatusLogMessage()
        if (self.logList[-1][0]=="|___Status SYNTH/IMPL" and  self.logList[-1][1]=="OK") or self.logList[-1][1]=="ERROR":
            self.timerSynthImpl.stop()
            self.updateFiles()
        return
###############################################################################
    def serverRunSelectedCallback(self):
        if self.checkBox_requestNetVhdl.isChecked(): self.requestNetVhdlCallback()
        if "ERROR" in np.array(self.lastLogMessageList)[:,1]: return
        if self.checkBox_requestSynthImpl.isChecked(): self.requestSynthImplCallback()
        return
###############################################################################
    def abortCallback(self):
        self.clearLogMessage()
        self.timerSynthImpl.stop()
        return
###############################################################################
    def clearLogMessage(self):
        self.textBrowser_log.setText(" ")
        self.logList=[]
        return
###############################################################################
    def appendLogMessage(self,process,messageType="",message= ""):
        if ("|___" not in process):
            if len(self.logList)>0:
                self.logList=self.logList+[["","",""]]
                if messageType=="" and message=="":
                    process+=datetime.now().strftime(" (%d-%b-%Y %H:%M:%S)")

        self.logList=self.logList+[[process,messageType,message]]
        logText='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd"><html><head><meta name="qrichtext" content="1" /><style type="text/css">p, li { white-space: pre-wrap; }</style></head>'
        for logElement in self.logList:
            process=logElement[0]
            messageType=logElement[1]
            message=logElement[2]
            aux='<span>'+process+' '+'</span>'
            if messageType == "OK" :
                aux+='<span style="color:green;">'+messageType+' '+message +"</span>"
            elif  messageType == "INFO":
                aux+='<span style="color:green;">'+messageType+' '+message +"</span>"
            elif messageType == "WARNING":
                aux+='<span style="color:orange;">'+messageType+' '+message +"</span>"
            elif messageType == "ERROR":
                aux+='<span style="color:red;">'+messageType+' '+message +"</span>"
            else:
                aux+='<span>'+messageType+' '+message +"</span>"

            logText+='<p style="margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">'+aux+'</p>'

        logText+='</body></html>'
        self.textBrowser_log.setText(logText)
        vsb=self.textBrowser_log.verticalScrollBar()
        vsb.setValue(vsb.maximum())
        QtWidgets.qApp.processEvents()
        return
###############################################################################
    def logReceivedStatus(self):
        self.lastLogMessageList=[]
        statusTag=self.xmlRecv.findall("status")[0]
        for process in statusTag.findall("process"):
            processName=process.findall("processName")[0].text
            messageType=process.findall("messageType")[0].text
            message=process.findall("message")[0].text
            self.lastLogMessageList+=[[processName,messageType,message]]
            self.appendLogMessage(processName,messageType,message)
        return
###############################################################################
    def updateStatusLogMessage(self):
        statusTag=self.xmlRecv.findall("status")[0]
        for process in statusTag.findall("process"):
            processName=process.findall("processName")[0].text
            messageType=process.findall("messageType")[0].text
            message=process.findall("message")[0].text
            if processName=="|___Status SYNTH/IMPL":
                if len(self.logList)>0:
                    if self.logList[-1][0]=="|___Status SYNTH/IMPL":
                        self.logList=self.logList[:-1]
                        self.appendLogMessage(processName,messageType,message)
                    else:
                        self.appendLogMessage(processName,messageType,message)
                else:
                    self.appendLogMessage(processName,messageType,message)
        return
###############################################################################
    def initXmlSend(self):
        self.xmlSend=ET.Element(self.frameTag)
        return
###############################################################################
    def extractBitstream(self,recvData):
        self.bitstream=""
        startTag=b"<bitstream>"
        endTag=b"</bitstream>"
        indexStartTag=recvData.find(startTag)
        indexEndTag=recvData.find(endTag)
        if (indexStartTag!=-1) and (indexEndTag!=-1):
            self.bitstream=recvData[(indexStartTag+len(startTag)):indexEndTag]
            return (recvData[:indexStartTag+len(startTag)]+recvData[indexEndTag:]).decode()
        else:
            return recvData.decode()
###############################################################################
    def TCP_transmit(self):
        try:
            self.xmlRecv=None
            IP=self.lineEdit_serverIP.text()
            PORT=int(self.lineEdit_serverPort.text())
            sendData=ET.tostring(self.xmlSend)
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((IP, PORT))
            s.sendall(sendData)
            recvData=b""
            while(1):
                recv = s.recv(self.BUFFER_SIZE)
                recvData+=recv
                if not recv: break
            s.close()
            recvData=self.extractBitstream(recvData)
            self.xmlRecv=ET.fromstring(recvData)

        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___TCP transmit",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def updateFiles(self):
        try:
            for fileTag in self.xmlRecv.findall("file"):
                filePath=fileTag.findall("path")[0].text
                filePath=os.path.join(self.projectDirPath,filePath)
                fileContent=fileTag.findall("content")[0].text
                if fileContent==None: fileContent=""
                if ".." not in filePath:
                    dirName=os.path.dirname(filePath)
                    if len(dirName)>0:
                        if not(os.path.isdir(dirName)): os.makedirs(dirName)
                    f=open(filePath,"wb+")
                    f.write(fileContent.encode())
                    f.close()
            if len(self.xmlRecv.findall("bitstream")):
                filePath=os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PL","bitstream.bit")
                fileContent=self.bitstream
                dirName=os.path.dirname(filePath)
                if len(dirName)>0:
                    if not(os.path.isdir(dirName)): os.makedirs(dirName)
                f=open(filePath,"wb+")
                f.write(fileContent)
                f.close()

            self.appendLogMessage("|___Update local file structure",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Update local file structure",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def sshConnect(self):
        try:
            IP=self.lineEdit_fpgaIP.text()
            PORT=int(self.lineEdit_fpgaPort.text())
            USER=self.lineEdit_fpgaUser.text()
            PWD=self.lineEdit_fpgaUser.text()
            self.ssh = paramiko.SSHClient()
            self.ssh.load_system_host_keys()
            self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            self.ssh.connect(IP, port=PORT,username=USER,password=PWD)
            self.sftp = self.ssh.open_sftp()
            self.appendLogMessage("|___Connect to FPGA",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Connect to FPGA",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def sshDisconnect(self):
        try:
            self.ssh.close()
            self.appendLogMessage("|___Disconnect from FPGA",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Disconnect from FPGA",messageType="ERROR", message=errorMessage)
        return
###############################################################################
    def sshExecCommand(self,command):
        stdin, stdout,stderr=self.ssh.exec_command(command)
        stdoutContent=stdout.read()
        stderrContent=stderr.read()
        if len(stderrContent)>0:
            self.appendLogMessage("|______SSH execute command",messageType="ERROR", message=stderrContent)
        return
###############################################################################
    def fpgaVerifyCallback(self):
        self.appendLogMessage("Verify FPGA connection")
        self.sshConnect()
        self.sshDisconnect()
        return
###############################################################################
    def fpgaRebootCallback(self):
        self.appendLogMessage("Reboot")
########Connect
        self.sshConnect()
########Request power off
        try:
            self.appendLogMessage("|___Request reboot")
            self.sshExecCommand("reboot")
            if self.logList[-1][0]=="|___Request reboot":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Request reboot",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Request reboot",messageType="ERROR", message=errorMessage)
########Disconnect
        self.sshDisconnect()
###############################################################################
    def generateConstantsDict(self):
        filePathConnectionTable=os.path.join(self.projectDirPath,"NET_parsed","connectionTable.txt")
        if os.path.isfile(filePathConnectionTable):
            self.x1ConstDict={}
            self.x32ConstDict={}
            f=open(filePathConnectionTable)
            while(1):
                line=f.readline()
                if len(line)==0:
                    break
                instanceNameList=re.findall("\S+(?=\s-+>)",line)
                x1ConstIndexList=re.findall(r"(?<=>\sx1_const_)\d+",line)
                x32ConstIndexList=re.findall(r"(?<=>\sx32_const_)\d+",line)

                if len(instanceNameList)>0 and len(x1ConstIndexList):
                    self.x1ConstDict[instanceNameList[0]]= x1ConstIndexList[0]
                elif len(instanceNameList)>0 and len(x32ConstIndexList):
                    self.x32ConstDict[instanceNameList[0]]= x32ConstIndexList[0]
                else:
                    pass
            f.close()
        return
###############################################################################
    def generateTab(self):
        x1Table=self.tableWidget_x1_const

        x32Table=self.tableWidget_x32_const
        x1Table.setRowCount(0)
        x32Table.setRowCount(0)

        x1ConstDictSortedKeys=sorted(self.x1ConstDict.keys())
        x32ConstDictSortedKeys=sorted(self.x32ConstDict.keys())
        for row in range(len(x1ConstDictSortedKeys)):
            x1Table.setRowCount(row+1)
            #header
            item=QtWidgets.QTableWidgetItem(x1ConstDictSortedKeys[row])
            x1Table.setVerticalHeaderItem(row,item)
            #python syntax
            item=QtWidgets.QTableWidgetItem("0")
            x1Table.setItem(row,0,item)
            #value
            item=QtWidgets.QTableWidgetItem("0")
            item.setFlags(QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsUserCheckable)
            x1Table.setItem(row,1,item)

        for row in range(len(x32ConstDictSortedKeys)):
            x32Table.setRowCount(row+1)
            #header
            item=QtWidgets.QTableWidgetItem(x32ConstDictSortedKeys[row])
            x32Table.setVerticalHeaderItem(row,item)
            #python syntax
            item=QtWidgets.QTableWidgetItem("0")
            x32Table.setItem(row,0,item)
            #value
            item=QtWidgets.QTableWidgetItem("0")
            item.setFlags(QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsUserCheckable)
            x32Table.setItem(row,1,item)
        QtWidgets.qApp.processEvents()
        return
###############################################################################
    def x1ItemChangedCallback(self,item):
        row = item.row()
        column = item.column()
        if column==0:
            try:
                self.tableWidget_x1_const.item(row, 1).setText("")
                val=int(eval(item.text()))
                valConstrained=min(max(val,0),1)
                self.tableWidget_x1_const.item(row, 1).setText(str(valConstrained))
            except:
                pass
        return
###############################################################################
    def x32ItemChangedCallback(self,item):
        row = item.row()
        column = item.column()
        if column==0:
            try:
                self.tableWidget_x32_const.item(row, 1).setText("")
                val=int(eval(item.text()))
                valConstrained=min(max(val,-2**31),2**31-1)
                self.tableWidget_x32_const.item(row, 1).setText(str(valConstrained))
            except:
                pass
        return
###############################################################################
    def sshConfigFpgaCallback(self):
        self.appendLogMessage("Config. FPGA")
########Zynq_PS
        try:
            if not os.path.isdir(os.path.join(self.projectDirPath,"Zynq_7010")): os.mkdir(os.path.join(self.projectDirPath,"Zynq_7010"))
            if os.path.isdir(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS")): rmtree(os.path.join(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS")))
            copytree(os.path.join(pathResoures,"Zynq_PS"),os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS"))
            self.appendLogMessage("|___Init. local Zynq_PS directory","OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Init. local Zynq_PS directory",messageType="ERROR", message=errorMessage)


########Connect
        self.sshConnect()
########Init file structure
        try:
            self.appendLogMessage("|___Init. file structure")
            self.sshExecCommand("rm -r /home/Canvas") #Remove existing Canvas folder
            self.sshExecCommand("mkdir /home/Canvas") #Creates new Canvas folder
            if self.logList[-1][0]=="|___Init. file structure":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Init. file structure",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Init. file structure",messageType="ERROR", message=errorMessage)
########Init bitstream loader
        try:
            self.appendLogMessage("|___Init. bitstream loader")
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","bitstreamLoader.sh"),"/home/Canvas/bitstreamLoader.sh") #Sends bitstreamLoader.sh
            self.sshExecCommand("sed -i -e 's/\r$//' /home/Canvas/bitstreamLoader.sh") #Remove spurious CR characters
            self.sshExecCommand("chmod +x /home/Canvas/bitstreamLoader.sh") #Makes bitstreamLoader.sh executable
            if self.logList[-1][0]=="|___Init. bitstream loader":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Init. bitstream loader",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Init. bitstream loader",messageType="ERROR", message=errorMessage)
########Init constants loader
        try:
            self.appendLogMessage("|___Init. constants loader")
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","constantsLoader.c"),"/home/Canvas/constantsLoader.c") #Sends constantsLoader.c
            self.sshExecCommand("gcc /home/Canvas/constantsLoader.c -o /home/Canvas/constantsLoader") #Compiles constantsLoader.c
            self.sshExecCommand("chmod +x /home/Canvas/constantsLoader") #Makes constantsLoader executable
            if self.logList[-1][0]=="|___Init. constants loader":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Init. constants loader",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Init. constants loader",messageType="ERROR", message=errorMessage)
########Config boot
        try:
            self.appendLogMessage("|___Config. boot")
            rcLocalContent=""
            rcLocalContent+="#!bin/sh -e\n"
            if self.radioButton_autoBitstreamConstantsOn.isChecked():
                rcLocalContent+="/home/Canvas/bitstreamLoader.sh \n"
                rcLocalContent+="/home/Canvas/constantsLoader \n"
            rcLocalContent+="exit 0\n"
            f=open(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","rc.local"),"wb+")
            f.write(rcLocalContent.encode())
            f.close()
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","rc.local"),"/etc/rc.local")
            if self.logList[-1][0]=="|___Config. boot":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Config. boot",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Init. constants loader",messageType="ERROR", message=errorMessage)
########Disconnect
        self.sshDisconnect()
        return
##############################################################################
    def sshLoadBitstreamCallback(self):
        self.appendLogMessage("Load bitstream")
########Connect
        self.sshConnect()
########Transfer bitstream
        try:
            self.appendLogMessage("|___Transfer bitstream")
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PL","bitstream.bit"),"/home/Canvas/bitstream.bit") #Send bitstream.bit to FPGA (PS)
            if self.logList[-1][0]=="|___Transfer bitstream":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Transfer bitstream",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Transfer bitstream",messageType="ERROR", message=errorMessage)
########Load bitstream
        try:
            self.appendLogMessage("|___Load bitstream")
            self.sshExecCommand("/home/Canvas/bitstreamLoader.sh") #Execute PS -> PL bitstream loader
            if self.logList[-1][0]=="|___Load bitstream":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Load bitstream",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Load bitstream",messageType="ERROR", message=errorMessage)
########Disconnect
        self.sshDisconnect()
        return
##############################################################################
    def sshLoadConstantsCallback(self):
        self.appendLogMessage("Load contants")
########Connect
        self.sshConnect()
########Parse constants
        try:
            x1ConstArray=np.zeros(256)
            x32ConstArray=np.zeros(256)
            x1Model=self.tableWidget_x1_const.model()
            x32Model=self.tableWidget_x32_const.model()
            for row in range(len(self.x1ConstDict.keys())):
                index=int(self.x1ConstDict[x1Model.headerData(row,QtCore.Qt.Vertical)])
                x1ConstArray[index]=int(self.tableWidget_x1_const.item(row,1).text())
            for row in range(len(self.x32ConstDict.keys())):
                index=int(self.x32ConstDict[x32Model.headerData(row,QtCore.Qt.Vertical)])
                x32ConstArray[index]=int(self.tableWidget_x32_const.item(row,1).text())
            self.appendLogMessage("|___Parse constants table",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Parse constants table",messageType="ERROR", message=errorMessage)
########Construct constants files
        try:
            x1ConstFile=open(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","x1Const.txt"),"wb+")
            x32ConstFile=open(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","x32Const.txt"),"wb+")
            for i in range(0,256):
                x1ConstFile.write(("%d   %d\r\n"%(i,x1ConstArray[i])).encode())
                x32ConstFile.write(("%d   %d\r\n"%(i,x32ConstArray[i])).encode())
            x1ConstFile.close()
            x32ConstFile.close()
            self.appendLogMessage("|___Construct constants files ",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Construct constants files ",messageType="ERROR", message=errorMessage)
########Transfer constants
        try:
            self.appendLogMessage("|___Transfer constants")
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","x1Const.txt"),"/home/Canvas/x1Const.txt") #Send const1Bit.txt to FPGA (PS)
            self.sftp.put(os.path.join(self.projectDirPath,"Zynq_7010","Zynq_PS","x32Const.txt"),"/home/Canvas/x32Const.txt") #Send const32Bit.txt to FPGA (PS)
            if self.logList[-1][0]=="|___Transfer constants":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Transfer constants",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Transfer constants",messageType="ERROR", message=errorMessage)
########Load constants
        try:
            self.appendLogMessage("|___Load constants")
            self.sshExecCommand("/home/Canvas/constantsLoader") #Execute PS -> PL constants loader
            if self.logList[-1][0]=="|___Load constants":
                self.logList=self.logList[:-1]
                self.appendLogMessage("|___Load constants",messageType="OK")
        except Exception:
            errorMessage=str(traceback.format_exc())
            self.appendLogMessage("|___Load constants",messageType="ERROR", message=errorMessage)
########Disconnect
        self.sshDisconnect()
        return
###############################################################################
    def fpgaRunSelectedCallback(self):
        if self.checkBox_sshConfigFpga.isChecked(): self.sshConfigFpgaCallback()
        if self.checkBox_sshLoadBitstream.isChecked(): self.sshLoadBitstreamCallback()
        if self.checkBox_sshLoadConstants.isChecked(): self.sshLoadConstantsCallback()
        return
###############################################################################
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = CanvasApp()
    window.show()
    sys.exit(app.exec_())

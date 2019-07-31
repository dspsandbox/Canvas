The NET2FPGA project is a free visual FPGA programming tool, which starting from a LTspice toolbox, automates code generation, sythesis and implementation on the target device. This software bundle drastically reduces the time required for generating custom digital signal processing (DSP) solutions and opens the field for users without prior knowledge on VHDL/Verilog and FPGA architecture. 

The automated code generation, synthesis and implementation are outsourced to an external server. The advantage of that is twofold. On one side the final user does not require a a heavy (~30 GB) Xilinx installation. On the other, successfully generated output products are saved in an internal database and are directly retrieved for future implementations of the same type.

The project is currently devoted to the [Redpitaya platform](https://www.redpitaya.com/),  a low cost development board based on a Zynq7010 FPGA, which includes two pairs of ADCs/DACs operating at 125 Msamples/s. Simple analog electronic circuits such as a low/high pass filters, PID controllers, mixers, modulators, signal generators... are here easily achieved by visually combining the provided LTspice toolbox. The tuning of the circuit paramerts are achieved here by "on the fly" redifinition of used digital constants. 

The operation of the NET2FPGA tool is outline in the following:

### SERVER
 * The user visually designs a digital circuit based on the provided toolbox for LTspice. LTspice automatically translates the visual design into a .net file, containing the information of the used components and connections among them. 
 * The .net file is forwarded to the external NET2FPGA server, which parses its content, translates it to synthesizable VHDL code and compares the circuit to the internal database.
 * If a match in the database is found, the output products are directly returned to the user.
 * If no match is found, the server performs synthesis/implementation and returns the output products after completion.
 ### FPGA
 * The user selects a generated bitream to upload onto the FPGA and defines values for 1 bit and 32 bit constants used in the digital circuit.
* The NET2FPGA bundle uploads bitstream and constants onto the processing system (PS) of the Zynq device.
* The NET2FPGA bundle transfers bitstream and constants to the programable logic (PL) of the Zynq device. Automatic PS → PL transfers after reboot can be set.
 


## Getting started
Coming soon...




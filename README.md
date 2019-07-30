# NET2FPGA
## Visual prototyping and digital signal processing on Zynq FPGAs

The NET2FPGA project is a free visual FPGA programming tool, which starting from a LTspice toolbox, automates code generation, sythesis and implementation on the target device. This software bundle drastically reduces the time required for generating custom digital signal processing (DSP) solutions and opens the field for users without prior knowlegde on VHDL/Verilog and FPGA architechture. 

The automated code generation, synthesis and implementation are outsourced to an external server. The advantage of that is twofold. On one side the final user does not require a a heavy (~30 GB) Xilinx installation. On the other, sucessfully generated output products are saved in an internal database such that they can be directly retrieved for implementations of the same type.

The project is currently devoted to the [Redpitaya platform](https://www.redpitaya.com/), which is a low cost development board based on a Zynq7010 FPGA, which includes two pairs of ADCs/DACs operating at 125 Msamples/s. As a result, simple electronic circuits such as a low/high pass filters, PID controllers, mixers, modulators, signal generators... are here easily achieved by visually combining the provided LTspice toolbox. 

The operation of the NET2FPGA tool is outline in the following:

### SERVER
 * The user visually designes a digital circuit based on the provded toolbox for LTspice. LTspice automatically translates the visual design into a .net file, containing the information of the used components and connections among them. 
 * The .net file is forwarded to the external NET2FPGA server, which parses its content and compares the circuit to the internal database.
 * If a match in the databse is found, the output products are directly returned to the user.
 * If no match is found, the server performs synthesis/implementation and returns the output products after completion.
 ### FPGA
 * The user selects generated bitream to upload onto the FPGA.
 * The user defines values for constants to used in the implementation.
 * The NET2FPGA bundle upploads both uppon reequest.
 


## Getting started
Coming soon...




# NET2FPGA
## Visual prototyping and digital signal processing on Zynq FPGAs

The NET2FPGA project is a visual FPGA programming tool, which starting from a LTspice toolbox, automates code generation, sythesis and implementation on the target device. This software bundle drastically reduces the time required for generating custom digital signal processing (DSP) solutions and opens the field for users without prior knowlegde on VHDL/Verilog and FPGA architechture. 

The automated code generation, synthesis and implementation are performed on an external server. By outsourcing these processes, the final user does not require an installation of the Xilinx development software. To further reduce the computational load, the output products of each new server request are appended to an internal database and are directly retrieved for future requests of the same type.

The project is currently devoted to the [Redpitaya platform](https://www.redpitaya.com/), which is a low cost development board arround a Zynq7010 FPGA, including two pairs of ADCs/DACs at 125 Msamples/s. As a result, simple electronic circuits such as a low/high pass filters, PID controllers, mixers, modulators, signal generators... are here easily achieved by visually combining the provided LTspice toolbox. 






## Getting started
Coming soon...




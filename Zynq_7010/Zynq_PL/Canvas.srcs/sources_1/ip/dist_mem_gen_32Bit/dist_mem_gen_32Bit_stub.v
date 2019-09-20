// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Jul 23 14:32:10 2019
// Host        : PC1091 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top dist_mem_gen_32Bit -prefix
//               dist_mem_gen_32Bit_ dist_mem_gen_32Bit_stub.v
// Design      : dist_mem_gen_32Bit
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module dist_mem_gen_32Bit(a, d, dpra, clk, we, qdpo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],d[31:0],dpra[7:0],clk,we,qdpo[31:0]" */;
  input [7:0]a;
  input [31:0]d;
  input [7:0]dpra;
  input clk;
  input we;
  output [31:0]qdpo;
endmodule

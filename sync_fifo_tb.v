
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2026 16:05:08
// Design Name: 
// Module Name: sync_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps
module FIFO_sync_tb();
 parameter DATA_WIDTH=32;
 parameter FIFO_DEPTH=8;
localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
 reg clk=0,rst,we,re,cs;
 reg [DATA_WIDTH-1:0]data_in;
wire [DATA_WIDTH-1:0]data_out;
wire empty,full;
wire [FIFO_DEPTH_LOG:0] w_ptr;
wire [FIFO_DEPTH_LOG:0] r_ptr;
integer i;
 FIFO_SYNC #(.FIFO_DEPTH(FIFO_DEPTH),.DATA_WIDTH(DATA_WIDTH)) dut ( 
	.clk(clk),.rst(rst),.we(we),.re(re),.cs(cs),
	.data_in(data_in),.data_out(data_out),.empty(empty),.full(full));

assign w_ptr = dut.w_ptr;
assign r_ptr = dut.r_ptr;

always begin #5 clk = ~clk; end

//write task
task write_data(input [DATA_WIDTH-1:0]d_in);
	begin
	@(negedge clk)
	cs=1; we=1; re=0;
	data_in = d_in;
 	
	@(negedge clk)
	cs=0; we=0;
	end
endtask
task read_data();
	begin
	@(negedge clk)
	cs=1; re=1; we=0;
	
	@(negedge clk)
	cs=0; re=0;
	end
endtask

//create stimulus


initial 
begin
   $monitor("Time=%0t | data_in=%0d | data_out=%0d",
              $time, data_in, data_out);
rst=1;we=0;re=0; cs=0; data_in =0;
  repeat(2) @(posedge clk);
  @(negedge clk);
rst=0;
// scnerio 1
write_data(1);
write_data(10);
write_data(100);
read_data();
read_data();
read_data();

// scnerio 2
for(i = 0; i <= FIFO_DEPTH; i = i + 1)
	begin
	write_data(2**i);
	read_data();
	end

// scnerio 3

    
for(i = 0; i < FIFO_DEPTH; i = i + 1)
	begin
	write_data(2**i);
	end
#1;
if(full == 1 && empty == 0)
    $display("PASS: FIFO FULL");
else
    $display("FAIL: FIFO FULL");
    
for(i = 0; i < FIFO_DEPTH; i = i + 1)
	begin
	read_data();
	end

#1;
if(empty == 1 && full == 0)
    $display("PASS: FIFO EMPTY");
else
    $display("FAIL: FIFO EMPTY");
 
#40 $finish;
end
endmodule
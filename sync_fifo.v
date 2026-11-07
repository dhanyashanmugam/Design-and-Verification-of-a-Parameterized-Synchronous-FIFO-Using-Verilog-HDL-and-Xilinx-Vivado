`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2026 15:57:56
// Design Name: 
// Module Name: sync_fifo
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


module FIFO_SYNC #(parameter DATA_WIDTH=32, FIFO_DEPTH=8)
(input clk,rst,we,re,cs,
input [DATA_WIDTH-1:0]data_in,
output reg [DATA_WIDTH-1:0]data_out,
output empty,full);

localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH); // 8 locations 3 bit representation (000 to 111)

reg [FIFO_DEPTH_LOG:0]w_ptr; // write pointer 4 bit
reg [FIFO_DEPTH_LOG:0]r_ptr; //read pointer 4 bit

reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1]; // FIFO declaration 8 locations with 32 bit each

// write operation
always @(posedge clk )
begin
   if(rst)
   begin 
   w_ptr <= 0;
  
   end
   else if(cs && we && !full) 
    begin
    fifo[w_ptr[FIFO_DEPTH_LOG-1:0]] <= data_in;
	w_ptr <= w_ptr+1'b1;
    end
end

// read operation
always @(posedge clk)
begin
   if(rst)
   begin 
   r_ptr <= 0;
    data_out = 0;
   end
   else if(cs && re && !empty) 
    begin
    data_out <= fifo[r_ptr[FIFO_DEPTH_LOG-1:0]];
	r_ptr <= r_ptr+1'b1;
    end
end

assign empty = (w_ptr == r_ptr);
assign full = (w_ptr[FIFO_DEPTH_LOG] != r_ptr[FIFO_DEPTH_LOG]) && (w_ptr[FIFO_DEPTH_LOG-1:0] == r_ptr[FIFO_DEPTH_LOG-1:0]);
// assgin full = ({~w_ptr[FIFO_DEPTH_LOG],w_ptr[FIFO_DEPTH_LOG-1:0]} == r_ptr);
endmodule

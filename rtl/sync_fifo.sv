module sync_fifo #(
parameter WIDTH = 8,
parameter DEPTH = 8)
(
input logic clk,
input logic rst,
input logic wr_en,
input logic rd_en,
input logic [WIDTH-1:0] data_in,
output logic [WIDTH-1:0] data_out = 0,
output logic full,
output logic empty
);
logic [WIDTH-1:0] mem [0:DEPTH-1];
logic [$clog2(DEPTH)-1:0] wr_ptr = 0;
logic [$clog2(DEPTH)-1:0] rd_ptr = 0;
always_ff @(posedge clk)
begin
if (rst)
begin
wr_ptr <= 0;
end
else if (wr_en && !full)
begin 
mem[wr_ptr] <= data_in;
wr_ptr <= wr_ptr + 1;
end
end
always_ff @(posedge clk)
begin
if (rst)
begin
rd_ptr <= 0;
data_out <= 0;
end
else if (rd_en && !empty)
begin
data_out <= mem[rd_ptr];
rd_ptr <= rd_ptr + 1;
end
end

always_comb
begin
empty = (wr_ptr == rd_ptr);
full = ((wr_ptr + 1'b1) == rd_ptr);
end
endmodule

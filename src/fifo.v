module FIFO_memory #(parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4)(
    output [DATA_SIZE-1:0] rdata,        // Output data - data to be read
    input [DATA_SIZE-1:0] wdata,         // Input data - data to be written
    input [ADDR_SIZE-1:0] waddr, raddr,  // Write and read address
    input wclk_en, wfull, wclk,          // Write clock enable, write full, write clock
    input rclk_en, rempty, rclk
    );

    localparam DEPTH = 1<<ADDR_SIZE;     // Depth of the FIFO memory
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];// Memory array

 //   always @(posedge rclk)
  //      if(rclk_en && !rempty)  rdata <= mem[raddr];          // Read data
    assign rdata = mem[raddr];
    always @(posedge wclk)
        if (wclk_en && !wfull) mem[waddr] <= wdata; // Write data

endmodule

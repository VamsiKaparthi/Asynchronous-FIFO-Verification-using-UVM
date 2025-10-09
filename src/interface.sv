interface inf(input bit rclk, input bit rrst_n, input bit wclk, input bit wrst_n);
  //inputs
  logic rinc, winc;
  logic [DSIZE - 1 : 0] wdata;
  //outputs
  logic wfull, rempty;
  logic [DSIZE - 1 : 0] rdata;

  clocking write_cb @(posedge wclk);
    input winc, wrst_n, wdata;
    input wfull;
  endclocking

  clocking read_cb @(posedge rclk);
    input rinc, rrst_n;
    input rempty, rdata;
  endclocking
endinterface

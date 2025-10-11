interface inf(input bit rclk, input bit rrst_n, input bit wclk, input bit wrst_n);
        //inputs
        logic rinc, winc;
        logic [DSIZE - 1 : 0] wdata;
        //outputs
        logic wfull, rempty;
        logic [DSIZE - 1 : 0] rdata;

        clocking write_cb @(posedge wclk);
                output winc, wrst_n, wdata;
                input wfull;
        endclocking

        clocking read_cb @(posedge rclk);
                input rinc, rrst_n;
                input rempty, rdata;
        endclocking

/****Assertions****/
//Write clock toggling
  property p1;
    @(posedge wclk) wclk != $past(1, wclk);
  endproperty
  assert property(p1)begin
    $info("Write Clock Toggling Pass");
  end
        else begin
    $info("Write Clock Toggling Fail");
  end

//Read clock toggling
  property p2;
    @(posedge rclk) rclk != $past(1, rclk);
  endproperty
  assert property(p2)begin
    $info("Read Clock Toggling Pass");
  end
  else begin
    $info("Read Clock Toggling Fail");
  end

//read_reset_n
  property p3;
    @(posedge rclk) !rrst_n |-> rempty;
  endproperty
  assert property(p3)begin
    $info("Read Reset Pass");
  end
  else begin
    $info("Read Reset Fail");
  end

//write_reset_n
  property p4;
    @(posedge wclk) !wrst_n |-> !wfull;
  endproperty
  assert property(p4)begin
    $info("Write Reset Pass");
  end
  else begin
    $info("Write Reset Fail");
  end

//valid write inputs
  property p5;
    @(posedge wclk) wrst_n |-> not($isunknown({winc, wdata}));
  endproperty
  assert property(p5)begin
    $info("Valid Write Inputs Pass");
  end
  else begin
    $info("Valid Write Inputs Fail");
  end

endinterface


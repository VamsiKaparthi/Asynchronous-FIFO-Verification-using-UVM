interface inf(input bit rclk, input bit rrst_n, input bit wclk, input bit wrst_n);
        //inputs
        logic rinc, winc;
        logic [DSIZE - 1 : 0] wdata;
        //outputs
        logic wfull, rempty;
        logic [DSIZE - 1 : 0] rdata;

        clocking write_drv_cb @(posedge wclk);
                output winc, wdata;
        endclocking

        clocking write_mon_cb @(posedge wclk);
                input winc, wdata, wfull;
        endclocking

        clocking read_drv_cb @(posedge rclk);
                output rinc;
        endclocking

        clocking read_mon_cb @(posedge rclk);
                        input rinc, rempty, rdata;
        endclocking

        clocking wrst_n_cb @(posedge wclk);
    input wrst_n;
  endclocking

  clocking rrst_n_cb @(posedge rclk);
    input rrst_n;
  endclocking
/****Assertions****/
//Write clock toggling

  property p1;
    @(posedge wclk, negedge wclk) wclk == $past(~wclk);
  endproperty
  assert property(p1)begin
    $info("Write Clock Toggling Pass");
  end
        else begin
    $info("Write Clock Toggling Fail");
  end

//Read clock toggling
  property p2;
    @(posedge rclk, negedge rclk) rclk == $past(~rclk);
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

//Rempty and wfull not high at same time
	property p6;
		@(posedge wclk, posedge rclk) disable iff (!wrst_n || !rrst_n) !(rempty && wclk);
	endproperty
  assert property(p6)begin
    $info("Rempty, wfull not high at the same time Pass");
  end
  else begin
    $info("Rempty, wfull not high at the same time fail Fail");
  end

endinterface

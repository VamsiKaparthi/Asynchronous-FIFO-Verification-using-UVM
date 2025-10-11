class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent);
  sequencer sqr;
  wr_driver w_drv;
  wr_monitor w_mon;
  function new(string name = "write_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = sequencer::type_id::create("sqr", this);
    w_drv = wr_driver::type_id::create("w_drv", this);
    w_mon = wr_monitor::type_id::create("w_mon", this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    w_drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass

class seq_wr_test extends uvm_test;
  `uvm_component_utils(seq_wr_test)
  env e1;
  write_sequence write_seq;
  read_sequence read_seq;

  function new(string name = "_sequential_wr_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e1 = env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    write_seq = write_sequence::type_id::create("write_seq");
    read_seq = read_sequence::type_id::create("read_seq");
    fork
      write_seq.start(e1.w_agnt.sqr);
      read_seq.start(e1.r_agnt.sqr);
    join
    phase.drop_objection(this);
  endtask
endclass


class par_wr_test extends uvm_test;
  `uvm_component_utils(par_wr_test)
  env e1;
  p_write_sequence p_write_seq;
  p_read_sequence p_read_seq;

  function new(string name = "parallel_wr_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e1 = env::type_id::create("env", this);
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    p_write_seq = p_write_sequence::type_id::create("p_write_seq");
    p_read_seq = p_read_sequence::type_id::create("p_read_seq");
    fork
      p_write_seq.start(e1.w_agnt.sqr);
      p_read_seq.start(e1.r_agnt.sqr);
    join
    phase.drop_objection(this);
  endtask
endclass

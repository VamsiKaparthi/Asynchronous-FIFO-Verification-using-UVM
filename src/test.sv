class test extends uvm_test;
        `uvm_component_utils(test);
        env e1;
        v_seq vsq;

        function new(string name = "test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                e1 = env::type_id::create("env", this);
                vsq = v_seq::type_id::create("vsq");
        endfunction

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                vsq.start(e1.vsqr);
                phase.drop_objection(this);
        endtask
endclass

class write_test extends test;
        `uvm_component_utils(write_test);
        wr_seq wseq;
        function new(string name = "", uvm_component parent = null);
                super.new(name, parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                wseq = wr_seq::type_id::create("wseq");
        endfunction
        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                wseq.start(e1.vsqr.wr_sqr);
                phase.drop_objection(this);
        endtask
endclass

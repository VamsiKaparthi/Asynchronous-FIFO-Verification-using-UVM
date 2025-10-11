class sequencer extends uvm_sequencer #(seq_item);
        `uvm_component_utils(sequencer)
        function new(string name = "sequencer", uvm_component parent = null);
                super.new(name, parent);
        endfunction
endclass

class v_sequencer extends uvm_sequencer #(seq_item);
        `uvm_component_utils(v_sequencer);
        sequencer rd_sqr;
        sequencer wr_sqr;

        function new(string name = "vsqr", uvm_component parent = null);
                super.new(name, parent);
        endfunction
endclass

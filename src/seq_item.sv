class seq_item  extends uvm_sequence_item;
        //Input
        rand bit winc;
        rand bit rinc;
        //rand bit wrst_n;
        //rand bit rrst_n;
        rand bit [DSIZE - 1 : 0] wdata;
        //Output
        bit [DSIZE - 1 : 0] rdata;
        bit wfull;
        bit rempty;

        `uvm_object_utils_begin(seq_item)
        `uvm_field_int(winc, UVM_DEFAULT);
        `uvm_field_int(rinc, UVM_DEFAULT);
        //`uvm_field_int(wrst_n, UVM_DEFAULT);
        //`uvm_field_int(rrst_n, UVM_DEFAULT);
        `uvm_field_int(wdata, UVM_DEFAULT);
        `uvm_field_int(rdata, UVM_DEFAULT);
        `uvm_field_int(wfull, UVM_DEFAULT);
        `uvm_field_int(rempty, UVM_DEFAULT);
        `uvm_object_utils_end

        function new(string name = "seq_item");
                super.new(name);
        endfunction

endclass

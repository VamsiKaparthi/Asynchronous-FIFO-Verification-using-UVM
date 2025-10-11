class rd_driver extends uvm_driver #(seq_item);
        `uvm_component_utils(rd_driver);
        virtual inf vif;
        event re;
        function new(string name = "rd_driver", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
                        `uvm_warning("ERR", "Cannot access read driver interface");
                if(!uvm_config_db#(event)::get(this, "", "re", re))
                        `uvm_warning("ERR", "Cannot access read event");
        endfunction

        task drive();
        //      @(r_vif.read_cb);
                `uvm_info("RD_DRV", $sformatf("rinc = %0b", req.rinc), UVM_MEDIUM);
                vif.rinc <= req.rinc;
                //vif.rrst_n <= req.rrst_n;
                repeat(1)@(vif.read_cb);
                ->re;
        endtask

        task run_phase(uvm_phase phase);
                repeat(3)@(vif.read_cb);
                forever begin
                        seq_item_port.get_next_item(req);
                        drive();
                        seq_item_port.item_done();
                end
        endtask
endclass

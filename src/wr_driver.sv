class wr_driver extends uvm_driver #(seq_item);
        `uvm_component_utils(wr_driver);
        virtual inf vif;
        seq_item req;
        event we;
        function new(string name = "wr_driver", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
                        `uvm_warning("ERR", "Cannot access write driver interface");
                if(!uvm_config_db#(event)::get(this, "", "we", we))
                        `uvm_warning("ERR", "Cannot access write event");
        endfunction

        task drive();
                //@(w_vif.write_cb);
                `uvm_info("WR_DRV", $sformatf("winc = %0b | wdata = %0d", req.winc, req.wdata), UVM_MEDIUM);
                vif.winc <= req.winc;
                //vif.wrst_n <= req.wrst_n;
                vif.wdata <= req.wdata;
                repeat(1)@(vif.write_cb);
                ->we;
        endtask

        task run_phase(uvm_phase phase);
                repeat(3)@(vif.write_cb);
                forever begin
                        seq_item_port.get_next_item(req);
                        drive();
                        seq_item_port.item_done();
                end
        endtask
endclass

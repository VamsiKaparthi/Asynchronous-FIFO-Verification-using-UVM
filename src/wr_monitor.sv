class wr_monitor extends uvm_monitor;
        `uvm_component_utils(wr_monitor);
        virtual inf vif;
        event we;
        seq_item pkt;
        uvm_analysis_port#(seq_item) item_collect_wr_mon;
        function new(string name = "wr_monitor", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
                        `uvm_warning("ERR", "Cannot access write interface");
                if(!uvm_config_db#(event)::get(this, "", "we", we))
                        `uvm_warning("ERR", "Cannot access write event");
                pkt = seq_item::type_id::create("pkt");
                item_collect_wr_mon = new("icwm", this);
        endfunction

        task monitor();
                wait(we);
                `uvm_info("WR_MON", $sformatf("winc = %0b | wfull = %0d", vif.winc, vif.wfull), UVM_MEDIUM);
                pkt.winc = vif.winc;
                pkt.wrst_n = vif.wrst_n;
                pkt.wdata = vif.wdata;
                //@(w_vif.write_cb);
                pkt.wfull = vif.wfull;
                item_collect_wr_mon.write(pkt);
        endtask

        task run_phase(uvm_phase phase);
                forever begin
                        monitor();
                end
        endtask
endclass

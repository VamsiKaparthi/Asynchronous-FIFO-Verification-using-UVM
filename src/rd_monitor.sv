class rd_monitor extends uvm_monitor;
        `uvm_component_utils(rd_monitor);
        virtual inf vif;
        event re;
        seq_item pkt;
        uvm_analysis_port#(seq_item) item_collect_rd_mon;

        function new(string name = "rd_monitor", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
                        `uvm_warning("ERR", "Cannot access read interface");
                if(!uvm_config_db#(event)::get(this, "", "re", re))
                        `uvm_warning("ERR", "Cannot access read event");
                pkt = seq_item::type_id::create("pkt");
                item_collect_rd_mon = new("icrm", this);
        endfunction

        task monitor();
                wait(re);
                `uvm_info("RD_MON", $sformatf("rempty = %0b | rdata = %0d", vif.rempty, vif.rdata), UVM_MEDIUM);
                pkt.rinc = vif.rinc;
                pkt.rrst_n = vif.rrst_n;
                pkt.rempty = vif.rempty;
                pkt.rdata = vif.rdata;
                item_collect_rd_mon.write(pkt);
        endtask

        task run_phase(uvm_phase phase);
                forever begin
                        monitor();
                end
        endtask
endclass

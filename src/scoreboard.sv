class scoreboard extends uvm_scoreboard;
        `uvm_component_utils(scoreboard);

        uvm_analysis_imp_wr#(seq_item, scoreboard) wr_item_collect_scb;
        uvm_analysis_imp_rd#(seq_item, scoreboard) rd_item_collect_scb;
        seq_item wr_q[$];
        seq_item rd_q[$];
        seq_item wr_pkt;
        seq_item rd_pkt;

        seq_item ref_pkt;
        bit [DSIZE - 1 : 0] mem [$ : 15];
        int wptr, rptr;
        bit wfull = 0;
        bit rempty = 1;
        bit prev_wfull;
        bit prev_rempty = 1;
        int prev_rdata;
        function new(string name = "scoreboard", uvm_component parent = null);
                super.new(name, parent);
                wr_item_collect_scb = new("wr_item_collect_scb", this);
                rd_item_collect_scb = new("rd_item_collect_scb", this);
                ref_pkt = seq_item::type_id::create("ref_pkt");
        endfunction

        function void write_wr(seq_item req);
                wr_q.push_back(req);
        endfunction

        function void write_rd(seq_item req);
                rd_q.push_back(req);
        endfunction

        int wr_pass, rd_pass;

        task writer();
                $display("HIGH");
                forever begin
                        wait(wr_q.size > 0);
                        wr_pkt = wr_q.pop_front();
                        $display("-------------mem before write = %0p-------------", mem);
                        if(!wr_pkt.wrst_n)begin
                                wfull = 0;
                        end
                        else begin
                                if(wr_pkt.winc && !prev_wfull)begin
                                        mem.push_back(wr_pkt.wdata);
                                end
                        end
                        if(prev_wfull == wr_pkt.wfull)begin
                                `uvm_info("SCB RD", "WRITE PASS", UVM_LOW);
                                wr_pass++;
                        end
                        else begin
                                `uvm_info("SCB RD", $sformatf("WRITE FAIL || scb wfull = %0d | mon wfull = %0d", prev_wfull, wr_pkt.wfull), UVM_LOW);
                        end
                        $display("-------------mem after write = %0p-------------", mem);
                        prev_wfull = (mem.size == 15);
                end

        endtask

        task reader();
                forever begin
                        wait(rd_q.size > 0);
                        rd_pkt = rd_q.pop_front();
                        $display("-------------mem before read = %0p-------------", mem);
                        if(!rd_pkt.rrst_n)begin
                                rempty = 1;
                        end
                        else begin
                                if(rd_pkt.rinc && !rempty)begin
                                        ref_pkt.rdata = mem.pop_front();
                                end
                        end
                        if(rempty == rd_pkt.rempty && rempty)begin
                                `uvm_info("SCB RD", "READ PASS", UVM_LOW);
                                rd_pass++;
                        end
                        else if(ref_pkt.rdata == rd_pkt.rdata && rempty == rd_pkt.rempty)begin
                                `uvm_info("SCB RD", "READ PASS", UVM_LOW);
                                rd_pass++;
                        end
                        else begin
                                `uvm_info("SCB RD", $sformatf("READ FAIL || scb rdata = %0d | mon rdata = %0d || scb rempty = %0d | mon rempty = %0d", ref_pkt.rdata, rd_pkt.rdata, rempty, rd_pkt.rempty), UVM_LOW);
                        end
                        $display("-------------mem after read = %0p-------------", mem);
                        rempty = (mem.size == 0);
                end
        endtask

        task reference();
                fork
                        writer();
                        reader();
                join
        endtask

        task run_phase(uvm_phase phase);
                reference();
        endtask

        function void extract_phase(uvm_phase phase);
                super.extract_phase(phase);
                `uvm_info("FINAL SCB RESULTS", $sformatf("write_passes = %0d || read_passes = %0d", wr_pass, rd_pass), UVM_MEDIUM);
        endfunction
endclass

































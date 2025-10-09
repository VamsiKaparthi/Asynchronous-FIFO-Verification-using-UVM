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
                forever begin
                        wait(wr_q.size > 0);
                        wr_pkt = wr_q.pop_front();
                        //`uvm_info("SCB", $sformatf("winc = %0b | wrst_n = %0b | wdata = %d || wfull = %0b", wr_pkt.winc, wr_pkt.wrst_n, wr_pkt.wdata, wr_pkt.wfull), UVM_MEDIUM);
                        wfull = (mem.size == DEPTH);
                        if(!wr_pkt.wrst_n)begin
                                wfull = 0;
                        //      wptr = 0;
                        end
                        else if(wr_pkt.winc && !wfull)begin
                                //$display("Enter");
                                mem.push_back(wr_pkt.wdata);
                        //      wptr = (wptr + 1) % DEPTH;
                                wfull = (mem.size == DEPTH);
                        end
                        ref_pkt.wfull = wfull;
                        `uvm_info("SCB WRITE REF OUT", $sformatf("wfull = %0b", ref_pkt.wfull), UVM_MEDIUM);
                        $display("-------mem after write = %0p----------", mem);
                        //Compare outputs
                        if(ref_pkt.wfull === wr_pkt.wfull)begin
                                `uvm_info("SCB WR", "WRITE PASS", UVM_MEDIUM);
                                wr_pass++;
                        end
                        else begin
                                `uvm_info("SCB WR", "WRITE FAIL", UVM_MEDIUM);
                        end
                end
        endtask

        task reader();
                forever begin
                        wait(rd_q.size > 0);
                        rd_pkt = rd_q.pop_front();
                        //`uvm_info("SCB", $sformatf("rinc = %0b | rrst_n = %0b || rdata = %d | rempty = %0b", rd_pkt.rinc, rd_pkt.rrst_n, rd_pkt.rdata, rd_pkt.rempty), UVM_MEDIUM);
                        i//rempty = (mem.size == 0);
                        $display("mem before read = %0p", mem);
                        if(!rd_pkt.rrst_n)begin
                                rempty = 1;
                        end
                        else if(rd_pkt.rinc && !rempty)begin
                                $display("Enter");
                                ref_pkt.rdata = mem.pop_front();
                                rptr = (rptr + 1) % DEPTH;
                        end
                        ref_pkt.rempty = rempty;
                        `uvm_info("SCB READ REF OUT", $sformatf("rdata = %d | rempty = %0b", ref_pkt.rdata, ref_pkt.rempty), UVM_MEDIUM);
                        $display("-----mem after read = %0p----", mem);
                        if(ref_pkt.rempty === rd_pkt.rempty && ref_pkt.rdata == rd_pkt.rdata)begin
                                `uvm_info("SCB RD", "READ PASS", UVM_MEDIUM);
                                rd_pass++;
                        end
                        else begin
                                `uvm_info("SCB RD", "READ FAIL", UVM_MEDIUM);
                        end
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

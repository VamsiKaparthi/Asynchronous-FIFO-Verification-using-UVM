class wr_seq extends uvm_sequence;
        `uvm_object_utils(wr_seq)
        seq_item req;
        function new(string name = "wr_seq");
                super.new(name);
        endfunction
        task body();
                //$display("------------------------------------------------------------------------------------");
                repeat(N)begin
                        //$display("--------------------------------------------WR_START----------------------------------------------------");
                        req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {winc == 1;});
                        `uvm_info("WR_SEQ", $sformatf("winc = %0b | wdata = %0d", req.winc, req.wdata), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("--------------------------------------------WR_END----------------------------------------------------");
                end
                wait_for_grant();
                void'(req.randomize() with {winc == 0;});
                `uvm_info("WR_SEQ", $sformatf("winc = %0b | wdata = %0d", req.winc, req.wdata), UVM_LOW);
                send_request(req);
                wait_for_item_done();
        endtask
endclass

class rd_seq extends uvm_sequence;
        `uvm_object_utils(rd_seq)
        seq_item req;
        function new(string name = "rd_seq");
                super.new(name);
        endfunction
        task body();
                //$display("------------------------------------------------------------------------------------");
                repeat(N)begin
                        //$display("--------------------------------------------RD_START--------------------------------------------------");
                  req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {rinc == 1; rrst_n == 1;});
                        `uvm_info("RD_SEQ", $sformatf("rinc = %0b", req.rinc), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("----------------------------------------------RD_END--------------------------------------------------");
                end
                wait_for_grant();
                void'(req.randomize() with {rinc == 0;});
                `uvm_info("RD_SEQ", $sformatf("rinc = %0b", req.rinc), UVM_LOW);
                send_request(req);
                wait_for_item_done();
        endtask
endclass

class rd_seq_sq extends uvm_sequence;
        `uvm_object_utils(rd_seq_sq)
        seq_item req;
        function new(string name = "rd_seq_sq");
                super.new(name);
        endfunction
        task body();
                //$display("------------------------------------------------------------------------------------");
                repeat(N)begin
                        //$display("--------------------------------------------RD_START--------------------------------------------------");
                  req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {rinc == 0;});
                        `uvm_info("RD_SEQ", $sformatf("rinc = %0b", req.rinc), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("----------------------------------------------RD_END--------------------------------------------------");
                end
                repeat(N)begin
                        //$display("--------------------------------------------RD_START--------------------------------------------------");
                  req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {rinc == 1;});
                        `uvm_info("RD_SEQ", $sformatf("rinc = %0b", req.rinc), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("----------------------------------------------RD_END--------------------------------------------------");
                end
        endtask
endclass

class wr_seq_sq extends uvm_sequence;
        `uvm_object_utils(wr_seq_sq)
        seq_item req;
        function new(string name = "wr_seq_sq");
                super.new(name);
        endfunction
        task body();
                //$display("------------------------------------------------------------------------------------");
                repeat(N)begin
                        //$display("--------------------------------------------RD_START--------------------------------------------------");
                  req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {winc == 1;});
                        `uvm_info("WR_SEQ", $sformatf("winc = %0b", req.winc), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("----------------------------------------------RD_END--------------------------------------------------");
                end
                repeat(N)begin
                        //$display("--------------------------------------------RD_START--------------------------------------------------");
                  req = seq_item::type_id::create("req");
                        wait_for_grant();
                        void'(req.randomize() with {winc == 0;});
                        `uvm_info("RD_SEQ", $sformatf("winc = %0b", req.rinc), UVM_LOW);
                        send_request(req);
                        wait_for_item_done();
                        //$display("----------------------------------------------RD_END--------------------------------------------------");
                end
        endtask
endclass

class v_seq extends uvm_sequence;
        rd_seq rd_sq;
        wr_seq wr_sq;
        wr_seq_sq wr_sq_2;
        rd_seq_sq rd_sq_2;
        `uvm_object_utils(v_seq);
        `uvm_declare_p_sequencer(v_sequencer);

        function new(string name = "v_seq");
                super.new(name);
        endfunction

        task body();
                rd_sq = rd_seq::type_id::create("rd_seq");
                wr_sq = wr_seq::type_id::create("wr_seq");
                rd_sq_2 = rd_seq_sq::type_id::create("rd_seq_2");
                wr_sq_2 = wr_seq_sq::type_id::create("wr_seq_2");
                begin
                        //rd_rst_sq.start(p_sequencer.rd_sqr);
                        //wr_rst_sq.start(p_sequencer.wr_sqr);
                        fork
                                wr_sq.start(p_sequencer.wr_sqr);
                                rd_sq.start(p_sequencer.rd_sqr);
                        join
                        fork
                                wr_sq_2.start(p_sequencer.wr_sqr);
                                rd_sq_2.start(p_sequencer.rd_sqr);
                        join
                end
        endtask
endclass

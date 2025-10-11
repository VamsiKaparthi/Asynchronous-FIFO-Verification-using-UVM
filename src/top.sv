module top;
        `include "uvm_macros.svh"
        import uvm_pkg::*;

        bit wclk, rclk;
        bit rrst_n, wrst_n;

        always #10 rclk = ~rclk;
        always #5 wclk = ~wclk;

        inf vif(rclk, rrst_n, wclk, wrst_n);

        event we, re;

        FIFO #(DSIZE, ASIZE) dut(.rdata(vif.rdata), .wfull(vif.wfull), .rempty(vif.rempty), .wdata(vif.wdata), .winc(vif.winc), .wclk(wclk), .wrst_n(wrst_n), .rinc(vif.rinc), .rclk(rclk), .rrst_n(rrst_n));

        initial begin
                #20;
                rrst_n = 1;
                #20;
                wrst_n = 1;
        end

        initial begin
                uvm_config_db#(virtual inf)::set(null, "*", "vif", vif);
                uvm_config_db#(event)::set(null, "*", "we", we);
                uvm_config_db#(event)::set(null, "*", "re", re);
                run_test("test");
        end
endmodule

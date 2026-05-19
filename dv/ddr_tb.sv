// ddr_tb.sv
class ddr_transaction;
    rand bit rnw;
    rand bit [2:0] bank;
    
    constraint c_bank { bank inside {[0:3]}; } // Restrict to 4 banks
endclass

module ddr_tb;
    logic clk;
    logic rst_n;
    logic user_req_valid;
    logic user_req_rnw;
    logic [2:0] user_req_bank;
    logic user_req_ready;

    ddr_if dif(.clk(clk), .rst_n(rst_n));

    ddr_controller_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .user_req_valid(user_req_valid),
        .user_req_rnw(user_req_rnw),
        .user_req_bank(user_req_bank),
        .user_req_ready(user_req_ready),
        .ddr_cs_n(dif.cs_n),
        .ddr_ras_n(dif.ras_n),
        .ddr_cas_n(dif.cas_n),
        .ddr_we_n(dif.we_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        user_req_valid = 0;
        #20 rst_n = 1;

        // Randomized Stimulus Generation
        begin
            ddr_transaction tx;
	    tx = new();
            for (int i = 0; i < 20; i++) begin
                assert(tx.randomize());
                
                @(posedge clk);
                while (!user_req_ready) @(posedge clk); // Wait if FIFO is full
                
                user_req_valid = 1;
                user_req_rnw = tx.rnw;
                user_req_bank = tx.bank;
                
                @(posedge clk);
                user_req_valid = 0;
                
                // Random delay between requests
                repeat($urandom_range(0, 5)) @(posedge clk);
            end
        end

        #200 $finish;
    end

    // Dump waves for debugging
    initial begin
        $dumpfile("ddr_waves.vcd");
        $dumpvars(0, ddr_tb);
    end
endmodule

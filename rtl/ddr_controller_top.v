// ddr_controller_top.v
module ddr_controller_top (
    input wire clk,
    input wire rst_n,
    // Native User Interface
    input wire user_req_valid,
    input wire user_req_rnw,
    input wire [2:0] user_req_bank,
    output wire user_req_ready,
    // DFI-like PHY Interface
    output wire ddr_cs_n,
    output wire ddr_ras_n,
    output wire ddr_cas_n,
    output wire ddr_we_n
);

    wire fifo_empty, fifo_full;
    wire queue_pop;
    wire [3:0] fifo_dout; // [3] = rnw, [2:0] = bank

    assign user_req_ready = ~fifo_full;

    textbook_fifo #(
        .DATA_WIDTH(4),
        .DEPTH(8)
    ) cmd_queue (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(user_req_valid && user_req_ready),
        .din({user_req_rnw, user_req_bank}),
        .rd_en(queue_pop),
        .dout(fifo_dout),
        .empty(fifo_empty),
        .full(fifo_full)
    );

    ddr_fsm core_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .valid_req(~fifo_empty),
        .req_rnw(fifo_dout[3]),
        .req_bank(fifo_dout[2:0]),
        .queue_pop(queue_pop),
        .cs_n(ddr_cs_n),
        .ras_n(ddr_ras_n),
        .cas_n(ddr_cas_n),
        .we_n(ddr_we_n)
    );

endmodule

// textbook_fifo.v
module textbook_fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [DATA_WIDTH-1:0] din,
    input wire rd_en,
    output reg [DATA_WIDTH-1:0] dout,
    output wire empty,
    output wire full
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] wr_ptr;
    reg [$clog2(DEPTH)-1:0] rd_ptr;
    reg [$clog2(DEPTH):0] count;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            dout <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
            end
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end
            
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: count <= count;
            endcase
        end
    end
endmodule

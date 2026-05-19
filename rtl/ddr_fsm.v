// ddr_fsm.v
module ddr_fsm (
    input wire clk,
    input wire rst_n,
    input wire valid_req,
    input wire req_rnw, // 1 for Read, 0 for Write
    input wire [2:0] req_bank,
    output reg queue_pop,
    
    // DFI-like Command Interface (Active Low)
    output reg cs_n,
    output reg ras_n,
    output reg cas_n,
    output reg we_n
);

    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        ACT   = 3'b001,
        WAIT_TRCD = 3'b010,
        CAS   = 3'b011, // Read or Write
        PRE   = 3'b100
    } state_t;

    state_t state, next_state;
    
    // Bank tracking (Simplified: assuming 1 bank tracker for demonstration)
    reg bank_active; 
    reg [1:0] delay_cnt;

    // Command Truth Table (CS, RAS, CAS, WE)
    localparam CMD_NOP = 4'b0111;
    localparam CMD_ACT = 4'b0011;
    localparam CMD_RD  = 4'b0101;
    localparam CMD_WR  = 4'b0100;
    localparam CMD_PRE = 4'b0010;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bank_active <= 0;
            delay_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == ACT) begin
                bank_active <= 1;
                delay_cnt <= 1; // Simulate tRCD = 2 cycles
            end else if (state == WAIT_TRCD) begin
                delay_cnt <= delay_cnt - 1;
            end else if (state == PRE) begin
                bank_active <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        queue_pop = 0;
        {cs_n, ras_n, cas_n, we_n} = CMD_NOP;

        case (state)
            IDLE: begin
                if (valid_req) begin
                    if (!bank_active) next_state = ACT;
                    else next_state = CAS;
                end
            end
            ACT: begin
                {cs_n, ras_n, cas_n, we_n} = CMD_ACT;
                next_state = WAIT_TRCD;
            end
            WAIT_TRCD: begin
                if (delay_cnt == 0) next_state = CAS;
            end
            CAS: begin
                queue_pop = 1;
                if (req_rnw) {cs_n, ras_n, cas_n, we_n} = CMD_RD;
                else         {cs_n, ras_n, cas_n, we_n} = CMD_WR;
                next_state = PRE; // Auto-precharge for simplicity
            end
            PRE: begin
                {cs_n, ras_n, cas_n, we_n} = CMD_PRE;
                next_state = IDLE;
            end
        endcase
    end
endmodule

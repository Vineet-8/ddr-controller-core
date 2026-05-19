// ddr_if.sv
interface ddr_if(input logic clk, input logic rst_n);
    logic cs_n;
    logic ras_n;
    logic cas_n;
    logic we_n;

    // Command decodes
    wire is_act = (!cs_n && !ras_n && cas_n && we_n);
    wire is_rd  = (!cs_n && ras_n && !cas_n && we_n);
    wire is_wr  = (!cs_n && ras_n && !cas_n && !we_n);
    wire is_pre = (!cs_n && !ras_n && cas_n && !we_n);

    // SVA: ACT must be followed by RD or WR after tRCD (2 cycles)
    property p_trcd_check;
        @(posedge clk) disable iff (!rst_n)
        is_act |-> ##3 (is_rd || is_wr);
    endproperty
    assert_trcd: assert property(p_trcd_check) 
        else $error("Protocol Violation: tRCD timing not met between ACT and CAS.");

    // SVA: Mutually exclusive commands
    property p_mutex_cmds;
        @(posedge clk) disable iff (!rst_n)
        $onehot0({is_act, is_rd, is_wr, is_pre});
    endproperty
    assert_mutex: assert property(p_mutex_cmds)
        else $error("Protocol Violation: Multiple commands asserted simultaneously.");

endinterface

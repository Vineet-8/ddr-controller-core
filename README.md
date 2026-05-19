# Micro-DDR Memory Controller Core & SV Verification Environment

A synthesizeable JEDEC-compliant (simplified) Micro-DDR Controller designed to manage basic SDRAM commands (ACT, CAS, PRECHARGE). The design incorporates a standard front-end command queue and handles bank cycle timing constraint management.

## Key Features
- **Front-End Architecture:** Implements a textbook Synchronous FIFO command queue to manage backpressure from incoming transaction requests seamlessly.
- **Protocol Automation:** FSM engine translates high-level user read/write operations into explicit DDR control signals (`cs_n`, `ras_n`, `cas_n`, `we_n`).
- **Timing Enforcement:** Hard-coded configuration safely enforces standard structural constraints such as $t_{RCD}$ (RAS-to-CAS Delay).
- **SystemVerilog Verification:** Outfitted with an interface-based assertion engine (SVA) protecting against timing violations, validated by a randomized dynamic testbench class.

## Simulation & Verification (Cadence Xcelium)
The design includes SystemVerilog assertions checking structural compliance. All randomized dynamic transactions completed without a single error or protocol violation.

## Synthesis Metrics (Cadence Genus)
The design was successfully synthesized targeting an aggressive 200 MHz clock frequency ($5.0\text{ ns}$ period) under nominal operating parameters[cite: 4].

### 1. Timing Summary
- **Target Period:** 5.0 ns ($5000\text{ ps}$)
- **Data Path Propagation:** 0.34 ns ($340\text{ ps}$) over 5 logic levels
- **Worst Negative Slack (WNS):** **+3.575 ns** (Timing fully closed)
- **Critical Path Endpoint:** `cmd_queue_count_reg[3]/D`

### 2. Area Utilization
- **Total Silicon Footprint:** $1488.384\text{ }\mu\text{m}^2$
- **Gate Count:** 112 cells mapped

### 3. Power Characteristics
- **Total Power Dissipation:** **89.97 µW**
- **Internal / Switching / Leakage:** 55.11% / 37.48% / 7.41% 

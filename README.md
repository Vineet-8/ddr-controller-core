# Micro-DDR Memory Controller Core & SV Verification Environment

A synthesizeable JEDEC-compliant (simplified) Micro-DDR Controller designed to manage basic SDRAM commands (ACT, CAS, PRECHARGE). The design incorporates a standard front-end command queue and handles bank cycle timing constraint management.

## Key Features
- **Front-End Architecture:** Implements a textbook Synchronous FIFO command queue to manage backpressure from incoming transaction requests seamlessly.
- **Protocol Automation:** FSM engine translates high-level user read/write operations into explicit DDR control signals (`cs_n`, `ras_n`, `cas_n`, `we_n`).
- **Timing Enforcement:** Hard-coded configuration safely enforces standard structural constraints such as $t_{RCD}$ (RAS-to-CAS Delay).
- **SystemVerilog Verification:** Outfitted with an interface-based assertion engine (SVA) protecting against timing violations, validated by a randomized dynamic testbench class.

## Project Structure
- `/rtl`: Contains core synthesizeable design files.
- `/dv`: Holds the SystemVerilog verification suite and assertion interface.
- `/synth`: Production assets mapping out constraints, generic gate-level netlists, and script controls.

## Simulation & Verification (Cadence Xcelium)
To execute the testbench environment in batch simulation mode, run:
\`\`\`bash
xrun -sv rtl/*.v dv/*.sv
\`\`\`
The design includes strict SystemVerilog assertions checking structural compliance. All randomized dynamic transactions completed without a single error or protocol violation.

## Synthesis Metrics (Cadence Genus)
[cite_start]The design was successfully synthesized targeting an aggressive 200 MHz clock frequency ($5.0\text{ ns}$ period) under nominal operating parameters[cite: 4].

### 1. Timing Summary
- [cite_start]**Target Period:** 5.0 ns ($5000\text{ ps}$) [cite: 6, 7]
- [cite_start]**Data Path Propagation:** 0.34 ns ($340\text{ ps}$) over 5 logic levels [cite: 11]
- [cite_start]**Worst Negative Slack (WNS):** **+3.575 ns** (Timing fully closed) [cite: 11]
- [cite_start]**Critical Path Endpoint:** `cmd_queue_count_reg[3]/D` [cite: 7]

### 2. Area Utilization
- [cite_start]**Total Silicon Footprint:** $1488.384\text{ }\mu\text{m}^2$ [cite: 5]
- [cite_start]**Gate Count:** 112 cells mapped [cite: 5]

### 3. Power Characteristics
- [cite_start]**Total Power Dissipation:** **89.97 µW** [cite: 3]
- [cite_start]**Internal / Switching / Leakage:** 55.11% / 37.48% / 7.41% [cite: 3]

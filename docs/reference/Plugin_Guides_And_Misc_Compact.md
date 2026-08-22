# IDERM -- Example plugin guides and system diagrams, compacted index

One line per bundled example plugin/guide, plus a short note per system-diagram mindmap. Canonical detail lives in `docs/90-user/` and `docs/mindmaps/` (not part of this doc set) -- this index exists for a reader who wants the shape of the example-plugin set and the system's own diagrams without reading 26 full entries. The full user manual and Quick Start Guide ship separately, unabridged.

## Loading model

Plugins are discovered per-project, not globally: `doctor-rule` from `<project>/.iderm/plugins/*.wasm`, `view-provider` from `<project>/.iderm/views/*.wasm`, `repair-recipe` from `<project>/.iderm/repair-recipes/*.wasm`. An optional `.iderm/plugin.toml` narrows any list to an explicit allowlist; its absence means every `.wasm` found is active. Doctor-rule and view-provider plugins run automatically on scan/open, no confirm gate -- opening an unfamiliar project's `.iderm/` directory means running whatever it ships, the same trust model as any build tool's task file.

## Example plugins

| Guide | Demonstrates |
|---|---|
| Repository Health Checks | Two `doctor-rule` smoke tests proving the sandbox host-call round trip: `.gitignore` presence via `read-file`, and a C/C++ `static_assert(sizeof(...))` struct-layout idiom detector -- silent when the language doesn't apply. |
| Automated Repair | The one `repair-recipe` example: proposes a starter `.gitignore` exactly when the health check flags its absence; never edits an existing file, never guesses language-specific entries. |
| EMC Curve Viewer | Reference example touching three of the six view-provider primitives at once -- a synthetic emissions sweep as a braille curve against a limit line and an uncertainty band, with a cursor-readout table; live-refresh drifts the data each tick to exercise real redraw, not just scheduling. |
| Deviation Analyzer | Predicted-vs-actual residual/correlation/confidence-band/outlier analysis, built on a domain-agnostic shared math crate; a deliberately planted outlier gives the detector a known point to find. |
| Distribution Analysis | Histogram/empirical-CDF/regression over 500 deterministic Gaussian samples; flags an unusually concentrated bin or a real trend across the run. |
| Risk Band Viewer | A P10/P50/P90 band over a synthetic Monte Carlo random-walk ensemble; live-refresh re-derives the ensemble each tick for genuine step-to-step movement. |
| Checksum Inspector | Real CRC-32/CRC-16/Internet-checksum verification against published test vectors, over synthetic frames; one frame's trailer is corrupted on rotation each tick to prove the pipeline catches a different real fault each time. |
| Invariant Checker | Parses a small tool-agnostic `name|status|description` intermediate format any real model checker's own translation script can emit -- three honest statuses (`holds`/`violated`/`unknown`), the third a real bounded-search outcome, not an omission. |
| Channel/Duty-Cycle Budget Checker | Checks declared sub-band duty-cycle usage against real regulatory-style limits, three severity tiers including an early warning at 90% of budget. |
| Logic/Protocol Capture Viewer | Parses real VCD (IEEE 1364/1800) digital-logic captures; live-refresh re-reads a still-growing file, verified against a real running emulator (transition count grew across two live snapshots). |
| Analog Waveform Viewer | Parses a generic multi-channel analog CSV shape; first plugin validated against real hardware (a class-compliant USB audio interface via plain ALSA capture, no vendor driver). Also demonstrates manual data-point entry (validated against non-finite/out-of-range input before it can reach a chart) and multi-stream pinning for several concurrent capture files in one project. |
| Color Swatch Viewer | Real CIE Lab-to-sRGB conversion verified against published reference values; flags a color whose true, unclamped conversion falls outside the sRGB gamut before it's silently clamped. |
| Halftone Screening Viewer | Classic amplitude-modulated halftone screening math; flags real moiré risk when two declared screen angles sit too close together, using real print-industry reference angles. |
| Emergence Simulation Viewer | A generic totalistic 2D cellular automaton (Conway's Game of Life as the shipped rule); the one example where live-refresh genuinely steps a running simulation forward each tick rather than re-deriving a cosmetic value -- verified against a glider's well-known invariant (constant live-cell count while translating). |
| Formal-Methods Trace/State-Graph Viewer | A hand-authored mutual-exclusion state machine and one real counterexample trace through it, togglable between the linear counterexample and the full reachable state graph. |
| Frame/Packet Builder and Inspector | Declares fixed-width fields with explicit endianness plus a checksum trailer, builds real frames from declared values, then inspects them back; a value that doesn't fit its field's width is caught before use. |
| Link-Property Graph Calculator | Three genuinely different Dijkstra-style routing objectives (latency/bandwidth/reliability) over one graph, verified against a hand-computed topology where the objectives disagree; live-refresh correctly rerouted around a removed edge with no manual command. |
| Option Pricing Surface | Standard closed-form option pricing verified against a textbook reference case and put-call parity; flags a price violating a real no-arbitrage bound as a genuine bug, not a cosmetic issue. |
| Flow Field Visualizer | Closed-form 2D potential flow past a cylinder (not a numerical CFD solver), verified against real documented properties -- the no-penetration boundary condition, doubled surface speed, and exactly two stagnation points. |
| Testbench Emulators | Not plugins -- three standalone binaries behaving like real continuously-running capture instruments (logic analyzer, oscilloscope/DAQ, frame source), each injecting a real, deterministic anomaly at a known rate so the matching plugin's fault-detection has something genuine to catch. Explicitly not a claim of real hardware validation. |
| Wave Shoaling Viewer | A bespoke rendering (not a new file format) recognizing one specific real capture shape by content and drawing it as a seafloor cross-section with a wave-height band; the underlying physics is a real linear (Airy) wave-shoaling solution, not synthetic noise. Deployed to this project's own workspace only, not redeployed to every consuming project. |
| Live-Mode Performance and Cost Disclosure | States plainly what `F5` live-refresh actually costs (component caching, measured tick timings, the fastest interval directly measured as safe) and what it does not cover -- high-throughput streaming is explicitly out of scope, not silently assumed to scale. |

## System diagrams

- **Complete System** -- top-level flowchart of Core, the embedded editor, the plugin layer, and the headless interface, showing how a project scan reaches the doctor/repair engines, the renderer, and external tools via JSON/RPC.
- **Core Engine** -- the internal data flow from scan through doctor/repair to the confirm-gated write, independent of the plugin and headless surfaces.
- **Plugin System** -- the WASM sandbox boundary: both plugin worlds are pure functions returning data, never writing directly; the confirm gate lives entirely in Core.
- **Workflow** -- the top-level interaction loop (scan, doctor, repair confirm, open workspace) as a quick-glance diagram, complementing the phase-by-phase prose description elsewhere.

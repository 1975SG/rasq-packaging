# IDERM -- Roadmap, compacted index

One entry per phase/category. Canonical detail lives in `docs/roadmap/*.md` and `docs/Decisions.md` (not part of this doc set) -- this index states what shipped, what remains, and what is explicitly not planned.

## Phases (all landed through Phase 6)

| Phase | Status | Summary |
|---|---|---|
| 0 -- MVP | Landed | PTY passthrough, single-manifest scanner, static tree, 3-check doctor. Proof of thesis only. |
| 1 -- Core Usable Editor | Landed | Neovim embedded via msgpack-rpc; `repair` with dry-run diff preview; multi-manifest detection; build-tree panel (compiler/flags/libs/linker parse from `compile_commands.json`). |
| 2 -- Block-Mode UI | Landed | Protected-field full-screen atomic redraw for tree/doctor/build panels; additive mouse support (click-to-expand, click-menu dropdowns); dense/sleek default theme, CRT theme opt-in only. |
| 3 -- Core Tooling Completion | Landed | LSP client (subprocess per detected language), tree-sitter grammar loading, task runner, Markdown/Mermaid/LaTeX preview, SVG viewer, YAML/JSON inspector -- all Category 1 (declarative manifest + subprocess), no plugin ABI dependency. |
| 4 -- Plugin Architecture | Landed | WASM/WIT plugin ABI (`doctor-rule`, `repair-recipe`, `view-provider`); TOML-driven language manifests (5 default: Rust/Go/TS/Python/C-C++, 5 niche opt-in: LaTeX/TLA+/Promela/Murphi/Fortran, one proprietary numerical-computing candidate dropped for a licensed dependency behind its LSP shim); `idermviz` interface (three composable rendering primitives) fully implemented. |
| 5 -- Headless & Ecosystem | Landed | `scan`/`doctor --format=json`, versioned envelope schema; DOT/Mermaid dependency-graph export; Run Ledger (provenance log, unified with the JSON schema); shareable `.iderm/` project config. |
| 6 -- AI Adapter | Landed | Model-agnostic adapter (`.iderm/ai.toml`) over the headless interface only, no privileged internal access. Three categories: repair-suggestion adapter (routed through the same confirm gate as manual repair), educational/explain mode (narrower than originally scoped -- explains `doctor` findings, not a live rendered view), test-assistant mode (drives and reports on an existing verification run). Explicitly the one part of the project that breaks the offline guarantee; a future AI need the headless interface can't express is a signal the interface is incomplete, not grounds for a special case. |

## Phase 7 -- Workbenches (in progress, most categories landed)

Built entirely on Phase 4's `idermviz` ABI. Every workbench composes from three shared rendering primitives rather than each getting a bespoke one.

**Shared Bench Infrastructure (landed):** Deviation Analyzer (residuals/correlation/confidence band), Run Ledger, Figure Export (Core-side SVG + TikZ, PDF/compiled-report export explicitly excluded, revisit only on a real named need), Math/Distribution Visualizer (histogram/CDF/regression fit), multi-pane split view (up to 4 panes, fixed layout templates).

**Workbench categories, by capability (landed):** protocol/systems tooling (frame/packet builder-inspector, link-property graph calculator, ABI/contract smoke test, channel/interference budget checker); formal-methods tooling (state-graph and counterexample viewer, invariant checker panel); stochastic/flow-simulation tooling (option-pricing surface, risk-band P10/P50/P90 viewer, potential-flow visualizer); emergence/discrete-simulation tooling (generic cellular automaton, live-refresh genuinely steps the simulation); color-science tooling (Lab-to-sRGB colorspace conversion with an explicit out-of-gamut flag, halftone screening/moiré check).

**Hardware/instrumentation diagnostic workbench (in progress):** read-only by design, device access always owned by an existing subprocess tool, never a Core-side driver; device control is deferred, possibly permanently. Landed: logic/protocol capture viewer (reads an existing `.vcd` file; live capture-tool spawning generalized as project-declared custom tasks, not a capture-specific mechanism), analog waveform/curve viewer (generic multi-channel CSV), networked-instrument client (kept on the same subprocess/task path rather than a new plugin-side network ABI, since a live poll needs a non-blocking continuous-task lifecycle, now available generically). Deferred, unscoped: device control/configuration (a fundamentally different, write-capable trust boundary), high-throughput streaming capture (current live-refresh cadence is a different performance class entirely from continuous high-bandwidth signal streams).

**Publication gate (ADR-012):** repositories go public only once this phase ships *and* a real end-to-end test suite exists -- both required. Satisfied by a real 8-hour soak test (480/480 ticks, zero errors, zero emulator deaths, no memory leak, headless CLI plus real plugin-backed workbench load).

## Debugger integration (scoped, not started)

Two structurally separate tracks identified; only one is in scope. DAP client (breakpoints/step/call-stack/variable inspection for C/C++/Fortran/Rust/Python): GDB 14.1+ has native DAP support covering C/C++/Fortran/Rust directly, `debugpy` covers Python -- subprocess-owned, same Category 1 trust model as LSP. Genuinely unresolved: a debugger is direct, unconfirmed control over a running process, unlike every read-only or propose-then-confirm integration so far; live-debuggee trust and `iderm` self-debugging (a full-screen TUI needs a second surface for its own debugger UI) are both explicitly left open, not designed yet. A second track (a browser-devtools-protocol client for my other, already-public browser-panel projects) was considered and dropped -- the real capability already exists standalone in those tools' own host platform, not a gap this project needs to close.

## Explicitly deferred / not planned

- Mobile field-capture workbench -- a separate build resting on the desktop core, not scheduled to a phase.
- Self-profiling/performance panel -- deferred for lack of a real large-project data point; every dogfooding target so far is a small personal project. Revisit if a real scaling problem is ever observed, and design its metrics from what that shows, not in advance.
- Remote/SSH project support; Docker/container-aware scanning; a plugin-marketplace UI (a rules/recipe repo is in scope, a UI browser for it is not); hardcoded AI-provider list (contradicts the model-agnostic adapter design).
- Flask-specific debugging, TLA+/Promela/Murphi step-debugging, and proprietary/closed-environment language support are explicitly out of scope for the debugger-integration track, stated directly rather than left as a silent gap.

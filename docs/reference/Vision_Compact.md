# IDERM -- Project Vision, compacted

One-page statement of what IDERM is, is not, and why it exists. Full detail lives in `00_Project_Vision.md` (not part of this doc set); decision history in `Decisions_Compact.md`; phase-by-phase status in `Roadmap_Compact.md`.

## Thesis

Not a new IDE. Not a better TUI. A terminal-first, project-aware environment that is self-explanatory for a complex project, is not a GUI timebomb, and visualizes whatever the user is doing and needs to understand -- not a feature checklist run against other tools.

Concretely: block-mode interaction (IBM 3270 lineage -- protected fields, full-screen atomic redraw), rendered with modern GPU-accelerated terminal rendering. The shell stays the primary interface; IDERM never competes with it, it understands the project around it. Brings formal methods, simulation, measurement, and analysis into the project context, reducing the practical overhead of using them during exploratory and study phases -- it does not replace the methods or their specialist tools, it gets them out of the way of the project itself.

## What IDERM is not

- Not a text-editing engine (embeds one, does not build one)
- Not a GUI application (no Qt, no windowing toolkit -- the terminal is the entire surface)
- Not an AI-first tool (AI is an optional, last-mile adapter, not core)
- Not a language-specific IDE (core ships language-agnostic; language support is a plugin concern)

## Core architecture decision

Rust core, `ratatui` + `crossterm` for rendering and input. No Qt. Single static binary -- the "thin by nature" requirement itself, not a theme choice. See `Architecture_Compact.md`.

## A toolsmith's tool

Once the workbench layer exists, IDERM's real audience is builders, not just users -- that changes what "done" means for the plugin surface:

- **Core eats its own ABI.** Doctor, repair, and build-tree parsing are implemented against the same plugin interfaces external authors use, not a simplified internal shortcut.
- **`idermviz` exposes primitives, not finished widgets.** A drawing surface and data-binding, not a fixed menu of chart types.
- **Every workbench plugin carries an assumptions ledger.** Every simplification a tool makes is stated at the point it matters, not buried in a docstring. "It just works" is not an acceptable answer to what a tool does and does not do.
- **Scaffolding over prose.** A generator producing a correct manifest and ABI boilerplate lowers the bar for the next plugin more than a page of documentation does.

A toolsmith's tool and a terminal-native, protocol-honest, no-hidden-magic environment are the same claim from two directions, not two separate goals.

## Status

Phases 0-6 built and verified through real PTY sessions and real spawned processes, not `cargo check` alone. The plugin ABI (`doctor-rule`, `repair-recipe`, `view-provider`/`idermviz`) is fully wired into the running app. The headless interface, Run Ledger, and AI adapter are closed. Workbenches have cleared their own publication gate: a real 8-hour soak test against live plugins and continuous synthetic load completed with zero errors. Example plugin domains ship across protocol/systems, formal methods, stochastic/flow, emergence, color science, and hardware/instrumentation categories. Ongoing work past the publication gate is real-hardware hardening -- cross-platform test passes surfacing and fixing concrete bugs -- rather than new-phase design; see `Decisions_Compact.md` for the canonical decision log and `Roadmap_Compact.md` for phase-by-phase detail.

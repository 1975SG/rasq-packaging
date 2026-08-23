# iderm-packaging

**[Live demo and landing page &rarr;](https://1975sg.github.io/iderm-packaging/)**

[![iderm: project tree, Doctor, outline, docs, tasks, editor, and live workbenches in one terminal](https://1975sg.github.io/iderm-packaging/hero.png)](https://1975sg.github.io/iderm-packaging/)

Packaging and documentation for [IDERM](https://github.com/1975SG) --
**I**ntegrated **D**evelopment, **E**ngineering & **R**esearch **M**anager, a
terminal-first, project-aware IDE.

Does anyone need a new IDE in 2026? No. A better TUI? No. IDERM is an
environment that's self-explanatory for a complex project, not a GUI
timebomb, that visualizes whatever you're doing and are eager to
understand -- bringing formal methods, simulation, measurement, and
analysis into the project context, reducing the practical overhead of
using these methods during exploratory and study phases. It does not
replace the methods or their specialist tools, it just gets them out of
the way of the project you're actually working on.

## What's here

This repository currently hosts packaging (RPM, DEB metadata, Homebrew,
AppImage), the user manual and Quick Start Guide in full, and a compact
index of the project's architecture, decisions, roadmap, and security
posture. Core's Rust source is not in this repository yet -- it lives
separately for now and will be added here once it's ready to go public.
See `packaging/README.md` for exactly what's real, verified, and still
open in the packaging story.

## Documentation

- [Quick Start Guide](docs/QSG.md) -- controls and a real walkthrough
- [User manual](docs/manual/index.md) -- full detail
- [`docs/reference/`](docs/reference/) -- compact indexes: architecture,
  decisions, roadmap, security + real verification results, project
  vision, and the plugin/workbench guides. Each one links back to where
  its full-detail original lives once Core's own repository is public.

## Packaging status

Four package formats real-verified on real hardware: DEB, RPM, Homebrew,
and AppImage. `cargo deny`'s dependency/license/advisory check is real-
verified too. Full detail, including exactly what's still open, is in
[`packaging/README.md`](packaging/README.md) -- nothing there is claimed
without a real build and a real check of the output.

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT license ([LICENSE-MIT](LICENSE-MIT))

at your option.

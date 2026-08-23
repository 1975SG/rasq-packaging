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

## Download

**[v0.1.0 →](https://github.com/1975SG/iderm-packaging/releases/tag/v0.1.0)** -- first tagged release, real builds, real installs verified on real hardware.

- [`iderm_0.1.0-1_amd64.deb`](https://github.com/1975SG/iderm-packaging/releases/download/v0.1.0/iderm_0.1.0-1_amd64.deb) / [`iderm-plugins-bundled_0.1.0-1_amd64.deb`](https://github.com/1975SG/iderm-packaging/releases/download/v0.1.0/iderm-plugins-bundled_0.1.0-1_amd64.deb) -- DEB
- [`iderm-0.1.0-3.el10.x86_64.rpm`](https://github.com/1975SG/iderm-packaging/releases/download/v0.1.0/iderm-0.1.0-3.el10.x86_64.rpm) / [`iderm-plugins-bundled-0.1.0-3.el10.noarch.rpm`](https://github.com/1975SG/iderm-packaging/releases/download/v0.1.0/iderm-plugins-bundled-0.1.0-3.el10.noarch.rpm) -- RPM
- [`iderm-x86_64.AppImage`](https://github.com/1975SG/iderm-packaging/releases/download/v0.1.0/iderm-x86_64.AppImage) -- AppImage, static musl build, runs on any x86_64 Linux
- [Homebrew formula](packaging/homebrew/) -- `brew install`/`upgrade`/`uninstall` all verified for real on macOS

Verify with the release's `SHA256SUMS`/`SHA256SUMS.asc` (RSA 4096 key `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`):

```
gpg --verify SHA256SUMS.asc SHA256SUMS
sha256sum -c SHA256SUMS
```

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

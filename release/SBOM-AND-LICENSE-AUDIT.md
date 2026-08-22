# SBOM + dependency license audit

Real run, 2026-08-22. Two artifacts, two different tools, two different
scopes -- read together, not interchangeably:

- [`iderm.cdx.json`](iderm.cdx.json) -- a real CycloneDX 1.5 SBOM
  (`cargo cyclonedx --describe binaries`), 343 components. Scoped to
  every package `Cargo.lock` resolves for the `iderm` binary, including
  build-time-only dependencies and some optional dependencies a
  feature-inactive crate carries in its own dependency list (see the
  `termwiz`/`terminfo` note below) -- a conservative, complete bill of
  materials, not a precise "what's actually linked in" list.
- [`dependency-licenses.txt`](dependency-licenses.txt) -- the real
  output of `cargo license`, one line per distinct license expression,
  crates grouped underneath it. Same broader Cargo.lock scope as the
  SBOM, same caveat.

`cargo deny check licenses` (already run earlier, see
`packaging/README.md`) is the real policy gate -- it evaluates against
the actual feature-resolved dependency graph (`cargo tree`'s own
scope, confirmed directly), not the full Cargo.lock superset these two
artifacts use. That's why the two real findings below don't fail
`cargo deny` even though they look concerning in the raw listings.

## Real findings, checked against the actual compiled binary

- **`nvim-rs` is LGPL-3.0.** Already a documented, deliberate exception
  -- see `deny.toml`'s allow-list comment and
  `docs/manual/10_License.md` Clause 10.4. Confirmed active in the real
  build (`cargo tree` shows it, it's the embedded-Neovim RPC client).
- **`ittapi`/`ittapi-sys` are `BSD-3-Clause OR GPL-2.0`.** An SPDX OR
  expression, not a dual obligation -- the BSD-3-Clause option alone
  satisfies compliance, already in `deny.toml`'s allow-list, GPL-2.0 is
  just the alternative a licensee could choose instead, not a
  requirement. Confirmed active in the real build, pulled in
  transitively via `wasmtime` (Intel's ITT API, VTune profiler JIT
  integration).
- **`terminfo` is WTFPL, but it's not actually in the shipped binary.**
  Confirmed via a real check: `cargo tree` (the actual feature-resolved
  build graph) shows zero occurrences of `termwiz` or `terminfo`
  anywhere -- they're an optional dependency `ratatui` carries in
  `Cargo.lock` for a backend feature this project doesn't enable, not
  something compiled in. Appears in the SBOM/`cargo license` listing
  because both tools scan the full `Cargo.lock` resolution, not the
  active feature set. Not a real license exposure; noted here so a
  future reader doesn't need to re-derive this.

## How to apply

Regenerate both artifacts (`cargo cyclonedx --format json --describe
binaries --spec-version 1.5`, `cargo license`) whenever a real release
build happens -- these are today's snapshot, not guaranteed to match a
future dependency tree. `cargo deny check` stays the actual enforcement
gate; these two are the fuller-picture bill of materials a real SBOM
consumer or license auditor would actually want to see.

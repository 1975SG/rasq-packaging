# 6. Product specification

| Field | Value |
|---|---|
| Document type | User manual, Clause 6 |
| Part of | [Index](index.md) |
| Verification date | 2026-08-16 |

## 6.1 Identification

| Item | Value |
|---|---|
| Product | IDERM |
| Product version | `0.1.0` |
| Rust edition | 2024 |
| Plugin ABI | `iderm:plugin@0.4.0` |
| Headless JSON schema | `0.2.0` |
| Run Ledger schema | `0.1.0`, independently versioned |
| License | `MIT OR Apache-2.0` |

## 6.2 Current build characteristics

| Item | Verified value |
|---|---|
| Release executable | `target/release/iderm` |
| Local release size | 37,504,016 bytes |
| Local target | Linux GNU, `x86_64` |
| Local dynamic libraries | `libgcc_s`, `libm`, `libc` |

Size and linkage are build-specific observations. They are not compatibility
guarantees.

## 6.3 Default project detection

| Manifest | Label | Default tasks or discovery |
|---|---|---|
| `Cargo.toml` | Cargo | build, test, run |
| `go.mod` | Go | build, test, run |
| `package.json` | npm | install, test, build |
| `pyproject.toml` | Python | pytest |
| `CMakeLists.txt` | CMake | configured build discovery |
| `Makefile` | Make | base make and target discovery |

Detection is limited to the project root. Multiple manifests may coexist.

## 6.4 Optional language manifests

LaTeX, TLA+, Promela, Murphi, and Fortran manifests are supplied in the source
tree but are not embedded as defaults. A project activates them through
`.iderm/languages/`.

## 6.5 Terminal and rendering

| Item | Value |
|---|---|
| Terminal backend | `crossterm` |
| UI library | `ratatui` |
| Interaction | Alternate screen, raw input, full-screen redraw |
| Color | 24-bit recommended |
| Workbench panes | 1 to 4 |
| Minimum live interval | 100 ms |
| View primitives | XY chart, heatmap, table, state graph, trace, composed |
| Figure export | XY chart only, SVG and TikZ |

Static export excludes the interactive cursor. Exported labels are escaped for
XML and common LaTeX metacharacters. Symbols outside the implemented LaTeX map
may require LuaLaTeX, XeLaTeX, or manual correction.

## 6.6 Plugin runtime limits

| Limit | Value |
|---|---|
| Linear memory | 256 MiB per store |
| Call execution budget | 40 epoch ticks |
| Epoch interval | 50 ms |
| Nominal call budget | 2 s |
| Ambient WASI access | No preopens, environment, argv, or network |

Scheduling may affect observed interruption time. The nominal value is not a
hard real-time guarantee.

## 6.7 Headless output

`scan` and `doctor` return JSON envelopes. `graph` returns DOT or Mermaid text.
Ledger commands read or append `.iderm/run-ledger.jsonl`. Unknown or incomplete
headless syntax may fall through toward TUI handling unless recognized by the
current command dispatcher. Users should use the documented forms and
`--help`.

## 6.8 Compatibility

Version `0.1.0` is pre-1.0. The plugin ABI and JSON schemas are separately
versioned. Compatibility shall be evaluated for each interface, not inferred
from the product version alone.

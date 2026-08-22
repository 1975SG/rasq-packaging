# 7. Verification

| Field | Value |
|---|---|
| Document type | User manual, Clause 7 |
| Part of | [Index](index.md) |
| Record date | 2026-08-16 |

## 7.1 Status

Verification is project evidence. It is not third-party certification,
functional-safety qualification, penetration testing, or a conformity
assessment.

## 7.2 Automated suite

```sh
cargo test
```

The current test binary enumerates 165 tests. The suite includes unit,
filesystem, parser, UI-state, headless, plugin, resource-limit, and subprocess
integration tests. Tests for Neovim and `rust-analyzer` require the real
executables on `PATH`.

Current local run, 2026-08-16: 163 passed and 2 failed. The Neovim integration
test could not find `nvim`. The `rust-analyzer` integration test received no
`Content-Length` header. All other tests passed.

A release decision shall use the complete test result, not test enumeration.

## 7.3 Recorded long-duration test

The recorded soak test of 2026-08-09 ran for 28,801 s and completed 480 of 480
ticks. It exercised headless scan, Doctor, ledger, diff, graph, plugins, and
three continuous emulator processes. Recorded command errors and emulator
deaths were zero.

The result applies to the tested build, host, data, and duration. It does not
establish universal stability.

## 7.4 Recorded platforms

| Platform | Method | Recorded result |
|---|---|---|
| RHEL 10.2 | PTY-driven TUI and headless runs | Pass after two same-day fixes |
| Debian 12 on physical x86_64 hardware | Source build and automated suite | Pass |
| Zorin OS Education on MacBook Pro | Prebuilt binary, informal use | Pass within informal scope |
| macOS | Build and security review reports in `docs/reports/` | See dated report |

The reports under `docs/reports/` are the source records. This table is a
summary.

## 7.5 Security regression coverage

Tests cover:

- read and glob confinement to the project root;
- absolute, parent traversal, and symlink escape rejection;
- new-file-only Repair behavior;
- plugin ABI rejection;
- plugin timeout interruption;
- plugin memory growth rejection;
- terminal restoration paths; and
- argv-array subprocess invocation.

The malicious repair test attempted a path outside the project root. Core
refused the proposal and did not create the target file.

## 7.6 Acceptance record placeholders

Before public packaging, add dated evidence for:

- [PLACEHOLDER: clean RPM install, run, update, and removal]
- [PLACEHOLDER: clean Homebrew install, run, update, and removal]
- [PLACEHOLDER: signed artifact and checksum verification]
- [PLACEHOLDER: current third-party dependency license report]
- [PLACEHOLDER: independent security review, if commissioned]

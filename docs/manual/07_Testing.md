# 7. Verification

| Field | Value |
|---|---|
| Document type | User manual, Clause 7 |
| Part of | [Index](index.md) |
| Record date | 2026-08-23 |

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

## 7.6 Acceptance record

- **RPM install and run, 2026-08-22.** A real `.rpm` installed via
  `sudo rpm -i` on a clean RHEL box; the installed binary ran against
  a real project with real USB hardware attached. Record:
  `packaging/README.md`, RPM section. **Update and removal are not yet
  recorded** -- `rpm -U`/`rpm -e` against a prior install have not been
  exercised. Remains open.
- **Homebrew install and run, 2026-08-22.** A real
  `brew install --build-from-source --HEAD` on a clean macOS box; the
  installed binary ran a self-scan against its own repository and a
  real multi-pane live-hardware-capture session. Record:
  `packaging/README.md`, Homebrew section. **Update and removal are
  not yet recorded** -- `brew upgrade`/`brew uninstall` have not been
  exercised. Remains open.
- **Signed artifact and checksum verification, 2026-08-22.** A real
  GPG key (RSA 4096, fingerprint
  `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`) signed both local RPM
  artifacts; `rpm -Kv` confirmed a good signature and matching header
  and payload digests on both. `release/SHA256SUMS` covers five real
  local artifacts (2 DEB, 2 RPM, 1 AppImage); `sha256sum -c` confirmed
  all five. `release/SHA256SUMS.asc`, a detached signature over that
  file with the same key, verified with `gpg --verify`. Record:
  `signing/README.md`, `release/RELEASE-MANIFEST.md`.
- **`lintian` run against real `.deb` artifacts, 2026-08-23.** Root
  access became available on the real Debian 12 box; `lintian` 2.116.3
  installed and run against both real `.deb`s. Three real findings:
  `embedded-library libyaml` (a c2rust transliteration, not a true
  vendored C library -- understood, not actionable), `no-changelog`,
  and `no-manual-page`. `no-changelog` fixed the same day: added a
  real `debian/changelog` to Core, rebuilt both `.deb`s on the same
  box, re-ran `lintian` -- the finding is gone. `no-manual-page`
  remains open. Record: `packaging/README.md`, "Lintian: done for
  real" section.
- **Current third-party dependency license report, 2026-08-22.** A
  real `cargo license` run (`release/dependency-licenses.txt`) and a
  real CycloneDX 1.5 software bill of materials, 343 components
  (`release/iderm.cdx.json`, via `cargo cyclonedx`). Findings checked
  against the actual compiled binary, not only the broader dependency
  graph both tools scan by default. Record:
  `release/SBOM-AND-LICENSE-AUDIT.md`.
- **Independent security review, 2026-08-10.** A manual OWASP-class
  source review plus `cargo audit` (387 dependencies at the time) plus
  empirical proof-of-concept reproduction, commissioned and completed.
  One real, exploitable sandbox-boundary finding (a path-traversal
  escape in a host-facing plugin function), fixed the same day; two
  Low findings, addressed. Zero hand-written `unsafe` code in scope;
  zero dependency CVEs. Record: `docs/reference/Security_Reports_Compact.md`
  (full report in Core's own repository).

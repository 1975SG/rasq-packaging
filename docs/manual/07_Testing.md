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
  `packaging/README.md`, RPM section.
- **RPM update and removal, 2026-08-23.** A real `rpm -U` from
  `0.1.0-1` to `0.1.0-2` on a real RHEL 10.2 box, both packages,
  verified via `rpm -q`, `iderm --version`, and `man iderm` after the
  upgrade. A real `rpm -e` of both packages afterward found a real
  bug: three directories (`%{_docdir}/%{name}`, `%{_licensedir}/
  %{name}`, `%{_datadir}/iderm` and its `plugins/` subdirectory) were
  left behind, empty, because `install -D` to an absolute path plus a
  `%doc`/`%license` reference to that same path doesn't give RPM
  ownership of the containing directory the way the bare-filename
  shorthand does. Fixed with explicit `%dir` entries, `0.1.0-3`; a
  second real install-then-remove cycle confirmed all three
  directories are actually gone afterward. RHEL's own `rust`/
  `rust-toolset` packages currently cap at 1.92.0, which cannot build
  Core's pinned `wasmtime` 47.0.3 (needs 1.94.0+) -- a real attempt to
  downgrade wasmtime to a 1.92.0-compatible version (44.0.3) was
  reverted after `cargo deny` showed it reintroduces two disclosed
  WASI-sandbox CVEs (`RUSTSEC-2026-0188` and one other), fixed only at
  46.0.2+/47.0.3. This build used `rustup`'s newer toolchain with
  `rpmbuild --nodeps` instead, as a test-only exception -- RHEL's
  distro-toolchain build path for the current, patched source stays
  genuinely blocked until Red Hat ships a newer `rust` package.
  Record: `packaging/README.md`, RPM section.
- **Homebrew install and run, 2026-08-22.** A real
  `brew install --build-from-source --HEAD` on a clean macOS box; the
  installed binary ran a self-scan against its own repository and a
  real multi-pane live-hardware-capture session. Record:
  `packaging/README.md`, Homebrew section.
- **Homebrew update and removal, 2026-08-23.** The tap's local source
  repo was synced to the current project state and committed, moving
  `head`'s git ref forward with real new content. `brew upgrade`
  alone reported "already installed" without rebuilding -- a real
  finding, not the expected update path for a `--HEAD` formula.
  `brew reinstall` (the exact command Homebrew's own `--force` error
  message pointed at) correctly rebuilt from the new `head`, 5
  minutes, confirmed via `iderm --version` afterward. `brew uninstall`
  removed `iderm` cleanly -- confirmed via `brew list`, `which iderm`,
  and the Cellar/bin paths all reporting gone -- and also autoremoved
  13 now-unused build-time dependencies pulled in only for `iderm`,
  including the whole Rust toolchain (~2GB freed): real, expected
  Homebrew `autoremove` behavior, not a packaging bug. Two harmless
  warnings about leftover shared `openssl@3`/`ca-certificates` config
  files, unrelated to `iderm`'s own files. Record: `packaging/README.md`,
  Homebrew section.
- **AppImage real glibc portability bug, found and fixed 2026-08-23.**
  The 22 Aug AppImage, tested only on the build machine, failed on
  every separate box it reached: silently on Zorin (no visible error
  from a double-click launch), with a clear
  `GLIBC_2.39' not found` linker error on a real Debian 12 box. Root
  cause: dynamically linked against the build machine's own
  bleeding-edge glibc (2.42), too new for either target. Fixed by
  rebuilding statically against musl -- `ldd` confirms "not a dynamic
  executable", zero runtime dependency at all. Re-tested clean on the
  same Debian 12 box (`--version`, a real `scan --format=json`).
  Core's `packaging/appimage/build.sh` updated to build from the musl
  target permanently. Record: `packaging/README.md`, "AppImage: real
  glibc portability bug found and fixed" section.
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
  and `no-manual-page`. Both fixed the same day: a real
  `debian/changelog` in Core closed `no-changelog`; adding Core's
  existing `docs/man/iderm.1` to `cargo-deb`'s asset list (it was
  already used by the RPM spec, just never wired into DEB) closed
  `no-manual-page` -- `cargo-deb` auto-gzips it, confirmed real. Both
  `.deb`s rebuilt and re-linted after each fix; only the understood
  `embedded-library` finding remains. A first rebuild pass also
  leaked the build machine's real home directory path into the
  binary (`RUSTFLAGS`'s remap doesn't cover `tree-sitter`'s bundled C
  sources) -- caught with `strings` before shipping, fixed with
  `RUSTFLAGS`+`CFLAGS` together, independently re-verified clean.
  Record: `packaging/README.md`, "Lintian: done for real" section.
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

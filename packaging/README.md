# Packaging

Scaffolding, not a finished release pipeline. Every file here is a
real, structurally correct placeholder -- most has been run, some has
not. That distinction matters, see the table below.

## Two variants: with and without a bundled plugin set

Every package type (RPM, DEB, Homebrew) comes in two flavors:

- **Base** (`iderm`) -- the binary and docs only.
- **Bundled** (`iderm-plugins-bundled` / `--with-plugins`) -- adds a
  curated set of 6 example view plugins, installed as reference copies
  a user copies into their own project's `.iderm/views/` to activate --
  not auto-active, same "shipped but not auto-active" shape
  `.iderm/languages/*.toml` already uses. The full 17-plugin set lives
  in the separate `iderm-plugins` repository, which goes live at the
  same time as this release -- the bundle is convenience, not
  exclusivity.

The 6 chosen (`analog-capture`, `emc`, `distribution`, `deviation`,
`link-graph`, `risk-band`) are real, built, verified artifacts sitting
in `bundled-plugins/*.wasm` -- each one actually compiled via
`cargo component build --release` from `iderm-plugins` (commit
`fadba5a`) and confirmed to declare `iderm:plugin/view-provider@0.4.0`,
an exact match to Core's own `CORE_ABI_VERSION`. Not placeholders --
real components, already ABI-verified, just not yet installed through
a real package manager.

Real finding, fixed 2026-08-22: the original build embedded the real
local build-machine home directory path (Rust's compiler bakes the
source-tree path into panic-location strings by default) directly into
the compiled `.wasm` binaries -- confirmed via `strings` on the real
output, not assumed. Rebuilt all 6 with
`RUSTFLAGS="--remap-path-prefix=<real-path>=~"` set, confirmed clean
the same way, and confirmed the ABI version string is unchanged. Any
future rebuild of these bundled plugins needs the same flag, or the
same leak comes back.

## What exists

| File | Purpose | Status |
|---|---|---|
| `bundled-plugins/*.wasm` | The 6-plugin curated set | **Real, built, ABI-verified** -- not run through a package manager yet |
| `rpm/iderm.spec` | RPM build spec, base + `plugins-bundled` subpackage | **Verified for real, 2026-08-22** -- see below |
| `homebrew/iderm.rb` | Homebrew formula, base + `--with-plugins` option | `head`-only; no tagged release to build a real `url`/`sha256` against yet |
| `deny.toml` (Core's own repo, not this one) | `cargo deny` dependency/license/advisory config | **Verified for real, 2026-08-22** -- see below |
| `Cargo.toml`'s `[package.metadata.deb]` + `.variants.plugins-bundled` (Core's own repo, not this one) | `cargo deb` packaging metadata, base + bundled variant | **Verified for real, 2026-08-22** -- see below |
| `appimage/iderm.desktop`, `appimage/iderm.png`, `appimage/build.sh` | AppImage AppDir sources + build script | **Verified for real, 2026-08-22** -- see below |
| `../assets/idermlogo.svg` | The real project logo, source vector | Real artwork, one edit made (see below) -- a proper icon set from a real designer is still expected later |

## DEB: verified for real (2026-08-22)

Tested on real hardware, not assumed: `cargo deb` (base) and `cargo deb
--variant plugins-bundled` both installed and run for the first time on
the 2008-dual-Xeon Debian 12 box. Real findings, not hoped-for ones:

- Both `.deb`s build cleanly. `cargo-deb`'s `variants` feature works
  exactly as documented -- the earlier "unverified syntax" note is
  resolved.
- **The two DEB packages are not RPM-shaped.** The RPM spec's
  `plugins-bundled` subpackage is a true lean add-on (`Requires: iderm`,
  ships only the extra `.wasm` files). The DEB `plugins-bundled` variant
  is **self-contained** instead -- it re-includes the full `iderm`
  binary alongside the plugin files, so installing it alone needs no
  separate base package. Different shape, both valid, just genuinely
  different; don't assume they mirror each other.
- Package metadata (`dpkg-deb -I`) pulls correctly from `Cargo.toml`'s
  `description`/`homepage`, real `Depends: libc6 (>= 2.34)`.
- Extracted both packages exactly as `dpkg` would (`dpkg-deb -x`, no
  root available on that box from this session) and ran the real
  extracted binaries directly: both report `iderm 0.1.0` via
  `--version`, the bundled one's `usr/share/iderm/plugins/` holds all 6
  real `.wasm` files at the correct path.
- **Real `sudo dpkg -i` install done by the user directly on the box,
  same day.** `iderm --help` shows the full usage summary correctly.
  The TUI itself launched clean against a real, unrelated third-party
  project already on that machine (`rtl8812au`, a Realtek WiFi driver
  tree) -- Doctor correctly reported `[ok]` on git/build-manifest
  (Make)/README/LICENSE. This is the actual missing piece from the
  extraction-only pass above -- a genuine, complete, root-installed
  verification, not a workaround.
- `lintian` isn't installed on that box -- that specific quality check
  is still an open gap, not silently skipped, just not done yet.

Built `.deb`s copied back to `deb-build-output/` in this directory for
reference. Remote scratch state (`~/iderm-deb-test`, `/tmp/deb-extract-*`)
cleaned up afterward, nothing left on that box.

## RPM: verified for real (2026-08-22)

Tested on real hardware, not assumed: `rpmbuild -ba` against a clean P1 RHEL
box, no dev tools pre-installed. Real findings, not hoped-for ones:

- `BuildRequires: cargo, rust` checks the RPM database, and a
  `rustup`-installed toolchain (`~/.cargo/bin`) doesn't register there --
  the first build attempt correctly refused. `rpmbuild --nodeps` was tried
  and rejected as a fix: it skips *all* dependency checking, not just this
  one line, which is not an acceptable answer to hand real users. The
  correct fix is the distro-packaged toolchain (`dnf install rust cargo`)
  before building, not relaxing the check -- `BuildRequires` stays in the
  spec as written.
- rpmbuild's automatic debuginfo extraction doesn't cleanly apply to a
  Rust release binary the way it does a typical C/C++ build. Fixed with
  `%global debug_package %{nil}`.
- With both fixed and the distro toolchain installed, both RPMs (`iderm`
  base + `iderm-plugins-bundled`) build and install cleanly via
  `sudo rpm -i`.
- Real hardware/USB test passed on the same box, same trust-gate behavior
  as the macOS pass (see Homebrew section below).
- `rpmlint` wasn't installed on that box -- closed separately, same day,
  on this dev machine (Fedora): `rpmlint` was installable via `pip
  install --user` with no sudo needed at all, once `dnf`'s sudo path
  turned out to need an interactive terminal this session doesn't have.
  Rebuilt the RPMs locally with `rpmbuild -ba --nodeps` (this machine
  only has `rustup`'s toolchain too, same real gap `BuildRequires`
  correctly catches -- `--nodeps` used here only to get a local
  artifact to lint, not as build advice for real users; the actual
  verified build path stays the RHEL pass above). Two real findings
  from the first `rpmlint` run, both fixed:
  - `iderm.x86_64: W: unstripped-binary-or-object` -- `%global
    debug_package %{nil}` (the fix for Rust's debug-info format above)
    also skips rpmbuild's automatic stripping, not just debuginfo
    extraction. Fixed with an explicit `strip` in `%install`.
  - `iderm.x86_64: W: no-manual-page-for-binary` -- the project's real
    man page (`docs/man/iderm.1`) existed but was never installed by
    the spec. Added to `%install`/`%files`.
  - Also fixed, unrelated to `rpmlint` itself: two `%%{...}`-in-comments
    macro-expansion warnings from `rpmbuild` (needed `%%%%` escaping).
  - Remaining `rpmlint` output is either expected for an unsigned
    pre-release build (`no-signature`, `no-packager-tag`,
    `invalid-url Source0` -- no tagged release exists yet) or a
    `rpmlint`-config/dictionary mismatch, not a real spec bug
    (`no-buildroot-tag`/`no-group-tag` are obsolete Fedora conventions;
    `invalid-license MIT`/`Apache-2.0` is this `rpmlint` build's own
    license database being outdated, not the spec; `manpage-not-
    compressed bz2` wants bz2 specifically when the man page is
    correctly gzip-compressed, Fedora's own real convention; two
    `spelling-error` hits are the checker not knowing "pre-built"/"EMC").

## Homebrew: verified for real (2026-08-22)

Tested on real hardware, not assumed: `brew install --build-from-source
--HEAD` against a clean i9 MacBook Pro, no dev tools pre-installed. Real
finding: a bare `head "file:///path/to/source"` formula doesn't work as
documented here -- Homebrew's `--HEAD` install needs a real git repository
behind the tap, not a loose local directory. Working path, done by the
user directly: `brew tap-new <tap>/iderm`, a real `git init` + commit of
the source tree, formula's `head` pointed at that local repo's `file://`
path, then `brew install --build-from-source --HEAD <tap>/iderm/iderm`.
Result: `🍺 .../Cellar/iderm/HEAD: 9 files, 33.4MB, built in 5 minutes`,
confirmed working from a real self-scan of iderm's own repo (Doctor
`[ok]` on Cargo packaging metadata) and a real multi-pane workbench
session against live hardware capture data. The formula file itself is
correct; only the test instructions for a from-source `head` install were
wrong -- `HOMEBREW-TEST-README.md` still needs that section rewritten to
match the real procedure.

## AppImage: verified for real (2026-08-22)

Built and tested on this dev machine (Fedora, x86_64), not assumed:
`appimagetool` (downloaded from its GitHub releases, no distro package
needed) assembling a minimal AppDir (`usr/bin/iderm`, `iderm.desktop`,
`iderm.png`, `AppRun` symlinked straight to the binary -- no wrapper
script needed, nothing else to bundle for a single static-ish binary
with no bundled assets). `appimage/build.sh` automates the AppDir
assembly + `appimagetool` invocation.

- Chosen over Flatpak/Snap specifically for their sandboxing model, not
  effort: iderm's whole job is scanning arbitrary project directories
  and spawning arbitrary subprocesses (git, LSP servers, build tools,
  `$SHELL`, user-declared tasks) wherever it's pointed -- both formats
  confine exactly that by default, and getting broad exceptions through
  Flathub/Snap Store review is real, ongoing friction for a tool with
  no GUI story. AppImage has no sandboxing by default -- closest fit to
  the existing DEB/RPM/Homebrew "install a plain binary" shape.
- `iderm.desktop` sets `Terminal=true` -- required for a TUI app; a
  desktop launcher without it would try to run iderm windowless and
  show nothing.
- **`iderm.png` is the real logo now, not a generated placeholder**
  (2026-08-22) -- derived from `assets/idermlogo.svg`, the user's own
  provided artwork (the "iderm" wordmark + two tilted panel marks).
  One real edit made to it: the left panel's original hash-line
  pattern was replaced with a small heatmap-style grid (geometry
  computed to sit exactly flush with the existing skewed panel border,
  not eyeballed) so the two panels read as two real idermviz
  primitives -- heatmap and curve -- instead of one generic bar-chart
  gesture and one clean one. Reviewed and approved by the user before
  landing. Still explicitly a placeholder in the branding sense, not
  the geometry sense -- a proper icon set from a real designer is
  expected later; this is what ships until then.
- Real verification, not just a successful build: `--version` and
  `--help` both correct through the assembled AppImage's own
  extraction/execution path. `scan --format=json` and `doctor --json`
  both produce valid, correctly-schema-versioned output against a real
  project (this repo itself). A live interactive TUI session (tmux,
  120x40) rendered the real project tree, toggled the Build panel, and
  showed real Doctor findings (`[ok]` across the board) -- exited
  cleanly via the app's own two-`q` panel-close-then-quit behavior, no
  garbled terminal state left behind.
- `appimagetool` warned about missing AppStream metadata (optional,
  only matters for an AppImageHub submission) and a two-category
  `.desktop` hint (cosmetic) -- both non-fatal, noted not fixed.
- **No bundled-plugins variant yet** -- unlike RPM/DEB/Homebrew, this
  AppImage is base-only so far. The same 6-plugin bundle could be added
  to the AppDir the same way DEB's self-contained variant works, just
  not done in this pass.

## `cargo deny`: verified for real (2026-08-22)

`cargo-deny` installed and `cargo deny check` run for real against the
full dependency tree (~390 crates). Real findings, not hoped-for ones:

- **`nvim-rs` (embedded-Neovim RPC client, core to the `Enter` action)
  is LGPL-3.0** -- the one substantive finding, not a config nit. Every
  other dependency in the tree is MIT/Apache/BSD/ISC/Unicode-3.0/Zlib.
  Confirmed against the crate's own `Cargo.toml` and README (not
  guessed): it's a fork of an LGPL-3.0 project, dual-licensed
  Apache/MIT "to allow the possibility of relicensing this project
  later" -- a stated future intent, not current status. No newer
  version exists to check (`0.9.2` is latest). **Accepted as a
  documented exception**: `nvim-rs`'s source is already public, Core's
  own source is intended to become public, and a standard Cargo
  rebuild against a modified `nvim-rs` satisfies the relink provision
  LGPL-3.0 requires for a statically-linked binary. Added to
  `deny.toml`'s allow-list with the reasoning inline; same note in
  `docs/manual/10_License.md` Clause 10.4. Not a legal conclusion --
  stated as such in both places.
- `tokio-io` (transitive, via `futures-util` -> `futures` ->
  `nvim-rs`/`wasmtime`) has an "unmaintained" advisory
  (`RUSTSEC-2026-0058`), no vulnerability. Already reviewed as
  informational during the 2026-08-10 macOS security review; added an
  explicit `[[advisories.ignore]]` entry so the check reflects that
  review instead of failing silently-unacknowledged forever.
- Remaining output is non-blocking: several expected duplicate-crate-
  version warnings from `wasmtime`'s own dependency tree (`bans`
  policy is already `warn`, not `deny`), and one unused allow-list
  entry (`ISC` -- nothing in the current tree uses it, harmless to
  keep for whatever adds it next).
- **Result: `advisories ok, bans ok, licenses ok, sources ok`, exit 0.**

## What's still missing before any of this is real

- RPM/DEB package **signing** -- real GPG key generated 2026-08-22 (RSA
  4096, sign-only), public key + scripts + honest status in
  `signing/`. Actual signing blocked on tooling, not the key: `rpm-sign`
  needs real root this session doesn't have on this machine; `dpkg-sig`
  isn't packaged for Fedora at all, needs a real Debian/Ubuntu box.
- macOS code signing + notarization -- deliberately deferred until real
  demand justifies the Apple Developer reactivation, same as the manual's
  own collaboration-condition wording.
- SHA-256 checksums + a release manifest for whatever gets actually
  published.
- A real tagged release to build the Homebrew formula's `url`/`sha256`
  against -- `head` install only works from a live git checkout, not a
  distributable artifact.
- `lintian` run against the real `.deb`s -- `rpmlint` is now done (see
  above); `lintian` genuinely could not be run this session, three real
  attempts, not one skipped: no Fedora package for this Debian/Ubuntu-
  specific tool; this session's `podman` couldn't initialize its OCI
  backend to run it in a Debian container; and the real 2008 dual-Xeon
  Debian 12 box (the same one DEB itself was verified on) has no root
  access available at all -- `sudo` there returns "a password is
  required" with no way to supply one this session. Needs either root
  on that box or a different Debian/Ubuntu machine with one.
- AppImage's bundled-plugins variant (see above).
- A final icon set from a real designer -- the current icon is the
  user's real logo (see above), not a generated placeholder anymore,
  but a proper multi-size icon set is still expected later.
- AppImage tested only on this dev machine so far -- not yet run on a
  separate, clean box the way DEB/RPM/Homebrew each were.

## How to apply

Don't treat any file in this directory as verified until it's actually
been run against a real build on a real machine and the output has been
checked, not just generated. `bundled-plugins/*.wasm`, the DEB, RPM,
Homebrew, and AppImage pipelines, and `cargo-deny` are all now
genuinely verified this way -- everything in the "still missing" list
above is what's left.

# iderm release manifest

Generated 2026-08-23T13:19:25Z from real local build artifacts.
Verify with: `sha256sum -c SHA256SUMS` from this directory, artifacts
copied alongside it.

| File | SHA-256 | Size |
|---|---|---|
| `iderm_0.1.0-1_amd64.deb` | `b71cd29b4ea4ef0cb3ff915876cb37934e9b2af474dfd41854a36e78af26faad` | 5.7M |
| `iderm-plugins-bundled_0.1.0-1_amd64.deb` | `f6928f1726f610846b35cfd9d63c5b7f2a0aad9d3a3a9b52436191ef9498c21e` | 5.9M |
| `iderm-0.1.0-1.fc43.x86_64.rpm` | `15267cb98de4a0452cd13b560f6012aaf834bdbe06f1049a6eda74ae9df94f8d` | 5.9M |
| `iderm-plugins-bundled-0.1.0-1.fc43.noarch.rpm` | `f2488a28f4b27e7dc210efd6c45d82a58da95787328f03de31bf1712f57ac3d5` | 148K |
| `iderm-x86_64.AppImage` | `4d6f4b230965baf2e53bea8be4828f293115c1c216430c65f006322b14cba941` | 9.3M |

`SHA256SUMS.asc` (same directory) is a detached GPG signature over
`SHA256SUMS`, key fingerprint `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`.
It covers all five artifacts here, including both `.deb` files -- this
closes part of the DEB integrity gap on its own, since `apt`/`dpkg`
never check a standalone `.deb`'s own signature. These are today's real
local build artifacts, not a tagged release; regenerate this manifest
whenever something real ships.

The two `.deb` hashes above reflect the 2026-08-23 rebuild that added
`debian/changelog` (fixing `lintian`'s `no-changelog` finding),
`docs/man/iderm.1` as a packaged asset (fixing `no-manual-page`), and
`RUSTFLAGS`/`CFLAGS` path-remapping (an earlier plain rebuild's binary
leaked the real build machine's home directory path via Rust
panic-location strings and `tree-sitter`'s bundled C sources -- caught
by `strings` before it ever left the build box, fixed, rebuilt clean,
independently re-verified on a second machine). If you built these
packages before that date, your local hashes won't match; rebuild with
`cargo deb` to get a package matching this manifest.

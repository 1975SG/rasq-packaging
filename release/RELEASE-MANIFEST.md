# iderm release manifest

Generated 2026-08-23T17:37:09Z from real local build artifacts.
Verify with: `sha256sum -c SHA256SUMS` from this directory, artifacts
copied alongside it.

| File | SHA-256 | Size |
|---|---|---|
| `iderm_0.1.0-1_amd64.deb` | `b71cd29b4ea4ef0cb3ff915876cb37934e9b2af474dfd41854a36e78af26faad` | 5.7M |
| `iderm-plugins-bundled_0.1.0-1_amd64.deb` | `f6928f1726f610846b35cfd9d63c5b7f2a0aad9d3a3a9b52436191ef9498c21e` | 5.9M |
| `iderm-0.1.0-1.fc43.x86_64.rpm` | `15267cb98de4a0452cd13b560f6012aaf834bdbe06f1049a6eda74ae9df94f8d` | 5.9M |
| `iderm-plugins-bundled-0.1.0-1.fc43.noarch.rpm` | `f2488a28f4b27e7dc210efd6c45d82a58da95787328f03de31bf1712f57ac3d5` | 148K |
| `iderm-x86_64.AppImage` | `97d1fa2c57e7927a7e7a0ade874cd1d89157cc59497fd281ee9bff766db3df95` | 10M |

**RPM entries above are stale (`0.1.0-1`).** The real, verified
`0.1.0-3` RPMs (from the update+removal testing and the
leftover-directory fix, both 23 Aug) were built and tested live on
the RHEL box and never copied back to this machine's
`packaging/rpm-build-output/` -- that box wasn't reachable when this
manifest was regenerated. Sync those back and regenerate before
treating the RPM checksums here as current.

`SHA256SUMS.asc` (same directory) is a detached GPG signature over
`SHA256SUMS`, key fingerprint `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`.
These are today's real local build artifacts, not a tagged release;
regenerate this manifest whenever something real ships.

The AppImage hash above reflects a real fix, 23 Aug: the previous
build linked dynamically against this machine's glibc (2.42), which
failed with a clear `GLIBC_2.39 not found` error on a real Debian 12
box and silently did nothing on Zorin (no visible terminal to show
the same error). Rebuilt statically against musl
(`x86_64-unknown-linux-musl`, `musl-gcc`) -- confirmed `not a dynamic
executable`, zero runtime glibc dependency, real-tested working
(`--version` and a real `scan --format=json`) on the same Debian 12
box that rejected the old build.

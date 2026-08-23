# iderm release manifest

Generated 2026-08-23T18:04:38Z from real local build artifacts.
Verify with: `sha256sum -c SHA256SUMS` from this directory, artifacts
copied alongside it.

| File | SHA-256 | Size |
|---|---|---|
| `iderm_0.1.0-1_amd64.deb` | `b71cd29b4ea4ef0cb3ff915876cb37934e9b2af474dfd41854a36e78af26faad` | 5.7M |
| `iderm-plugins-bundled_0.1.0-1_amd64.deb` | `f6928f1726f610846b35cfd9d63c5b7f2a0aad9d3a3a9b52436191ef9498c21e` | 5.9M |
| `iderm-0.1.0-3.el10.x86_64.rpm` | `c1d8327c06defa5c524de726c51726daa3fcfdafa624420e78c91a5e2bed5c50` | 6.3M |
| `iderm-plugins-bundled-0.1.0-3.el10.noarch.rpm` | `0a5c4ac3e20cf52cf2c1c18637efd82b7bb478a7fd8615493d3d87e50708010c` | 148K |
| `iderm-x86_64.AppImage` | `97d1fa2c57e7927a7e7a0ade874cd1d89157cc59497fd281ee9bff766db3df95` | 10M |

`SHA256SUMS.asc` (same directory) is a detached GPG signature over
`SHA256SUMS`, key fingerprint `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`.
These are today's real local build artifacts, not a tagged release;
regenerate this manifest whenever something real ships.

**RPM entries now reflect the real, current build.** The `0.1.0-3`
RPMs (from the update+removal testing and the leftover-directory fix,
23 Aug) were built on the real RHEL box and, on first copy-back,
turned out to leak that box's own home directory path (672 instances,
`RUSTFLAGS`/`CFLAGS` remap wasn't applied to that build) -- rebuilt
clean with the remap applied, re-verified zero leaks, copied back for
real this time. `signing/generate-manifest.sh`'s artifact list updated
to the real current filenames (`.el10`, not the stale `.fc43` 0.1.0-1
names).

The AppImage hash reflects a separate real fix, also 23 Aug: the
previous build linked dynamically against this machine's glibc
(2.42), which failed with a clear `GLIBC_2.39 not found` error on a
real Debian 12 box and silently did nothing on Zorin (no visible
terminal to show the same error). Rebuilt statically against musl --
confirmed `not a dynamic executable`, zero runtime dependency,
real-tested working (`--version` and a real `scan --format=json`) on
Debian 12, and confirmed rendering correctly on the real Zorin box
that originally reported the failure.

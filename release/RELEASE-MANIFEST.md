# iderm release manifest

Generated 2026-08-23T20:34:40Z from real local build artifacts.
Verify with: `sha256sum -c SHA256SUMS` from this directory, artifacts
copied alongside it.

| File | SHA-256 | Size |
|---|---|---|
| `iderm_0.1.0-1_amd64.deb` | `b71cd29b4ea4ef0cb3ff915876cb37934e9b2af474dfd41854a36e78af26faad` | 5.7M |
| `iderm-plugins-bundled_0.1.0-1_amd64.deb` | `f6928f1726f610846b35cfd9d63c5b7f2a0aad9d3a3a9b52436191ef9498c21e` | 5.9M |
| `iderm-0.1.0-3.el10.x86_64.rpm` | `6febee5c7100c70457c58080bc4fa1e336fff237928ab8504c3190b08d4a2611` | 6.3M |
| `iderm-plugins-bundled-0.1.0-3.el10.noarch.rpm` | `68e051a2fa9aad8151e4e96dc7bef680f948bdfc90d97bd32dfe0de312acee58` | 148K |
| `iderm-x86_64.AppImage` | `97d1fa2c57e7927a7e7a0ade874cd1d89157cc59497fd281ee9bff766db3df95` | 10M |

`SHA256SUMS.asc` (same directory) is a detached GPG signature over
`SHA256SUMS`, key fingerprint `20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203`.
These are today's real local build artifacts, not a tagged release
snapshot -- also uploaded as-is to the real `v0.1.0` GitHub Release.

**Both RPMs are now individually GPG-signed too**, 23 Aug --
`rpm --addsign` applied after the `v0.1.0` release had already
shipped them unsigned; `rpm -Kv` confirms a real
`OpenPGP V4 RSA/SHA512 signature: OK` on both, same key. Signing
changes the file bytes, so both hashes above are the post-signing
ones -- the release assets were re-uploaded to match. `dnf`/`rpm`
itself now checks this signature on install, not just
`SHA256SUMS.asc`'s file-level integrity check.

The AppImage is statically linked against musl -- `ldd` reports "not
a dynamic executable", zero runtime dependency, real-tested working
on both a Debian 12 box and Zorin OS after the earlier glibc-linked
build failed on both.

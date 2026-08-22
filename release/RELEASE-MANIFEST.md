# iderm release manifest

Generated 2026-08-22T18:39:13Z from real local build artifacts.
Verify with: `sha256sum -c SHA256SUMS` from this directory, artifacts
copied alongside it. `SHA256SUMS.asc` is a real, verified detached GPG
signature over `SHA256SUMS` -- `gpg --verify SHA256SUMS.asc SHA256SUMS`
-- one signature covering all five artifacts, including the DEBs
(closes the practical gap RPM signing alone doesn't: `apt`/`dpkg` don't
check per-file signatures, but a signed checksum manifest is real,
checkable proof regardless of package format).

These are today's local build artifacts, not a tagged release --
regenerate this manifest for whatever actually ships, don't reuse
these hashes for a different build.

| File | SHA-256 | Size |
|---|---|---|
| `iderm_0.1.0-1_amd64.deb` | `4a1098c4af0dd6272055dd5e4ffe178fba768dfc0109ff78fd2b8abb4ff4ef18` | 5.7M |
| `iderm-plugins-bundled_0.1.0-1_amd64.deb` | `aaf9aeb5f3735bc3ef3c635fe078254be21bb1c071cfc215be712c8548590dd3` | 5.9M |
| `iderm-0.1.0-1.fc43.x86_64.rpm` | `15267cb98de4a0452cd13b560f6012aaf834bdbe06f1049a6eda74ae9df94f8d` | 5.9M |
| `iderm-plugins-bundled-0.1.0-1.fc43.noarch.rpm` | `f2488a28f4b27e7dc210efd6c45d82a58da95787328f03de31bf1712f57ac3d5` | 148K |
| `iderm-x86_64.AppImage` | `4d6f4b230965baf2e53bea8be4828f293115c1c216430c65f006322b14cba941` | 9.3M |

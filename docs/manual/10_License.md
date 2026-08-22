# 10. License

| Field | Value |
|---|---|
| Document type | User manual, Clause 10 |
| Part of | [Index](index.md) |

## 10.1 Core license

IDERM Core is offered under either license, at the licensee's option:

| License | SPDX identifier | Text |
|---|---|---|
| MIT License | `MIT` | `LICENSE-MIT` |
| Apache License, Version 2.0 | `Apache-2.0` | `LICENSE-APACHE` |

SPDX expression:

```text
MIT OR Apache-2.0
```

## 10.2 Copyright

Copyright (c) 2026 Sinan Gözel.

## 10.3 Plugins

A plugin is distributed as a separate WASM component. It may use different
license terms. The user shall inspect the plugin's license before copying,
distributing, or modifying it. Loading a plugin does not replace the Core
license text.

## 10.4 Dependencies

Third-party dependencies retain their own terms. Generate a report for the
exact resolved dependency set used by a release. For example:

```sh
cargo install cargo-license
cargo license
```

The command is an operator aid. Its output shall be reviewed before release.

One dependency, `nvim-rs` (the embedded-Neovim RPC client Clause 2.3's editor
handover uses), is licensed LGPL-3.0, a documented exception to an otherwise
MIT/Apache/BSD/ISC/Unicode-3.0/Zlib dependency set (see `deny.toml`). This is
accepted on the basis that `nvim-rs`'s own source is already public, IDERM
Core's own source is intended to become public, and a standard Cargo rebuild
against a modified `nvim-rs` satisfies the relink provision LGPL-3.0 requires
for a statically-linked binary. Clause 10.5 applies to this determination the
same as any other.

## 10.5 No legal interpretation

This clause identifies project license files. It is not legal advice and does
not determine obligations for a specific distribution or combined work.

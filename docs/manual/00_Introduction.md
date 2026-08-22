# 0. Introduction

| Field | Value |
|---|---|
| Document type | User manual, Clause 0 |
| Part of | [Index](index.md) |

## 0.1 Purpose

This manual specifies installation, operation, configuration, safety
boundaries, and removal of IDERM 0.1.0.

## 0.2 Product description

IDERM means Integrated Development, Engineering and Research Manager. It is a
terminal-first, project-aware development environment. It provides:

- project scanning;
- read-only Doctor findings;
- project tree navigation;
- terminal handover to Neovim and the shell;
- Git, build, task, outline, preview, and inspector panels;
- project-local WASM plugins and workbenches;
- headless JSON, graph, and Run Ledger commands; and
- an optional external AI command adapter.

Core is a Rust application using `ratatui` and `crossterm`. The terminal uses
an alternate screen and full-screen redraw.

## 0.3 Intended user

The intended user has shell access to the target project and understands the
project's build tools. Plugin development requires Rust, WIT, WASM component,
and `cargo-component` knowledge.

## 0.4 Base operating loop

```text
scan project -> run Doctor -> open workspace
```

The base loop shall operate without project configuration, plugins, an editor,
an LSP server, or network access.

## 0.5 Related documents

| Subject | Document |
|---|---|
| First installation and first session | [Quick start guide](../QSG.md) |
| Architecture, module detail | [Architecture, compacted](../reference/Architecture_Compact.md) |
| Current design decisions | [Decisions, compacted](../reference/Decisions_Compact.md) |
| Workbench use | [Plugin/workbench guides, compacted](../reference/Plugin_Guides_And_Misc_Compact.md) |

Each compacted document above is an index, not the full prose original --
Core's full-detail docs live in Core's own repository.

## 0.6 Manual limits

This manual does not certify fitness for a regulated purpose. Verification
records are stated in Clause 7. Security controls and residual risks are stated
in Clause 11. Product features that are explicitly not planned are stated in
Clause 12.

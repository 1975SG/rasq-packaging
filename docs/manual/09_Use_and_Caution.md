# 9. Use, limitations, and cautions

| Field | Value |
|---|---|
| Document type | User manual, Clause 9 |
| Part of | [Index](index.md) |

## 9.1 Version condition

IDERM 0.1.0 is pre-1.0 software. Implemented features have project verification
evidence. Long-term support, stable packaging, and formal certification are not
claimed. Sustained external collaboration and demonstrated demand may justify a
maintainer commitment to long-term support for a future stable release; no such
commitment currently exists.

## 9.2 Optional dependency behavior

| Missing item | Effect |
|---|---|
| Neovim | File-open action fails; other functions remain available |
| LSP server | Handshake reports failure; other functions remain available |
| Git | Git panel has no usable status output |
| Build or task tool | The selected task fails to start or returns failure |
| Plugin | Related findings or workbench are absent |
| `.iderm` file | Related optional extension is absent |

## 9.3 Project execution caution

`x`, `s`, `Enter`, `l`, and `iderm ai` can start native programs. Native
programs are not confined by the plugin sandbox. The user shall inspect a
project before running its tasks or configured tools.

## 9.4 Repair caution

Interactive Repair requires confirmation. `iderm ai repair --apply` is already
an explicit apply instruction and does not provide the TUI prompt. Both paths
retain the new-file and project-root checks.

The current repair model cannot modify an existing file. A proposal that names
an existing path is rejected.

## 9.5 AI caution

The AI adapter starts the configured external command and sends project scan
and Doctor state to its standard input. `ai test` also sends test output. Core
applies a wall-clock deadline to that command, 120 s for repair and explain,
600 s for test, and an 8 MiB per-stream output cap. A command that exceeds
either limit is terminated.

The user shall review external-command terms, endpoint, credential handling,
and data retention before use with confidential material.

## 9.6 Visualization caution

A rendered graph or chart reflects plugin output and Core rendering logic. It
does not establish measurement accuracy. Verify source data, units, scaling,
limits, missing samples, and instrument calibration independently.

Only XY charts have figure export. TikZ output escapes common metacharacters
and selected engineering symbols. The user shall compile and inspect exported
material before publication.

## 9.7 Configuration caution

Malformed optional configuration may degrade to no extension instead of a
fatal error. If a task, language, or plugin is unexpectedly absent, validate
the related TOML file first.

`.iderm/run-ledger.jsonl`, `.iderm/exports/`, continuous-task logs, and capture
files may contain project or measurement information. Apply project retention
and access controls.

## 9.8 Environment caveats

| Condition | Response |
|---|---|
| Function key intercepted by the OS | Use the documented Ctrl alternative |
| No interactive terminal | Use a headless command or start IDERM in a terminal |
| Old GNU/Linux runtime | Build from source on the target host |
| `tmux capture-pane` failure on a recorded RHEL build | Consult the dated platform report; use a different capture method |

## 9.9 Reporting defects

A defect report should include product version, operating system, architecture,
command, project configuration needed to reproduce, expected result, actual
result, and sanitized logs. Secrets and proprietary project data shall be
removed before submission.

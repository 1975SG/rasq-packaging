# 3. Doctor and Repair

| Field | Value |
|---|---|
| Document type | User manual, Clause 3 |
| Part of | [Index](index.md) |

## 3.1 Doctor function

Doctor evaluates project state and returns findings. Built-in checks do not
write files or start network access. Doctor runs during TUI startup and during
`iderm doctor --json`.

## 3.2 Severity

| Display | JSON value | Meaning |
|---|---|---|
| `[ok]` | `info` | Information |
| `[!!]` | `warning` | Review required |
| `[xx]` | `error` | Error reported by a plugin |

Current built-in checks produce information and warnings. Plugins may produce
all three severities.

## 3.3 Built-in checks

Doctor performs six check groups:

1. Git repository presence.
2. Build manifest presence and coexistence.
3. README presence.
4. license-file presence.
5. `compile_commands.json` presence and parse result, when a candidate exists.
6. package version and license metadata for Rust, Python, and npm manifests.

License checking confirms file presence only. It does not identify or validate
the license. Packaging checks skip ecosystems without a standard field and
skip unreadable or unparseable manifests.

## 3.4 Plugin findings

Doctor rules load from `.iderm/plugins/*.wasm`, subject to the optional
allowlist. A plugin failure becomes one named error finding. Other rules still
run. Plugin log messages become information findings with a `[log]` prefix.

## 3.5 Repair function

Repair proposals may originate from Core, a repair plugin, or the AI adapter.
The TUI sequence is:

1. Open Repair with `r`.
2. Review the proposed path, description, and diff.
3. Press `y` to apply, `n` to skip, or `Esc` to cancel.

Repair plugin and AI proposals may create new files only. Existing files are
rejected. The parent directory shall already exist. The resolved path shall
remain under the canonical project root. A path traversal or symlink escape is
rejected.

`iderm ai repair --apply` is an explicit headless apply request. It does not
show the interactive TUI confirmation screen. The same new-file and path
validation is applied.

![Doctor findings mixing built-in checks with two plugin rule IDs, `[example-invariant-checker]` and `[example-gitignore-present]`, across all three severities](screenshots/04-doctor-findings.png)

![Repair dry-run diff proposing a new `.gitignore` file, with the `[Y]` confirmation prompt visible](screenshots/05-repair-diff.png)

## 3.6 Residual risk

Doctor findings are advisory. A passing result is not proof of project
correctness, security, license compliance, or hardware safety.

# 11. Security

| Field | Value |
|---|---|
| Document type | User manual, Clause 11 |
| Part of | [Index](index.md) |
| Verified against | Source tree, 2026-08-16 |

## 11.1 Security objective

The base scan and Doctor path shall remain local and read-only. Project plugins
shall receive only explicit host capabilities. Project-native tools shall be
treated as user-authorized code execution.

## 11.2 Trust zones

| Zone | Examples | Boundary |
|---|---|---|
| Core process | scanner, Doctor, renderer, Repair validator | Native process with user permissions |
| WASM plugin | Doctor rule, repair recipe, view provider | Wasmtime component store |
| Native child | task, shell, Neovim, Git, LSP, AI command | Operating-system process with user permissions |
| Project data | source, config, capture, ledger, logs | Filesystem permissions and project root |
| External service | AI endpoint or network instrument used by a child | External command and service policy |

## 11.3 Plugin containment

The plugin WASI context has no preopened directories, environment variables,
arguments, or network capability. The WIT host interface exposes:

- `read-file`;
- `list-files`; and
- `log`.

Read paths are canonicalized. A resolved path outside the canonical project
root is rejected. Globs shall be relative and shall not contain a parent
component. Matches that resolve through a symlink outside the root are omitted.

Plugin calls use a 256 MiB linear-memory limit and a nominal 2 s epoch budget.
A trap, timeout, ABI error, or load error is surfaced as an error. Resource
limits reduce impact. They do not prove a plugin is benign.

## 11.4 Network behavior

Core performs no telemetry and no automatic update check. Startup, scan,
Doctor, Repair proposal generation, rendering, and ledger reads require no
network access.

A native child may use the network. Relevant examples are an LSP server, a
project task, a capture bridge, and the command configured in `.iderm/ai.toml`.
Core does not inspect or restrict a native child's network behavior.

## 11.5 Native process execution

Subprocesses are started with a program and argv array. Core does not construct
a shell command string for normal task execution. A project can still declare
`sh`, `bash`, or another interpreter as the program. In that case the script or
argument has shell semantics.

Opening an untrusted repository does not by itself run tasks. However,
project-local Doctor and view plugins are discovered and may execute during
scan or view initialization. The user should inspect `.iderm/` before opening
an untrusted project in the TUI.

A declared task from `.iderm/tasks.toml`, an auto-discovered `stream_*.py`
or `.sh` script, or the `tasks`/`lsp_binary` of a project-local
`.iderm/languages/*.toml` language manifest requires trust approval before it
runs. Trust is pinned to that file's exact content by hash and stored outside
the project. Editing the file after approval invalidates the prior trust.
`iderm trust <path>` establishes trust ahead of a scripted or CI run. A task
or LSP handshake whose program comes from a bundled or default language
manifest is not gated; the program name in that case is fixed by Core, not
read from the project.

## 11.6 Repair writes

A repair plugin or AI proposal may create a new file only. Core canonicalizes
the existing parent directory, verifies that it is under the project root,
and rejects an existing destination. Interactive Repair requires affirmative
confirmation. Headless `--apply` is itself the affirmative instruction.

These checks do not validate the semantic safety of new file content. A new
build file, task file, or source file can affect later native execution.

## 11.7 AI and confidential data

`.iderm/ai.toml` selects an external command. Core sends project and Doctor
JSON. `ai test` also sends subprocess output. The external command determines
whether data remains local or reaches a service.

The command requires trust approval before it runs, the same gate `.iderm/
tasks.toml` uses. Interactive use prompts on first run and after any later
edit to `ai.toml`. Headless use fails closed with no terminal to prompt on;
`iderm trust <path>` establishes trust in advance.

Core applies a wall-clock deadline to the command, 120 s for repair and
explain, 600 s for test, and an 8 MiB per-stream output cap. A command that
exceeds either limit is terminated.

Secrets shall not be stored in committed `ai.toml` arguments. Use the external
command's credential store or environment. Review provider retention and
training terms before sending protected data.

## 11.8 Generated and retained data

| Data | Location | Security consideration |
|---|---|---|
| Run Ledger | `.iderm/run-ledger.jsonl` | Contains paths, manifests, platform, notes |
| Figure export | `.iderm/exports/` | Contains plugin-rendered labels and values |
| Continuous-task log | `logs/<task-slug>/` | Contains child stdout and stderr |
| Capture files | Project-defined | May contain measurements or identifiers |

Access, retention, backup, and deletion follow filesystem and project policy.
Core does not encrypt these files.

## 11.9 Export handling

SVG text is XML-escaped. TikZ labels escape common LaTeX metacharacters.
Export remains generated source. The user shall inspect it before opening it in
a browser, importing it into another application, or compiling LaTeX.

## 11.10 Residual risks

Known residual risks include:

- native child processes have the user's operating-system permissions;
- malformed optional configuration may be skipped silently;
- plugin resource limits are containment controls, not formal isolation proof;
- Core itself is not sandboxed;
- project files may change between validation and later external use; and
- terminal, editor, compiler, renderer, and dependency vulnerabilities remain
  outside the application-specific controls.

## 11.11 Recommended procedure for an untrusted project

1. Run `iderm scan --format=json <path>` first.
2. Inspect `.iderm/plugin.toml` and all `.iderm` executable components.
3. Inspect `.iderm/tasks.toml` and root `stream_*.py` or `.sh` files.
4. Inspect build manifests and editor or LSP configuration.
5. Disable or remove unapproved project plugins.
6. Do not run `x`, `s`, `Enter`, `l`, or `iderm ai` until approved.
7. Use an operating-system sandbox when stronger isolation is required.

## 11.12 Vulnerability handling

See `SECURITY.md` at the project root for the supported-version statement,
reporting channel, response process, and scope.

# 13. Frequently asked questions

| Field | Value |
|---|---|
| Document type | User manual, Clause 13 |
| Part of | [Index](index.md) |

## 13.1 What is IDERM?

IDERM is a terminal-first, project-aware IDE. It scans a project, runs
Doctor checks, and opens a terminal workspace. See [Introduction](00_Introduction.md).

## 13.2 Does IDERM require an account, cloud service, or license key?

No. Startup, scan, Doctor, Repair proposal generation, rendering, and ledger
reads require no network access. See [Security](11_Security.md), clause 11.4.

## 13.3 Does IDERM send my project to a network service?

Not by default. A native child process that the user explicitly starts, for
example a language server, a project task, or the command configured in
`.iderm/ai.toml`, may use the network. Core does not inspect or restrict a
native child's network behavior. See [Security](11_Security.md), clause 11.4.

## 13.4 Which languages does IDERM detect by default?

Rust, Go, TypeScript or JavaScript, Python, CMake, and Make. First-party
manifests for LaTeX, TLA+, Promela, Murphi, and Fortran are available but not
active by default. See [Configuration and plugins](04_Plugins.md).

## 13.5 Can I add a language IDERM does not detect by default?

Yes. Copy a first-party manifest into `.iderm/languages/`, or write a
project-local manifest following the documented shape. A malformed
project-local manifest is skipped, not fatal to the scan. See
[Configuration and plugins](04_Plugins.md).

## 13.6 Does IDERM modify my files automatically?

No. Repair proposes a change and requires affirmative confirmation before
writing. `iderm ai repair --apply` is itself the affirmative instruction and
therefore does not show the interactive confirmation. The current Repair
model can only create a new file. It cannot modify an existing file. See
[Doctor and Repair](03_Doctor.md).

## 13.7 What should I do before opening a project I do not trust?

Follow the recommended procedure in clause 11.11 of [Security](11_Security.md):
inspect `.iderm/plugin.toml` and its listed components, inspect
`.iderm/tasks.toml` and root `stream_*` files, inspect build manifests, and
disable or remove unapproved plugins before running project tasks or the AI
adapter.

## 13.8 Can a plugin read files outside my project?

No. A plugin has no preopened directory, environment variable, argument, or
network capability. `read-file` and `list-files` are restricted to the
canonical project root. A path that escapes the root, including through a
symlink, is rejected. See [Security](11_Security.md), clause 11.3.

## 13.9 Does the AI adapter require a specific provider?

No. `.iderm/ai.toml` names any external command already configured or
authenticated by the user. Core sends project and Doctor state as JSON to
that command's standard input and reads its standard output. See
[Configuration and plugins](04_Plugins.md).

## 13.10 Why did `iderm ai test` refuse to run?

`ai test` selects the one derived task whose label contains `test`. If more
than one task matches, it refuses and names every candidate instead of
guessing which one to run. Rename the tasks so only one matches, or declare a
single dedicated task.

## 13.11 What happens if Neovim, Git, or a language server is not installed?

The related function is unavailable. Other functions remain available. See
[Use, limitations, and cautions](09_Use_and_Caution.md), clause 9.2.

## 13.12 Is IDERM stable enough for production use?

IDERM 0.1.0 is pre-1.0 software. Implemented features have project
verification evidence. Long-term support, stable packaging, and formal
certification are not claimed. Sustained external collaboration and
demonstrated demand may justify a maintainer commitment to long-term support
for a future stable release; no such commitment currently exists. See
[Use, limitations, and cautions](09_Use_and_Caution.md), clause 9.1.

## 13.13 How do I report a bug?

Follow clause 9.9 of [Use, limitations, and cautions](09_Use_and_Caution.md).
Include product version, operating system, architecture, command, project
configuration needed to reproduce, expected result, actual result, and
sanitized logs.

## 13.14 How do I report a security vulnerability?

Do not open a public issue. Follow `SECURITY.md` at the project root.

## 13.15 What is IDERM's license?

IDERM Core is offered under the MIT License or the Apache License, Version
2.0, at the licensee's option. See [License](10_License.md).

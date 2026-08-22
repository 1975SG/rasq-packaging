# 1. Installation

| Field | Value |
|---|---|
| Document type | User manual, Clause 1 |
| Part of | [Index](index.md) |
| Detailed procedure | [Quick start guide](../QSG.md) |

## 1.1 Supported installation state

Build from source is the verified installation method. RPM, DNF repository,
and Homebrew distribution are not published at the date of this manual.

## 1.2 Requirements

| Item | Requirement |
|---|---|
| Operating system | Linux or macOS |
| Architecture | `x86_64` or `aarch64` |
| Rust | 1.85 or later |
| C toolchain | `gcc` or `clang` |
| Terminal | Interactive terminal; 24-bit color recommended |
| Git | Required to clone; optional during normal operation |
| Neovim | Optional; required for `Enter` editor action |
| LSP server | Optional; required for `l` handshake action |

Windows is not a supported operating system per the table above, and no
Windows build has been tested. Two distinct cases apply. Under WSL2, the
running system is a genuine Linux kernel and userspace; a standard Linux
build is expected to function there without modification, but this has
not been verified. Native Windows (a Windows terminal without WSL) is an
open question, not attempted: shell handover (Clause 2.3's `s` action)
reads the `$SHELL` environment variable, which does not exist on native
Windows; the embedded Neovim instance's `--listen` socket is a named pipe
on native Windows rather than a Unix domain socket; and no native Windows
package exists.

## 1.3 Package placeholders

The following identifiers are placeholders. They shall not be interpreted as
published endpoints.

```sh
# RPM / DNF PLACEHOLDER
sudo dnf config-manager addrepo --from-repofile=<IDERM-RPM-REPOSITORY-URL>
sudo dnf install <IDERM-PACKAGE-NAME>

# HOMEBREW PLACEHOLDER
brew tap <OWNER>/<TAP>
brew install <FORMULA>
```

## 1.4 Source installation

```sh
git clone <IDERM-SOURCE-REPOSITORY-URL>
cd iderm
cargo build --release
./target/release/iderm --help
```

The build produces one executable at `target/release/iderm`. Current Linux
GNU builds use host dynamic libraries. The phrase "single binary" describes
the packaging and launch unit. It does not guarantee static linkage.

Optional user installation:

```sh
install -Dm755 target/release/iderm ~/.local/bin/iderm
```

The user shall ensure `~/.local/bin` is on `PATH`.

## 1.5 Verification

```sh
iderm --help
```

The command shall print usage and return status `0`.

![Complete `iderm --help` output from a release build, with a zero exit status shown alongside it](screenshots/01-cli-help.png)

## 1.6 Update

For a source checkout:

```sh
cd <IDERM-SOURCE-CHECKOUT>
git pull
cargo build --release
install -Dm755 target/release/iderm ~/.local/bin/iderm
```

Automatic update machinery is not provided. See Clause 12.

## 1.7 Removal

```sh
rm ~/.local/bin/iderm
```

Project-local configuration and state remain in `<project>/.iderm/`. The user
shall inspect that directory before removing it.


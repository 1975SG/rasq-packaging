# Real spec, verified for real (2026-08-22, P1 RHEL box + a local
# Fedora build). See packaging/README.md for the current status and
# what's still left before a signed release build.
#
# Two packages from one spec: `iderm` (binary + docs only) and
# `iderm-plugins-bundled` (adds a curated set of 6 pre-built example
# view plugins as reference copies under
# %%{_datadir}/iderm/plugins/*.wasm -- not auto-active, a user copies
# whichever one(s) they want into their own project's
# .iderm/views/, same "shipped but not auto-active" shape
# .iderm/languages/*.toml already uses). The full 17-plugin set stays
# in the separate iderm-plugins repo, which goes live at the same time
# as this release -- the bundle is convenience, not exclusivity.

# Real finding (22 Aug, P1 RHEL box): `BuildRequires: cargo, rust`
# checks the RPM database, and a `rustup`-installed toolchain
# (~/.cargo/bin) doesn't satisfy it, since rustup never registers
# anything there -- rpmbuild correctly refused to build. `--nodeps`
# is not an acceptable answer for real users: it silently skips *all*
# dependency checking, not just this one line, so a build could
# succeed while missing something that actually matters. The distro
# Rust toolchain (`dnf install rust cargo`) is a real requirement,
# not a workaround -- keep `BuildRequires` below and install the
# distro packages, not rustup, when building this spec.
#
# Second real finding, same session: rpmbuild's automatic debuginfo
# extraction doesn't cleanly apply to a Rust release binary the way it
# does a typical C/C++ build -- `%%global debug_package %%{nil}` below
# disables that subpackage rather than fighting rpmbuild's assumptions
# about what a compiled object looks like.
%global debug_package %{nil}

Name:           iderm
Version:        0.1.0
Release:        3%{?dist}
Summary:        Terminal-first, project-aware IDE

License:        MIT OR Apache-2.0
URL:            https://github.com/1975SG/iderm
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  cargo
BuildRequires:  rust
Requires:       glibc

%description
Terminal-first, project-aware IDE. Block-mode interaction model (IBM 3270
lineage: protected fields, full-screen atomic redraw). Brings formal
methods, simulation, measurement, and analysis into the project context
without leaving the terminal.

%package plugins-bundled
Summary:        Curated example view plugins for %{name}
Requires:       %{name} = %{version}-%{release}
BuildArch:      noarch

%description plugins-bundled
Six pre-built example view-provider plugins (analog-capture, emc,
distribution, deviation, link-graph, risk-band), covering real
instrumentation capture, general-purpose statistical visualization, and
broadly-applicable views. Installed as reference copies under
%{_datadir}/iderm/plugins/ -- copy the ones you want into your own
project's .iderm/views/ to activate them. The full plugin set lives in
the separate iderm-plugins repository.

%prep
%autosetup

%build
cargo build --release --locked

%install
install -D -m 0755 target/release/iderm %{buildroot}%{_bindir}/iderm
# %%global debug_package %%{nil} above skips rpmbuild's own automatic
# stripping too, not just debuginfo extraction -- strip explicitly so
# the installed binary isn't unnecessarily bloated with symbols.
strip %{buildroot}%{_bindir}/iderm
install -D -m 0644 README.md %{buildroot}%{_docdir}/%{name}/README.md
install -D -m 0644 LICENSE-MIT %{buildroot}%{_licensedir}/%{name}/LICENSE-MIT
install -D -m 0644 LICENSE-APACHE %{buildroot}%{_licensedir}/%{name}/LICENSE-APACHE
install -D -m 0644 docs/man/iderm.1 %{buildroot}%{_mandir}/man1/iderm.1
for p in analog-capture emc distribution deviation link-graph risk-band; do
  install -D -m 0644 packaging/bundled-plugins/${p}.wasm \
    %{buildroot}%{_datadir}/iderm/plugins/${p}.wasm
done

%files
%{_bindir}/iderm
%dir %{_docdir}/%{name}
%doc %{_docdir}/%{name}/README.md
%{_mandir}/man1/iderm.1*
%dir %{_licensedir}/%{name}
%license %{_licensedir}/%{name}/LICENSE-MIT
%license %{_licensedir}/%{name}/LICENSE-APACHE

%files plugins-bundled
%dir %{_datadir}/iderm
%dir %{_datadir}/iderm/plugins
%{_datadir}/iderm/plugins/*.wasm

%changelog
* Sun Aug 23 2026 Sinan Gözel <sinan.gozel@gmail.com> - 0.1.0-3
- Real finding from a real rpm -U/-e update+removal test (P1's RHEL
  10.2 successor box): install -D to an absolute path plus a
  %doc/%license reference to that same absolute path does not give
  RPM ownership of the containing directory the way the bare-filename
  %doc/%license shorthand does. rpm -e left three empty directories
  behind (%{_docdir}/%{name}, %{_licensedir}/%{name},
  %{_datadir}/iderm and its plugins/ subdirectory). Fixed with
  explicit %dir entries for all three.
* Sun Aug 23 2026 Sinan Gözel <sinan.gozel@gmail.com> - 0.1.0-2
- Release bump only, no source/functional change. Exists to give
  rpm -U a real, different package to upgrade over 0.1.0-1 with, so
  the update path (not just fresh install) gets genuinely tested.
* Fri Aug 21 2026 Sinan Gözel <sinan.gozel@gmail.com> - 0.1.0-1
- Placeholder spec, not yet built or signed. Added the plugins-bundled
  subpackage (6-plugin curated set).

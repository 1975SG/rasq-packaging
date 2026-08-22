# Release signing

Real GPG key generated 2026-08-22, RSA 4096, sign-only, expires
2027-08-22:

```
pub   rsa4096 2026-08-22 [SC] [expires: 2027-08-22]
      20331E9F5DC14D2F5A6B67ECCFA7A6DB35CD8203
uid                      Sinan Gözel <sinan.gozel@gmail.com>
```

Public key: [`iderm-release-key.asc`](iderm-release-key.asc) -- import
with `gpg --import iderm-release-key.asc` before verifying a signed
release artifact. The private key lives only in the maintainer's own
GnuPG keyring, not in this repository, not anywhere else.

## RPM

`rpm -K` verifies an RPM's signature directly, no repository needed --
meaningful for a standalone downloaded `.rpm`, not just a hosted repo.

```sh
signing/sign-rpm.sh path/to/iderm-0.1.0-1.*.rpm
```

**Status: blocked, not signed yet.** Needs the `rpm-sign` package
(provides `rpm --addsign`; the base `rpm` package this dev machine has
only supports signature *verification*, confirmed via
`rpm --help | grep sign`) -- requires real root, which this session
doesn't have an interactive terminal for. Run
`sudo dnf install -y rpm-sign` from a real terminal (or wherever real
root is available, e.g. the P1 RHEL box the real RPM build was already
verified on), then run the script above.

## DEB

**Real, important caveat**: unlike RPM, `apt`/`dpkg` do not verify a
standalone `.deb` file's signature automatically on install. Package
signature verification in the Debian ecosystem happens at the *APT
repository* level -- a GPG-signed `Release` file, checked when `apt`
fetches from a configured repository. A `dpkg-sig`-signed loose `.deb`
is real and checkable (`dpkg-sig --verify`), but it's proof of
authorship a user can choose to check by hand, not an apt-enforced
control. Setting up a real hosted APT repository (`reprepro`/`aptly` or
similar) with a signed `Release` file is a separate, larger, later task
-- not part of this.

```sh
signing/sign-deb.sh path/to/iderm_0.1.0-1_amd64.deb
```

**Status: blocked, not signed yet.** `dpkg-sig` isn't packaged for
Fedora at all (confirmed via `dnf list dpkg-sig` -- no match) --
genuinely Debian/Ubuntu-only tooling. Run this on a real Debian/Ubuntu
box with root (the Zorin box, or the 2008 Debian 12 box once it has
root again) -- either regenerate this same key identity there, or
import the private key from this machine (real key-transfer judgment
call, not automated here).

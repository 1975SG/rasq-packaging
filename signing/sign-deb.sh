#!/bin/sh
# Signs a real built .deb with the iderm release key, via dpkg-sig.
# Needs the `dpkg-sig` package (Debian/Ubuntu only, not packaged for
# Fedora) and the private key already imported into this user's
# GnuPG keyring -- neither is scriptable from here; see
# signing/README.md.
#
# Real caveat, not fixed by this script: apt/dpkg do not verify a
# standalone .deb's dpkg-sig signature automatically on install --
# this is proof of authorship a user can check by hand
# (`dpkg-sig --verify`), not an apt-enforced control. Enforced
# verification needs a real hosted APT repository with a GPG-signed
# Release file, which does not exist yet -- a separate, later task.
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <path-to.deb> [more.deb ...]" >&2
  exit 1
fi

for f in "$@"; do
  dpkg-sig --sign builder -k "Sinan Gözel <sinan.gozel@gmail.com>" "$f"
  echo "=== verifying $f ==="
  dpkg-sig --verify "$f"
done

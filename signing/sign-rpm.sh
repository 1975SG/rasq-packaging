#!/bin/sh
# Signs a real built .rpm with the iderm release key. Needs the
# `rpm-sign` package (provides `rpm --addsign`) and the private key
# already imported into this user's GnuPG keyring -- neither is
# scriptable from here; see signing/README.md.
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <path-to.rpm> [more.rpm ...]" >&2
  exit 1
fi

rpm --addsign "$@"

for f in "$@"; do
  echo "=== verifying $f ==="
  rpm -K "$f"
done

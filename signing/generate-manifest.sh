#!/bin/sh
# Computes real SHA-256 checksums for every built release artifact and
# writes a release manifest, both machine-readable (SHA256SUMS, the
# `sha256sum -c` format) and human-readable (RELEASE-MANIFEST.md).
# Run from the repo root. Takes no arguments -- edit the ARTIFACTS
# list below when a new package type or variant is added.
set -eu

cd "$(dirname "$0")/.."

ARTIFACTS="
packaging/deb-build-output/iderm_0.1.0-1_amd64.deb
packaging/deb-build-output/iderm-plugins-bundled_0.1.0-1_amd64.deb
packaging/rpm-build-output/iderm-0.1.0-1.fc43.x86_64.rpm
packaging/rpm-build-output/iderm-plugins-bundled-0.1.0-1.fc43.noarch.rpm
packaging/appimage-build-output/iderm-x86_64.AppImage
"

manifest_dir="release"
mkdir -p "$manifest_dir"
sums_file="$manifest_dir/SHA256SUMS"
md_file="$manifest_dir/RELEASE-MANIFEST.md"

: > "$sums_file"
{
  echo "# iderm release manifest"
  echo
  echo "Generated $(date -u +%Y-%m-%dT%H:%M:%SZ) from real local build artifacts."
  echo "Verify with: \`sha256sum -c SHA256SUMS\` from this directory, artifacts"
  echo "copied alongside it."
  echo
  echo "| File | SHA-256 | Size |"
  echo "|---|---|---|"
} > "$md_file"

for f in $ARTIFACTS; do
  if [ ! -f "$f" ]; then
    echo "skip (not built): $f" >&2
    continue
  fi
  sum=$(sha256sum "$f" | awk '{print $1}')
  size=$(du -h "$f" | awk '{print $1}')
  base=$(basename "$f")
  echo "$sum  $base" >> "$sums_file"
  echo "| \`$base\` | \`$sum\` | $size |" >> "$md_file"
done

echo "Wrote $sums_file and $md_file"
cat "$sums_file"

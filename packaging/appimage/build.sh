#!/bin/sh
# Builds iderm.AppImage from the current release binary. Run from the
# repo root (or anywhere -- paths below are relative to this script).
# Needs: a built target/release/iderm, and appimagetool on PATH or at
# $APPIMAGETOOL.
set -eu

script_dir=$(cd "$(dirname "$0")" && pwd)
repo_root=$(cd "$script_dir/../.." && pwd)
build_dir="$repo_root/packaging/appimage-build-output"
appdir="$build_dir/AppDir"
appimagetool=${APPIMAGETOOL:-appimagetool}

rm -rf "$appdir"
mkdir -p "$appdir/usr/bin"

cp "$repo_root/target/release/iderm" "$appdir/usr/bin/iderm"
cp "$script_dir/iderm.desktop" "$appdir/iderm.desktop"
cp "$script_dir/iderm.png" "$appdir/iderm.png"
ln -sf usr/bin/iderm "$appdir/AppRun"

cd "$build_dir"
ARCH=x86_64 "$appimagetool" "$appdir" "iderm-x86_64.AppImage"

echo "Built: $build_dir/iderm-x86_64.AppImage"

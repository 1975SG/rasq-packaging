#!/bin/sh
# Builds iderm.AppImage from a statically-linked musl release binary.
# Run from the repo root (or anywhere -- paths below are relative to
# this script). Needs: a built
# target/x86_64-unknown-linux-musl/release/iderm (musl-gcc + the
# x86_64-unknown-linux-musl rustup target), and appimagetool on PATH
# or at $APPIMAGETOOL.
#
# Real reason for musl, not the default glibc target: a glibc-linked
# AppImage only runs on hosts with a glibc new enough to satisfy every
# symbol version the binary was linked against. Built on a
# bleeding-edge host, that AppImage silently failed on both a real
# Debian 12 box (a clear GLIBC_2.39-not-found linker error) and Zorin
# (no visible error at all -- double-clicking a broken AppImage from a
# file manager just does nothing, no terminal to show why). musl gives
# a real, zero-runtime-dependency static binary -- the actual fix for
# AppImage's whole "runs anywhere" promise, not a workaround.
set -eu

script_dir=$(cd "$(dirname "$0")" && pwd)
repo_root=$(cd "$script_dir/../.." && pwd)
build_dir="$repo_root/packaging/appimage-build-output"
appdir="$build_dir/AppDir"
appimagetool=${APPIMAGETOOL:-appimagetool}

rm -rf "$appdir"
mkdir -p "$appdir/usr/bin"

cp "$repo_root/target/x86_64-unknown-linux-musl/release/iderm" "$appdir/usr/bin/iderm"
cp "$script_dir/iderm.desktop" "$appdir/iderm.desktop"
cp "$script_dir/iderm.png" "$appdir/iderm.png"
ln -sf usr/bin/iderm "$appdir/AppRun"

cd "$build_dir"
ARCH=x86_64 "$appimagetool" "$appdir" "iderm-x86_64.AppImage"

echo "Built: $build_dir/iderm-x86_64.AppImage"

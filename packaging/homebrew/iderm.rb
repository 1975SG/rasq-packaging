# Placeholder Homebrew formula, scaffolding only -- not yet installable.
# See packaging/README.md for what's left before this is real: a public
# tagged release to build `url`/`sha256` against, and `brew audit`/
# `brew install --build-from-source` verification on a clean machine.

class Iderm < Formula
  desc "Terminal-first, project-aware IDE"
  homepage "https://github.com/1975SG/iderm"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/1975SG/iderm.git", branch: "master"

  # TODO: once a real tagged release exists, replace `head` above with:
  #   url "https://github.com/1975SG/iderm/archive/refs/tags/vX.Y.Z.tar.gz"
  #   sha256 "<real sha256 of that tarball, computed for real, never guessed>"

  depends_on "rust" => :build

  option "with-plugins", "Install a curated set of 6 example view plugins as reference copies"

  def install
    system "cargo", "install", *std_cargo_args

    if build.with? "plugins"
      (pkgshare/"plugins").install Dir["packaging/bundled-plugins/*.wasm"]
    end
  end

  def caveats
    if build.with? "plugins"
      <<~EOS
        Six example view plugins were installed as reference copies under:
          #{pkgshare}/plugins

        They are not auto-active. Copy the ones you want into your own
        project's .iderm/views/ to use them. The full plugin set (17
        plugins) lives in the separate iderm-plugins repository.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iderm --version")
  end
end

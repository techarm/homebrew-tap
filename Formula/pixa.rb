class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sheets, generate favicons"
  homepage "https://github.com/techarm/pixa"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.7/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "a133a95b22dc3a55a385eeee3812dbc047a6a63b2cbdaead2d7ec812665430c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.7/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "e17c8454e0a5d36b8568a8bd2e793b8bcbf307e5d89aa985d4a0316bec2df6e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.7/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "653036c87c4f0ecf6099ecde14a08fe9ec4aa22e96669f1c23fe7d18efbe169f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.7/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a72470aa03ad5af64357c8cae5f5f6b6a1fe7fd0a23c9cd9665ace1605a70bfa"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pixa" if OS.mac? && Hardware::CPU.arm?
    bin.install "pixa" if OS.mac? && Hardware::CPU.intel?
    bin.install "pixa" if OS.linux? && Hardware::CPU.arm?
    bin.install "pixa" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sheets, generate favicons"
  homepage "https://github.com/techarm/pixa"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.6/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "1d0d02236fa0beeef2ef0a477d9d1a390e72834ecf11478c6a3091bcd22e4227"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.6/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "5966cb24ce83fa93a0fc46b6857031753b560b3574cb226f6d3c7cb3748812ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.6/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa5c5a4a42d492193729649c23b1fc009596ce938349b80b9007170c9b2bb705"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.6/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7798830227b891c0d407bda336f6a2f0aaeda5336672c5cf57ecfca34ad50ac"
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

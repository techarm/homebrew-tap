class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sheets, generate favicons"
  homepage "https://github.com/techarm/pixa"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.3/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "508012f27d97f9f112a00f506af19088c19e435c2e3dcab8ab0ee5b0b961a8a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.3/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "0f47433fe997c75b89fe1fbfc0f36e286108f67cd47d1a5c089edf043ea65281"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.3/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c4954b487717e7d127b3a4ba701c268f9d3ec17ecf22bd06133240d416274bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.3/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5bd6a116eca56974d13081f02f34dd38871fd60816cdea516952ff0598d7964"
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

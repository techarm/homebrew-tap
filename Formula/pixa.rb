class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sheets, generate favicons"
  homepage "https://github.com/techarm/pixa"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.5/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "153a73f1d18e22ed5714fd2e61e2eed229e9364890b93ccf67a46ab7dac5e420"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.5/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "b50e2269ee21ab43e65089128991a709c46797c0b1e06670ebae7537d796f00d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.5/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5fe0d3b4bf6176749ef9ffdfbc497a4cac305011bb981faf51745dca07e29f2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.5/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "796793d0a14ab18c7197bcceddf59be5c96d1c87993a2b78821ef89cabc39f2d"
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

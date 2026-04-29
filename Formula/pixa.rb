class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sheets, generate favicons"
  homepage "https://github.com/techarm/pixa"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.2.0/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "5f1468b35a726c6fce836d672547798f2d107b66da6e3869ec419176e6db8d2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.2.0/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "e6aca51314475c2d58dda5e05a12a5bc5d274769ec6567b08d02355625b9d1b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.2.0/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a2c4e5d1593074a7ee179968ade30762f077bbc5d4bba449bf591ad70e4fb1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.2.0/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ac5de27cc9757c564a0ee7a3f9a0f5048cf44dcbe6b01478416f6498f2911c5"
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

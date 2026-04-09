class Pixa < Formula
  desc "Fast image processing CLI: compress, resize, convert, split sprite sheets, generate favicons, and remove Gemini AI watermarks. One command for AI-image-to-web optimization."
  homepage "https://github.com/techarm/pixa"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.2/pixa-aarch64-apple-darwin.tar.xz"
      sha256 "6f9da7b253960bdef276458a5e72992f7399e1ae2786b4624c0a61aba8a2291a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.2/pixa-x86_64-apple-darwin.tar.xz"
      sha256 "f1858be537b4aeb292801ac5af64e6b20b654e7be702074515a30cca2f14475d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/techarm/pixa/releases/download/v0.1.2/pixa-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3be75354cfe2c9cde99bace23e545bb56db433ccb27a40ff9f0564ee78b17860"
    end
    if Hardware::CPU.intel?
      url "https://github.com/techarm/pixa/releases/download/v0.1.2/pixa-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f01538277448bcf8b146b53e05e547e47dde4bb88b87ec9d35733a57d65468c"
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

class DockSprout < Formula
  desc "Rust CLI tool to bring up or down multiple docker-compose files from a parent directory.
"
  homepage "https://github.com/Thompson-Jason/DockSprout"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Thompson-Jason/DockSprout/releases/download/1.0.3/dock_sprout-aarch64-apple-darwin.tar.xz"
      sha256 "3e6ed069d4b85027f797e0cddf137c595d810bdf17b3630cc2c5b052fe70722e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Thompson-Jason/DockSprout/releases/download/1.0.3/dock_sprout-x86_64-apple-darwin.tar.xz"
      sha256 "4368e4a486b0d3a26cc6adb71d1622f465427d2e211c884f92c81062fa789d8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Thompson-Jason/DockSprout/releases/download/1.0.3/dock_sprout-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d4a2a6133fa18e143be14255e6f01a92404e8d7514e436282713dc9085ee712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Thompson-Jason/DockSprout/releases/download/1.0.3/dock_sprout-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4af3ba3953882e1dc2fb7e749b73f81926989de32f16ec2a823d1715fa59d0e3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "sprout" if OS.mac? && Hardware::CPU.arm?
    bin.install "sprout" if OS.mac? && Hardware::CPU.intel?
    bin.install "sprout" if OS.linux? && Hardware::CPU.arm?
    bin.install "sprout" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

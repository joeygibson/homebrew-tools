class Yamlquill < Formula
  desc "A terminal-based structural yaml editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/yamlquill"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.0.0/yamlquill-macos-aarch64.tar.gz"
      sha256 "bf81440b79ddcb243fe8310a84f8d5ac5c5b8ee6927c8c251d3dc0472606d255"
    else
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.0.0/yamlquill-macos-x86_64.tar.gz"
      sha256 "04927f5e3263b5937d253d5411f1d86c4b95765b8086769f89c336d40330d908"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/yamlquill/releases/download/v1.0.0/yamlquill-linux-x86_64.tar.gz"
    sha256 "5afc82e440abf72e442159c40273233fae58147d1601e07cd323c24231054a53"
  end

  def install
    bin.install "yamlquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlquill --version")
  end
end

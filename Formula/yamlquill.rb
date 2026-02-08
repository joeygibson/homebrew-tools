class Yamlquill < Formula
  desc "A terminal-based structural yaml editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/yamlquill"
  version "0.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/yamlquill/releases/download/v0.3.1/yamlquill-macos-aarch64.tar.gz"
      sha256 "9dc4a9630c45b74a0d19abb1362f10f8355f0d03f104668a6fbebfb80d0be17f"
    else
      url "https://github.com/joeygibson/yamlquill/releases/download/v0.3.1/yamlquill-macos-x86_64.tar.gz"
      sha256 "5488a3fab812843014f685bbf3213add515a998106919cf76e0111729c81b2e2"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/yamlquill/releases/download/v0.3.1/yamlquill-linux-x86_64.tar.gz"
    sha256 "fec41267382370a9e35a1c79a2a6ddbd5bdf7a3819e237936c93a43d38ca05e1"
  end

  def install
    bin.install "yamlquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlquill --version")
  end
end

class Yamlquill < Formula
  desc "A terminal-based structural yaml editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/yamlquill"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.0/yamlquill-macos-aarch64.tar.gz"
      sha256 "263815ed8051f4e6ee48c8e51f43e39af0dfebd9efc93e4ed5fcfc5150915f62"
    else
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.0/yamlquill-macos-x86_64.tar.gz"
      sha256 "ab6f0c1f6c1af621af595a02e275974f3254db7f1a1369df896986d10fda5e4f"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.0/yamlquill-linux-x86_64.tar.gz"
    sha256 "b767520121356d42afd9926cb3e0c71e72666365afe16cd69c7aef2e5537bfc2"
  end

  def install
    bin.install "yamlquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlquill --version")
  end
end

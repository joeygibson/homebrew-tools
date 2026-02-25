class Yamlquill < Formula
  desc "A terminal-based structural yaml editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/yamlquill"
  version "1.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.1/yamlquill-macos-aarch64.tar.gz"
      sha256 "98c93f31bbbfabfb6c52953f78eba8f19236d710eb02bd935c56ede1fcbd0614"
    else
      url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.1/yamlquill-macos-x86_64.tar.gz"
      sha256 "c79680e88c0daad1dfa49bbb2ec3da08467cfcc477a75ee65c49261466eb7e2c"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/yamlquill/releases/download/v1.1.1/yamlquill-linux-x86_64.tar.gz"
    sha256 "beae91d98755e97ff10e8bf5669ca589ffc6d76f347a2cd8eedb8db632a0bf1f"
  end

  def install
    bin.install "yamlquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlquill --version")
  end
end

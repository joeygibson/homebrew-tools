class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.0/jsonquill-macos-aarch64.tar.gz"
      sha256 "fdc1b4045f25d834dfe9cbb2f51035703cbfdc0f580a7e9352a2f8feb614e471"
    else
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.0/jsonquill-macos-x86_64.tar.gz"
      sha256 "a081d0c316624524e1ebce46d742f9cf4dbc8f8eb02d2484be2b5cd4798792a0"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.0/jsonquill-linux-x86_64.tar.gz"
    sha256 "7c1ebf44cc231d68a241ebbca9de6a9e6a3748d052955e03820dfaf54e9243d7"
  end

  def install
    bin.install "jsonquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  version "1.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.1/jsonquill-macos-aarch64.tar.gz"
      sha256 "a0b9387e906382a62c7a601193cd33fe4376e803b4b182c36256a441b1608be4"
    else
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.1/jsonquill-macos-x86_64.tar.gz"
      sha256 "0a86ebd6716d5e8dd197d228cb9535d77865061bbeea57045d9774111e2b7bc0"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/jsonquill/releases/download/v1.1.1/jsonquill-linux-x86_64.tar.gz"
    sha256 "8b420b4bf542966147f2997c66a9827df10dda0a3238b0d0ea01214b4365a7c9"
  end

  def install
    bin.install "jsonquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

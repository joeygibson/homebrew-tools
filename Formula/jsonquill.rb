class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  version "0.12.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/jsonquill/releases/download/v0.12.4/jsonquill-macos-aarch64.tar.gz"
      sha256 "14c0666fb00c29c0fddc92ca4c8889c40e37b1c25c09d0de0b8a0e5d6cd3edab"
    else
      url "https://github.com/joeygibson/jsonquill/releases/download/v0.12.4/jsonquill-macos-x86_64.tar.gz"
      sha256 "cb7f151ed7cd4d8740c558cd8ba3c76484671bfe7b86c98c9b789448d5cfcdaa"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/jsonquill/releases/download/v0.12.4/jsonquill-linux-x86_64.tar.gz"
    sha256 "a76324efe700b71a4d8b336c5fba58b0502b1d46a9d494183f7ef946596b359a"
  end

  def install
    bin.install "jsonquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

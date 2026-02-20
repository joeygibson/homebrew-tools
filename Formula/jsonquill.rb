class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.0.0/jsonquill-macos-aarch64.tar.gz"
      sha256 "254583f913734842acbf11615d042e20e91ffd85ce98ea87ec942d3db267121d"
    else
      url "https://github.com/joeygibson/jsonquill/releases/download/v1.0.0/jsonquill-macos-x86_64.tar.gz"
      sha256 "1d3776276e5dc0fc5d881e23e2d795f3d2a34a8ec81c7c67040bf6202ecb9a10"
    end
  end

  on_linux do
    url "https://github.com/joeygibson/jsonquill/releases/download/v1.0.0/jsonquill-linux-x86_64.tar.gz"
    sha256 "1739bb2cfb431c060259e2daa72cf54632c61c83322845fc588bb5594d33d79a"
  end

  def install
    bin.install "jsonquill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

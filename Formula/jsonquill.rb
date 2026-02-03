# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  url "https://github.com/joeygibson/jsonquill/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "d45018bf0a9b9a45ec8c4e15eee86cca3d68fa9b19a5a76abeebb8a3fb461a05"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

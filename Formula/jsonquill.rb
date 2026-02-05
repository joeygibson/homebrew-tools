# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  url "https://github.com/joeygibson/jsonquill/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "cac0b5cd08f30738fbe8c9da152f956612dc9e26a32bb7f06247000c165892e7"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

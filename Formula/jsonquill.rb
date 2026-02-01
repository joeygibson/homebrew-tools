# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  url "https://github.com/joeygibson/jsonquill/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3068c8175646f04e884f4c7e0fa0eb0d4c12ba49ce0208878bac8b81af95cfa3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

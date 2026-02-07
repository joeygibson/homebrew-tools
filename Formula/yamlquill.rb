# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yamlquill < Formula
  desc "A terminal-based structural yaml editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/yamlquill"
  url "https://github.com/joeygibson/yamlquill/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b6b2f63485d57c609704f1e56f73a9ae0b49d3935531449bc3e07ba46fbdde92"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlquill --version")
  end
end

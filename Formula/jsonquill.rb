# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jsonquill < Formula
  desc "A terminal-based structural JSON editor with vim-style keybindings built in Rust"
  homepage "https://github.com/joeygibson/jsonquill"
  url "https://github.com/joeygibson/jsonquill/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "143ccd83cdf67e14c7758cb6075cde163455ac1c0abb73fe41f4ed4d866d3258"
  license "MIT"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsonquill --version")
  end
end

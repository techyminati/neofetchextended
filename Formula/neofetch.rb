class Neofetch < Formula
  desc "Command-line system information tool written in bash 3.2+"
  homepage "https://github.com/techyminati/neofetch"
  url "https://github.com/techyminati/neofetch/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "c3f2bce601ec3d12c424560bf7278a1fbe6335cda9f3c10599b25739b4cf9437"
  license "MIT"
  version "7.2.0"

  def install
    bin.install "neofetch"
    man1.install "neofetch.1"
  end

  test do
    system "#{bin}/neofetch", "--version"
    assert_match "Neofetch", shell_output("#{bin}/neofetch --version")
  end
end

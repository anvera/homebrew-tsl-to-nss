class TslToNss < Formula
  desc "Import TSL certificates into an NSS database via certutil"
  homepage "https://github.com/anvera/homebrew-tsl-to-nss"
  url "https://github.com/anvera/homebrew-tsl-to-nss/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f559c965dca1f210b1d4b0a2c33be904ab40be58b6006db2b22ce57b8f72160a"
  license "MIT"

  depends_on "anvera/tsl-extract/tsl-extract"
  depends_on "nss"

  def install
    bin.install "tsl-to-nss.sh" => "tsl-to-nss"
  end

  test do
    output = shell_output("#{bin}/tsl-to-nss 2>&1", 1)
    assert_match "Usage:", output
  end
end

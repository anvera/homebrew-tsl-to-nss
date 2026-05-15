class TslToNss < Formula
  desc "Import TSL certificates into an NSS database via certutil"
  homepage "https://github.com/anvera/homebrew-tsl-to-nss"
  url "https://github.com/anvera/homebrew-tsl-to-nss/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7b092e213d6614834d0553012e7a1455c6d014b03db409c98d66f479b9cccaa1"
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

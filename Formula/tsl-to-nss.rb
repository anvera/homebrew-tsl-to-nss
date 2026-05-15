class TslToNss < Formula
  desc "Import TSL certificates into an NSS database via certutil"
  homepage "https://github.com/anvera/homebrew-tsl-to-nss"
  url "https://github.com/anvera/homebrew-tsl-to-nss/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "PLACEHOLDER"
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

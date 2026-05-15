class TslToNss < Formula
  desc "Import TSL certificates into an NSS database via certutil"
  homepage "https://github.com/anvera/homebrew-tsl-to-nss"
  url "https://github.com/anvera/homebrew-tsl-to-nss/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8c7466e4c5e6ab6e4832847aecbec1b9e823069fe01c8e863e7d4d26c337c181"
  license "MIT"

  depends_on "anvera/tsl-extract/tsl-extract"
  depends_on "nss"

  def install
    bin.install "tsl-to-nss.sh" => "tsl-to-nss"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/tsl-to-nss 2>&1", 1)
    assert_match "Usage:", shell_output("#{bin}/tsl-to-nss -h 2>&1", 0)
  end
end

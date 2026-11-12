class Macblueprint < Formula
  desc "Snapshot installed apps and dev tools, then restore them on a new machine"
  homepage "https://github.com/erenahmettt/MacBlueprint"
  url "https://github.com/erenahmettt/MacBlueprint/releases/download/v0.3.1/macblueprint-0.3.1-macos.zip"
  sha256 "b2768fd7f7e02997fd588746bfbc45ed414991660153a92c72aa702fd8f306d1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # A universal binary built by the project's release workflow. Unlike a cask,
  # a formula download is not quarantined, so nothing needs clearing.
  depends_on macos: :sonoma

  def install
    bin.install "macblueprint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macblueprint --version")
  end
end

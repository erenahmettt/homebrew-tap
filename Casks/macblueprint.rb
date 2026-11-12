cask "macblueprint" do
  version "0.3.1"
  sha256 "91fb3edb0b9fb79eac19cf04fa69c422402c4160ad34087e19a8d62a5a386f15"

  url "https://github.com/erenahmettt/MacBlueprint/releases/download/v#{version}/MacBlueprint-#{version}.zip",
      verified: "github.com/erenahmettt/MacBlueprint/"
  name "MacBlueprint"
  desc "Snapshot a Mac's apps and tools, then restore them on another Mac"
  homepage "https://github.com/erenahmettt/MacBlueprint"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "MacBlueprint.app"

  # Ad-hoc signed but not notarised, for the same reason as diskova. See the
  # comment there: without clearing the quarantine flag, Gatekeeper refuses to
  # open the app and macOS 15 offers no Control-click bypass. The caveats say so.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/MacBlueprint.app"],
        writable_paths: ["{{appdir}}/MacBlueprint.app"]
  end

  uninstall quit: "io.github.erenahmettt.MacBlueprint"

  zap trash: [
    "~/Library/Application Support/MacBlueprint",
    "~/Library/Caches/MacBlueprint",
    "~/Library/Preferences/io.github.erenahmettt.MacBlueprint.plist",
    "~/Library/Saved Application State/io.github.erenahmettt.MacBlueprint.savedState",
  ]

  caveats <<~EOS
    MacBlueprint is not notarised by Apple, so this cask removed the quarantine
    flag macOS puts on downloads. Without that, Gatekeeper would refuse to open
    it, and macOS 15 no longer offers the Control-click bypass.

    If you would rather make that decision yourself, uninstall this and either
    download the release from GitHub and use System Settings > Privacy &
    Security > Open Anyway, or build from source.

    MacBlueprint only reads your Mac. It installs something only when you press
    Install on the Restore screen, after showing exactly what will run.

    The command-line tool is a separate formula:
      brew install erenahmettt/tap/macblueprint
  EOS
end

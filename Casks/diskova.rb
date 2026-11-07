cask "diskova" do
  version "0.1.0"
  sha256 "34162ae88c98d5f09ee49b217b7b0dc17d20866b618f862757e4eb3ca059cf08"

  url "https://github.com/erenahmettt/diskova/releases/download/v#{version}/Diskova-#{version}.zip",
      verified: "github.com/erenahmettt/diskova/"

  name "Diskova"
  desc "Treemap disk space visualiser that can move what it finds to the Trash"
  homepage "https://github.com/erenahmettt/diskova"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Diskova.app"

  # Diskova is ad-hoc signed but not notarised: a Developer ID costs $99 a year
  # and this is a free weekend project. macOS attaches com.apple.quarantine to
  # anything downloaded, and Gatekeeper refuses to open an unsigned app that
  # carries it. Sequoia removed the Control-click bypass, so without this the
  # install would end at a dialog most people cannot get past.
  #
  # `--no-quarantine` used to be the way to handle this. Homebrew removed that
  # flag, so the cask has to do it directly. Clearing the flag during an install
  # someone deliberately asked for is the same thing they would otherwise type
  # by hand — but it is said out loud in the caveats below rather than done
  # quietly, because it is the one thing in here worth knowing about.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Diskova.app"],
                   sudo: false
  end

  uninstall quit: "io.github.erenahmettt.Diskova"

  zap trash: [
    "~/Library/Caches/io.github.erenahmettt.Diskova",
    "~/Library/Preferences/io.github.erenahmettt.Diskova.plist",
    "~/Library/Saved Application State/io.github.erenahmettt.Diskova.savedState",
  ]

  caveats <<~EOS
    Diskova is not notarised by Apple, so this cask removed the quarantine flag
    macOS puts on downloads. Without that, Gatekeeper would refuse to open it,
    and macOS 15 no longer offers the Control-click bypass.

    If you would rather make that decision yourself, uninstall this and either
    download the release from GitHub and use System Settings > Privacy &
    Security > Open Anyway, or build from source — it needs no Apple account
    and takes about thirty seconds.

    Diskova never deletes anything outright: removal always goes through the
    Trash. To scan locations macOS protects, such as the whole startup disk,
    grant it Full Disk Access in System Settings > Privacy & Security.
  EOS
end

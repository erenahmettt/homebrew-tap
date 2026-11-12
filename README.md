# erenahmettt/homebrew-tap

A Homebrew tap for my own macOS apps.

```bash
brew tap erenahmettt/tap
```

```bash
brew trust erenahmettt/tap
```

Then install whichever you want:

```bash
brew install --cask diskova
```

```bash
brew install --cask macblueprint
```

```bash
brew install --formula macblueprint
```

## What is in here

| Package | Kind | What it is |
|---|---|---|
| [`diskova`](Casks/diskova.rb) | cask | [Diskova](https://github.com/erenahmettt/diskova) — maps a folder or a whole disk as a treemap, so whatever is filling it is the biggest shape on screen |
| [`macblueprint`](Casks/macblueprint.rb) | cask | [MacBlueprint](https://github.com/erenahmettt/MacBlueprint) — snapshots a Mac's apps, Homebrew packages and editor extensions, then shows and restores what a new Mac is missing |
| [`macblueprint`](Formula/macblueprint.rb) | formula | The `macblueprint` command-line tool from the same project. A plain binary, so there is no quarantine flag to clear |

## Why a separate tap, and why the trust step

These apps are **ad-hoc signed but not notarised**. Notarising means paying
Apple $99 a year for a Developer ID, which is not something a free weekend
project earns back.

That has two consequences, and both are worth understanding before you install
anything from here:

**1. Homebrew's official cask repository will not take them.** As of 1 September
2026 Homebrew stopped accepting casks that fail Gatekeeper checks, which is why
this tap exists at all rather than a pull request to `homebrew/cask`.

**2. The casks clear the quarantine flag themselves.** macOS attaches
`com.apple.quarantine` to anything downloaded, and Gatekeeper refuses to open an
unsigned app carrying it — and macOS 15 removed the Control-click bypass that
used to get past it. Homebrew's `--no-quarantine` flag, which used to handle
this, has been removed. So each cask here runs this after installing:

```ruby
postflight_steps do
  run "/usr/bin/xattr",
      args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Diskova.app"],
      writable_paths: ["{{appdir}}/Diskova.app"]
end
```

That is the same command you would otherwise type by hand, run as part of an
install you explicitly asked for. But it does mean **Gatekeeper will not get a
say**, and you should know that before typing `brew install`. It is also why
`brew trust` is required: Homebrew will not run a third-party tap's code until
you say so. That prompt is doing its job.

## If you would rather not

Entirely reasonable. Two alternatives, both supported:

- **Download the release** from the project's Releases page and approve it
  yourself through *System Settings › Privacy & Security › Open Anyway*. Every
  release ships a SHA-256 you can check first.
- **Build from source.** Needs no Apple account and takes about thirty seconds.

## Verifying what you get

Every cask and formula pins an exact `sha256`, so Homebrew refuses the download if the
archive is not byte-for-byte the one that was published. The archives are built
by GitHub Actions from a tagged commit, and the workflow that builds them is
public. Each package in this repository is itself installed and verified by
[CI](.github/workflows/audit.yml) on every push.

## Licence

[MIT](LICENSE).

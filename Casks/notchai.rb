cask "notchai" do
  version "0.7.0"
  sha256 "beaf41334e1caa7e632242ffcc4ce781714cb15db9e1ca4b0ae4970c1ea075b5"

  url "https://github.com/Bossaln/lumo/releases/download/v#{version}/notchai-#{version}.zip"
  name "notchai"
  desc "Turns the MacBook notch into a control center for Claude Code and Codex (renamed to lumo)"
  homepage "https://github.com/Bossaln/lumo"

  deprecate! date: "2026-10-25", because: "was renamed to lumo", replacement_cask: "bossaln/tap/lumo"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "notchai.app"

  uninstall quit: "com.bossaln.notchai"

  zap trash: [
    "~/Library/Application Support/notchai",
    "~/Library/Caches/com.bossaln.notchai",
    "~/Library/HTTPStorages/com.bossaln.notchai",
    "~/Library/HTTPStorages/com.bossaln.notchai.binarycookies",
    "~/Library/Logs/notchai",
    "~/Library/Preferences/com.bossaln.notchai.plist",
    "~/Library/Saved Application State/com.bossaln.notchai.savedState",
  ]
end

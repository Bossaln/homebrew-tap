cask "notchai" do
  version "0.3.0"
  sha256 "e94055040733f7befaedbc8997df94dc5b37cabcddac235dc0fe7d1ae2e4191e"

  url "https://github.com/Bossaln/notchai/releases/download/v#{version}/notchai-#{version}.zip"
  name "notchai"
  desc "Turns the MacBook notch into a control center for Claude Code and Codex"
  homepage "https://github.com/Bossaln/notchai"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "notchai.app"

  # notchai is signed with its own certificate, not notarized by Apple. Without removing the quarantine flag
  # Gatekeeper would refuse to open it ("Apple could not verify …").
  # Afterwards a pink GT-R drives off – notchai is installed, let's go. The animation is the small program
  # notchai-welcome inside the app (Sources/notchai-welcome); it always exits 0.
  if respond_to?(:postflight_steps)
    # Homebrew 7 and later: declarative install steps instead of Ruby code.
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/notchai.app"], must_succeed: false
      run "{{appdir}}/notchai.app/Contents/MacOS/notchai-welcome", must_succeed: false, print_stdout: true
    end
  else
    postflight do
      system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/notchai.app"]
      system_command "#{appdir}/notchai.app/Contents/MacOS/notchai-welcome", print_stdout: true
    end
  end

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

cask "lumo" do
  version "0.8.0"
  sha256 "729b90f2c51a3d0e747ee6cfabfb4891413ffe52873fcd7483f988d028444fc0"

  url "https://github.com/Bossaln/lumo/releases/download/v#{version}/lumo-#{version}.zip"
  name "lumo"
  desc "Turns the MacBook notch into a control center for Claude Code and Codex"
  homepage "https://github.com/Bossaln/lumo"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "lumo.app"

  # lumo is signed with its own certificate, not notarized by Apple. Without removing the quarantine flag
  # Gatekeeper would refuse to open it ("Apple could not verify …").
  # Afterwards a pink GT-R drives off – lumo is installed, let's go. The animation is the small program
  # lumo-welcome inside the app (Sources/lumo-welcome); it always exits 0.
  if respond_to?(:postflight_steps)
    # Homebrew 7 and later: declarative install steps instead of Ruby code.
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/lumo.app"], must_succeed: false
      run "{{appdir}}/lumo.app/Contents/MacOS/lumo-welcome", must_succeed: false, print_stdout: true
    end
  else
    postflight do
      system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/lumo.app"]
      system_command "#{appdir}/lumo.app/Contents/MacOS/lumo-welcome", print_stdout: true
    end
  end

  uninstall quit: "com.bossaln.lumo"

  zap trash: [
    "~/Library/Application Support/lumo",
    "~/Library/Caches/com.bossaln.lumo",
    "~/Library/HTTPStorages/com.bossaln.lumo",
    "~/Library/HTTPStorages/com.bossaln.lumo.binarycookies",
    "~/Library/Logs/lumo",
    "~/Library/Preferences/com.bossaln.lumo.plist",
    "~/Library/Saved Application State/com.bossaln.lumo.savedState",
  ]
end

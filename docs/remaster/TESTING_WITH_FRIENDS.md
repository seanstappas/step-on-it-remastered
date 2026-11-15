# Testing with Friends (Private Release & Online Play Guide)

`Step On It! Remastered` is distributed to testers via **Velopack** using **GitHub Releases** on the private repository [`https://github.com/seanstappas/step-on-it-remastered`](https://github.com/seanstappas/step-on-it-remastered). Release builds can embed a **single read-only fine-grained PAT** (XOR-masked inside `StepOnItLauncher.exe` at build time) so testers get automatic updates out of the box with zero token setup, while keeping all tokens completely out of git and `update_config.json`.

---

## (a) For Sean — Publishing Releases & Sharing with Testers

### 1. One-time dev PC setup: create & save the read-only release token

GitHub disables PAT creation via the REST API and `gh` CLI (requiring interactive web login/2FA), and `gh auth token` is a broad `gho_` read/write token that must **never** be shared. Instead, create one read-only fine-grained token once on GitHub:

1. Open [Fine-grained personal access tokens → New](https://github.com/settings/personal-access-tokens/new) (`Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token`).
2. Set a **Token name** (e.g. `soi-friends-updater`) and an expiration date.
3. Set **Resource owner** to `seanstappas`.
4. Under **Repository access**, select **Only select repositories** → `seanstappas/step-on-it-remastered`.
5. Under **Repository permissions**, set **Contents** to **Read-only** (leave all other permissions at **No access**).
6. Click **Generate token**, copy it, and save it outside git on your dev PC:
   ```powershell
   powershell -ExecutionPolicy Bypass -File tools/set_release_token.ps1 -FromClipboard
   ```
   - This saves the token to `%LOCALAPPDATA%\StepOnIt\release_embed_token.txt` (outside the repository, never committed or printed).
   - Both `tools/set_release_token.ps1` and `tools/publish_velopack.ps1` reject broad `gho_`/`ghu_` tokens by default so an accidental OAuth token cannot ship in an installer.

> **Trade-off to keep in mind:** Baking a shared read-only token into `StepOnItLauncher.exe` means anyone who receives `StepOnIt-win-Setup.exe` effectively holds read-only access to the repository until that token is revoked. To avoid GitHub Secret Scanning false auto-revocations inside `.nupkg`/`.zip` release archives and keep `update_config.json` token-free, `tools/publish_velopack.ps1` generates a transient 32-byte XOR mask during the C build so no plaintext token appears in git or in the compiled binary.

### 2. Publish a release to GitHub Releases

1. Ensure `gh` is authenticated with `repo` scope (`gh auth status`), or set `$env:GITHUB_TOKEN` in your PowerShell session.
2. Run the packaging & upload script from the repo root:
   ```powershell
   powershell -ExecutionPolicy Bypass -File tools/publish_velopack.ps1 -Version 1.1.2 -UploadToGitHub
   ```
   - `-RepoUrl` defaults to `https://github.com/seanstappas/step-on-it-remastered` and is always written into `build\win\update_config.json` (token-free).
   - The script automatically reads `%LOCALAPPDATA%\StepOnIt\release_embed_token.txt` (or `-EmbedUpdateToken` / `$env:SOI_EMBED_UPDATE_TOKEN`), XOR-embeds it into `StepOnItLauncher.exe` via a temporary header deleted right after compilation, and refuses to upload if no embed token is configured (unless `-AllowNoEmbedToken` is passed).
   - If `$env:GITHUB_TOKEN` is empty, the script automatically falls back to `gh auth token` for the release upload without printing the token.
   - On the first release (when the repo has zero GitHub Releases), prior-release download is skipped cleanly; on subsequent releases, `vpk download github` fetches the previous release so Velopack generates a `<5 MB` delta `.nupkg` alongside the full installer.
   - Outputs land in `releases\` (`StepOnIt-win-Setup.exe`, `*.nupkg`, `releases.win.json`) and are published as a GitHub Release (`Step On It! v<Version>`).

### 3. Share the installer

Choose either option so testers can get `StepOnIt-win-Setup.exe` for the initial install:

- **Direct file transfer (easiest):** Send `releases\StepOnIt-win-Setup.exe` to your friends directly (e.g. Discord, Drive, cloud share). Once installed, future updates arrive automatically via the embedded read-only token.
- **Invite as a collaborator:** In the repository's **Settings → Collaborators**, add the tester's GitHub account with **Read** access so they can sign into GitHub and download `StepOnIt-win-Setup.exe` directly from the **Releases** page.

---

## (b) For Testers — Installing & Automatic Updates

### 1. Install the game (zero token setup required)

1. Download `StepOnIt-win-Setup.exe` (directly from Sean, or from the GitHub Releases page while signed in) and double-click it.
2. Because the installer is unsigned, Windows Defender SmartScreen will show **"Windows protected your PC"**. Click **More info** → **Run anyway**.
3. Velopack installs quietly with no wizard into `%LocalAppData%\StepOnIt\`:
   - Launcher executable: `%LocalAppData%\StepOnIt\current\StepOnItLauncher.exe`
   - Game executable + pack: `%LocalAppData%\StepOnIt\current\StepOnIt.exe` and `StepOnIt.pck`
   - Start Menu shortcut: **StepOnIt**

No extra commands or token setup are needed—the read-only update token is already built into `StepOnItLauncher.exe`.

### 2. How updates arrive

1. Start the game normally from the **StepOnIt** Start Menu shortcut (or `StepOnItLauncher.exe`).
2. The launcher checks GitHub Releases for a newer version (bounded to ~5 seconds so a failed or offline check never stalls startup).
3. When an update is available, a **"Step On It! Updater"** window opens showing `"Updating Step On It!... NN%"`, downloads the small delta package, applies it, and launches the updated game automatically.
4. If the embedded token is ever revoked/expired, or you are offline, the launcher skips updating and starts the game immediately.

### 3. Optional: Overriding or clearing a token locally

If an old installer's embedded token is revoked or expires and you want to point an existing install at a new token without re-running `StepOnIt-win-Setup.exe`, run `StepOnItLauncher.exe --set-update-token` once:

In **PowerShell**:
```powershell
& "$env:LocalAppData\StepOnIt\current\StepOnItLauncher.exe" --set-update-token "<paste-new-token>"
```

Or in **Command Prompt (`cmd.exe`)**:
```bat
"%LocalAppData%\StepOnIt\current\StepOnItLauncher.exe" --set-update-token "<paste-new-token>"
```

- This writes `%LocalAppData%\StepOnIt\update_token.txt`, shows a brief confirmation, and exits without launching the game.
- Token lookup precedence in the launcher is: `SOI_UPDATE_TOKEN` environment variable → `%LocalAppData%\StepOnIt\update_token.txt` → `"update_token"` in `update_config.json` → XOR-masked embedded token in `StepOnItLauncher.exe` (skipped if `SOI_DISABLE_EMBEDDED_TOKEN=1`) → anonymous.
- To remove an override file later, run `StepOnItLauncher.exe --clear-update-token`.

### 4. Logs & troubleshooting

- The launcher writes diagnostics to `%LocalAppData%\StepOnIt\launcher.log`.
- Token values are **never** written to `launcher.log` (only `present` / `absent` status).

---

## (c) Playing Online (Rollback Netcode)

From the title menu, open **Online Multiplayer (Rollback Netcode)** and pick **Host Match** or **Join Match**.

### Hosting a match

1. On the **Host Match** tab, choose **Players** (`2 Players` or `3 Players (Co-op)`), **Mode** (`Cooperate`, `Compete`, or `Versus`), optional rules/custom map, and click **Open Lobby & Listen**.
2. The game binds **UDP port `7777`** and attempts UPnP port mapping automatically.
3. Share either the **Join Code** (`SOI-XXXX-XXXX`) or the **Direct IP:port** (`<IP>:7777`) shown in the lobby:
   - **Same LAN:** Share the **LAN Code** or `LAN IP:7777`.
   - **Over the internet (Tailscale — easiest):** If both players run [Tailscale](https://tailscale.com/), the lobby automatically detects the host's `100.x.x.x` address and displays a **Tailscale Code** and `Tailscale IP:7777` — no router configuration required.
   - **Over the internet (Router port-forward):** If UPnP fails or isn't enabled on your router, forward **UDP port `7777`** on your router to the host PC's LAN IP and share the **WAN Code** or `WAN IP:7777`.
4. **Windows Firewall:** When Windows prompts on first host, allow `StepOnIt.exe` on **Private** (and **Public** if playing over Tailscale/internet), or add an inbound Windows Firewall rule allowing **UDP port `7777`**.

### Joining a match

1. On the **Join Match** tab, paste the host's **Join Code** (`SOI-XXXX-XXXX`) or **Direct IP:port** (`<IP>:7777`).
2. Click **Connect** and wait for the host to click **Start Match**.

### Version requirement (build-ID gate)

- Both the host and every client **must** run the exact same build.
- During the handshake, `SoiCore.build_id()` is checked between peers; mismatched versions display:
  `Version mismatch: restart to update. Esc: menu`
- If you see this message, close the game and relaunch via `StepOnItLauncher.exe` (or the **StepOnIt** Start Menu shortcut) so everyone updates to the same release.

---

## (d) Revoking or Rotating the Shared Update Token

1. On GitHub, go to **Settings → Developer settings → Personal access tokens → Fine-grained tokens**.
2. Click the shared release token (e.g. `soi-friends-updater`) and choose **Revoke** (or **Delete**).
3. *(Optional)* If you invited testers as repository collaborators in **Settings → Collaborators**, remove anyone who should no longer have access.

To rotate to a fresh token for future updates:
1. Generate a new fine-grained PAT (`Contents: Read-only` on `seanstappas/step-on-it-remastered`), save it with `tools/set_release_token.ps1 -FromClipboard`, and publish a new release (`tools/publish_velopack.ps1 -Version X.Y.Z -UploadToGitHub`) for new installs.
2. Existing installs whose embedded token was revoked will skip updating and still launch normally; testers can either re-run the new `StepOnIt-win-Setup.exe` or run `StepOnItLauncher.exe --set-update-token "<new-token>"` once to pull deltas again.

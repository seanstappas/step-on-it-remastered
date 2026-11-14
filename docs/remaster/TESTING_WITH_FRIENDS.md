# Testing with Friends (Private Release & Online Play Guide)

`Step On It! Remastered` is distributed to testers via **Velopack** using **GitHub Releases** on the private repository [`https://github.com/seanstappas/step-on-it-remastered`](https://github.com/seanstappas/step-on-it-remastered). No GitHub token is ever baked into the installer or `update_config.json`.

---

## (a) For Sean — Publishing Releases & Inviting Testers

### 1. Publish a release to GitHub Releases

1. Ensure `gh` is authenticated with `repo` scope (`gh auth status`), or set `$env:GITHUB_TOKEN` in your PowerShell session.
2. Run the packaging & upload script from the repo root:
   ```powershell
   powershell -ExecutionPolicy Bypass -File tools/publish_velopack.ps1 -Version 1.1.0 -UploadToGitHub
   ```
   - `-RepoUrl` defaults to `https://github.com/seanstappas/step-on-it-remastered` and is always written into `build\win\update_config.json`.
   - If `$env:GITHUB_TOKEN` is empty, the script automatically falls back to `gh auth token` without printing the token.
   - On the first release (when the repo has zero GitHub Releases), prior-release download is skipped cleanly; on subsequent releases (`1.1.1`, etc.), `vpk download github` fetches the previous release so Velopack generates a `<5 MB` delta `.nupkg` alongside the full installer.
   - Outputs land in `releases\` (`StepOnIt-win-Setup.exe`, `*.nupkg`, `releases.win.json`) and are published as a GitHub Release (`Step On It! v<Version>`).

### 2. Create a per-tester read-only token

Create one fine-grained Personal Access Token per friend so each tester's access can be revoked independently:

1. On GitHub, open **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**.
2. Set a descriptive **Token name** (e.g. `soi-tester-alex`) and an expiration date.
3. Set **Resource owner** to `seanstappas`.
4. Under **Repository access**, select **Only select repositories** → `seanstappas/step-on-it-remastered`.
5. Under **Repository permissions**, set **Contents** to **Read-only** (leave all other permissions at **No access**).
6. Click **Generate token**, copy it immediately, and send it to that tester over a private channel.

### 3. Share the installer

Choose either option so the tester can get `StepOnIt-win-Setup.exe` for the initial install:

- **Invite as a collaborator (recommended for self-service):** In the repository's **Settings → Collaborators**, add the tester's GitHub account with **Read** access so they can sign into GitHub and download `StepOnIt-win-Setup.exe` directly from the **Releases** page.
- **Direct file transfer:** Send `releases\StepOnIt-win-Setup.exe` to the tester directly (for example via cloud share or messaging). Once installed and configured with their token, future updates arrive automatically inside the launcher.

---

## (b) For Testers — Installing, Setting Your Token & Updating

### 1. Install the game

1. Download `StepOnIt-win-Setup.exe` (from the GitHub Releases page while signed in, or directly from Sean) and double-click it.
2. Because the installer is unsigned, Windows Defender SmartScreen will show **"Windows protected your PC"**. Click **More info** → **Run anyway**.
3. Velopack installs quietly with no wizard into `%LocalAppData%\StepOnIt\`:
   - Launcher executable: `%LocalAppData%\StepOnIt\current\StepOnItLauncher.exe`
   - Game executable + pack: `%LocalAppData%\StepOnIt\current\StepOnIt.exe` and `StepOnIt.pck`
   - Start Menu shortcut: **StepOnIt**

### 2. Set your update token (once)

Run `StepOnItLauncher.exe --set-update-token` once with the personal token Sean sent you. This saves the token to `%LocalAppData%\StepOnIt\update_token.txt`, shows a short confirmation dialog, and exits without starting the game.

In **PowerShell**:
```powershell
& "$env:LocalAppData\StepOnIt\current\StepOnItLauncher.exe" --set-update-token "<paste-your-token>"
```

Or in **Command Prompt (`cmd.exe`)**:
```bat
"%LocalAppData%\StepOnIt\current\StepOnItLauncher.exe" --set-update-token "<paste-your-token>"
```

- Token lookup precedence in the launcher is: `SOI_UPDATE_TOKEN` environment variable → `%LocalAppData%\StepOnIt\update_token.txt` → `"update_token"` in `update_config.json` → anonymous.
- To remove a saved token later, run `StepOnItLauncher.exe --clear-update-token`.

### 3. How updates arrive

1. Start the game normally from the **StepOnIt** Start Menu shortcut (or `StepOnItLauncher.exe`).
2. The launcher checks GitHub Releases for a newer version (bounded to ~5 seconds so a failed or offline check never stalls startup).
3. When an update is available, a **"Step On It! Updater"** window opens showing `"Updating Step On It!... NN%"`, downloads the small delta package, applies it, and launches the updated game automatically.
4. If no token is set, the token is revoked, or you are offline, the launcher skips updating and starts the game immediately.

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

## (d) Revoking a Tester's Token

1. On GitHub, go to **Settings → Developer settings → Personal access tokens → Fine-grained tokens**.
2. Click the tester's named token (e.g. `soi-tester-alex`) and choose **Revoke** (or **Delete**).
3. *(Optional)* If you invited them as a repository collaborator in **Settings → Collaborators**, remove them there as well to revoke web access to Releases.

Revoking one tester's token immediately blocks update downloads for that token without affecting other testers or existing local installs.

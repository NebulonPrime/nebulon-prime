# Privacy and offline behavior

This OS sends no telemetry, needs no account, and works fully offline.
This page lists every change made to reach that, so anyone can check it.
The changes are in `build_files/steps/20-privacy-offline.sh`.

## Switched off

| What | Why it was on upstream | What we do |
|---|---|---|
| `rpm-ostree-countme` | Fedora's anonymous weekly ping to estimate user numbers | Disabled and masked; `countme=0` in every repo file |
| ABRT crash reporting (if present) | Can upload crash reports to Fedora | Disabled and masked |
| Tailscale (`tailscaled`) | Aurora ships it enabled | Disabled; enable it yourself if you use Tailscale |
| GeoClue | Looks up your location over the network | Disabled; set a location manually for night light |

## Already off upstream

- **KDE User Feedback** is opt-in and off by default.
- **No account** is needed to install or use the system.

## Network use you choose

- **Updates.** The system checks for updates when it's online, and skips the check when offline.
  It contacts the GitHub container registry, plus Fedora and Flathub mirrors. No usage data is sent.
- **Flatpak apps** (Bottles and others) download from Flathub on first boot, when a network is available.

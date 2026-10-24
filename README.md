# MyOS

A Windows-style desktop OS that runs Windows apps, built on Fedora Atomic (Universal Blue Aurora, KDE Plasma).

- **Read-only system.** The OS is a single image that can't be modified while running. Updates install as a whole new image, and you can roll back from the boot menu.
- **Offline-first, zero telemetry.** No account needed, and nothing phones home. See [docs/PRIVACY.md](docs/PRIVACY.md).
- **Windows apps.** Bottles (Wine) comes preinstalled, and double-clicking an `.exe` opens it.
- **Removable apps.** Apps you see are Flatpaks, and any of them can be uninstalled.
- **Automatic snapshots** of your home folder, which you can browse and restore in Btrfs Assistant.

## Editions

| Image | Graphics |
|---|---|
| `ghcr.io/CHANGE-ME/myos` | AMD, Intel |
| `ghcr.io/CHANGE-ME/myos-nvidia` | NVIDIA GTX 16-series, RTX 20-series and newer |

## Roadmap

- [x] Base image, branding, privacy defaults, Bottles, snapshots, NVIDIA + AMD/Intel builds
- [ ] Windows-style layouts (Win 11 default, Win 10, Win 7) chosen on first boot
- [ ] CPU/RAM monitors in the taskbar
- [ ] Unified theme across KDE, GTK and Wine apps
- [ ] Per-icon desktop sizes
- [ ] Multi-seat helper (two users, two screens, one PC)
- [ ] Experimental: two cursors on one screen
- [ ] Fully offline installer (Flatpaks embedded in the ISO)

## Building

Container image: `just build`. Installer ISO: `just build-iso`. Both need Podman on Linux or WSL2.
GitHub Actions builds both editions daily. The disk-image workflow builds the ISOs on demand.

Rename the OS: `./rename-os.sh <id> "<Pretty Name>" <github-owner>`.

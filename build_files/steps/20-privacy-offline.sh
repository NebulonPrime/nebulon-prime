#!/bin/bash
# Zero telemetry and offline-first defaults.
# Everything switched off here is listed in docs/PRIVACY.md - keep the two in sync.

set -ouex pipefail

disable_if_present() {
    for unit in "$@"; do
        if systemctl list-unit-files "$unit" >/dev/null 2>&1 && systemctl cat "$unit" >/dev/null 2>&1; then
            systemctl disable "$unit" || true
            systemctl mask "$unit" || true
        fi
    done
}

# Fedora's anonymous "count me" ping (sent with update checks to estimate user numbers)
disable_if_present rpm-ostree-countme.service rpm-ostree-countme.timer
for repo in /etc/yum.repos.d/*.repo; do
    sed -i 's/^countme=1/countme=0/' "$repo"
done

# Crash reporters that can upload data
disable_if_present abrtd.service abrt-journal-core.service abrt-oops.service abrt-xorg.service

# Network services that should be opt-in, not on by default
disable_if_present tailscaled.service

# Geolocation lookups (KDE only uses this for night light; users can pick a location manually)
disable_if_present geoclue.service

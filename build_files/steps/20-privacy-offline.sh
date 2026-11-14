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
# Repo files live in /etc/yum.repos.d on older bases and under /usr on newer ones; cover all of them
shopt -s nullglob
for repo in /etc/yum.repos.d/*.repo /etc/distro.repos.d/*.repo /usr/share/dnf5/repos.d/*.repo; do
    sed -i 's/^countme=1/countme=0/' "$repo"
done
shopt -u nullglob
# And the global default, for any repo that doesn't set it
if [[ -f /etc/dnf/dnf.conf ]] && ! grep -q '^countme=' /etc/dnf/dnf.conf; then
    sed -i '/^\[main\]/a countme=0' /etc/dnf/dnf.conf
fi

# Crash reporters that can upload data
disable_if_present abrtd.service abrt-journal-core.service abrt-oops.service abrt-xorg.service

# Network services that should be opt-in, not on by default
disable_if_present tailscaled.service

# Geolocation lookups (KDE only uses this for night light; users can pick a location manually)
disable_if_present geoclue.service

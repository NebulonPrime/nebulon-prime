#!/bin/bash
# Install every app listed in /usr/share/flatpak/preinstall.d (ours and Aurora's) into the system
# Flatpak installation, the same set the first-boot preinstall service would download.

set -ouex pipefail

flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Each "[Flatpak Preinstall <id>]" section becomes "<id>//<Branch>" (or just "<id>" with no Branch)
mapfile -t refs < <(awk '
    function flush() { if (id != "") print (branch != "" ? id "//" branch : id) }
    /^\[Flatpak Preinstall / { flush(); id = $3; sub(/\]$/, "", id); branch = ""; next }
    /^Branch=/ { branch = substr($0, 8) }
    END { flush() }
' /usr/share/flatpak/preinstall.d/*.preinstall | sort -u)

printf 'Baking in: %s\n' "${refs[@]}"
flatpak install --system --noninteractive --assumeyes flathub "${refs[@]}"

# bootc-image-builder installs the Anaconda installer from the repos in /etc/yum.repos.d, but newer
# Aurora images keep them in /usr/share/dnf5/repos.d. Copy them over for the ISO build only: the
# kickstart switches to the normal signed image afterwards, which drops these unchanged copies.
shopt -s nullglob
etc_repos=(/etc/yum.repos.d/*.repo)
if (( ${#etc_repos[@]} == 0 )); then
    install -d /etc/yum.repos.d
    cp -v /usr/share/dnf5/repos.d/*.repo /etc/yum.repos.d/
fi
shopt -u nullglob
grep -l '^enabled=1' /etc/yum.repos.d/*.repo

# Leave no build-time leftovers in /var/tmp or /tmp
rm -rf /var/tmp/* /tmp/*

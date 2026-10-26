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

# Leave no build-time leftovers in /var/tmp or /tmp
rm -rf /var/tmp/* /tmp/*

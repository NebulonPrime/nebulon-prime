#!/bin/bash
# Windows app support. Bottles (Wine manager) is preinstalled as a removable Flatpak by
# system_files/usr/share/flatpak/preinstall.d/; here we only add native helpers.

set -ouex pipefail

# Fonts Windows apps commonly expect (open-source metric-compatible replacements)
dnf5 install -y \
    liberation-fonts \
    google-carlito-fonts \
    google-crosextra-caladea-fonts

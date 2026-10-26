#!/bin/bash
# Replace the Fedora artwork in the Anaconda installer with Nebulon Prime's, by adding
# /images/product.img to a finished ISO. Anaconda loads that file automatically at boot and
# lays it over the installer's own files. Runs on the Ubuntu CI runner after bootc-image-builder.
#
# Usage: brand-iso.sh <path/to/install.iso>

set -euxo pipefail

ISO="$1"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
PIX="$WORK/product/usr/share/anaconda/pixmaps"

sudo apt-get install -y --no-install-recommends librsvg2-bin cpio xorriso isomd5sum

mkdir -p "$PIX"

# Logo at the top of the sidebar on the main screens
rsvg-convert -w 150 -h 150 "$REPO/branding/distributor-logo.svg" -o "$PIX/sidebar-logo.png"

# Night-sky violet backgrounds for the sidebar and the top bar, matching the wallpaper
cat > "$WORK/sidebar.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="1600">
  <defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0" stop-color="#2a1a6e"/><stop offset="1" stop-color="#0b0820"/>
  </linearGradient></defs>
  <rect width="300" height="1600" fill="url(#g)"/>
</svg>
EOF
cat > "$WORK/topbar.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="2400" height="96">
  <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="0">
    <stop offset="0" stop-color="#2a1a6e"/><stop offset="1" stop-color="#5b3cc4"/>
  </linearGradient></defs>
  <rect width="2400" height="96" fill="url(#g)"/>
</svg>
EOF
rsvg-convert "$WORK/sidebar.svg" -o "$PIX/sidebar-bg.png"
rsvg-convert "$WORK/topbar.svg" -o "$PIX/topbar-bg.png"
cp "$PIX/topbar-bg.png" "$PIX/anaconda_header.png"

(cd "$WORK/product" && find . | cpio -o -H newc | gzip -9) > "$WORK/product.img"

# Add the file in place, keeping the ISO's BIOS and UEFI boot setup, then refresh the
# checksum that "Test this media" checks
xorriso -indev "$ISO" -outdev "$WORK/branded.iso" \
    -boot_image any replay \
    -map "$WORK/product.img" /images/product.img
implantisomd5 --force "$WORK/branded.iso"

mv -f "$WORK/branded.iso" "$ISO"
rm -rf "$WORK"

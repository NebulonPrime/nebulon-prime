#!/bin/bash
# Replace Aurora/Fedora artwork with Nebulon Prime's: logos, wallpaper, boot splash.
# Sources are the SVGs in branding/; everything else is rendered from them here.

set -ouex pipefail

dnf5 install -y librsvg2-tools libjxl-utils

B=/ctx/branding
ICONS=/usr/share/icons/hicolor/scalable
PIX=/usr/share/pixmaps

render() { # render <svg> <png> <width> <height>
    rsvg-convert --keep-aspect-ratio -w "$3" -h "$4" -o "$2" "$1"
}

### Logos
# Aurora keeps its art in a few real files and points many symlinks at them;
# remove whatever is there and install ours so every name resolves to Nebulon Prime art.
install -d "$ICONS/places" "$ICONS/apps" "$PIX"

rm -f "$ICONS/distributor-logo.svg"
install -m644 "$B/distributor-logo.svg" "$ICONS/distributor-logo.svg"
for name in places/distributor-logo places/auroralogo-gradient; do
    ln -sfr "$ICONS/distributor-logo.svg" "$ICONS/$name.svg"
done

rm -f "$ICONS/places/distributor-logo-symbolic.svg"
install -m644 "$B/distributor-logo-symbolic.svg" "$ICONS/places/distributor-logo-symbolic.svg"
for name in places/auroralogo-symbolic places/distributor-logo-white places/start-here apps/start-here; do
    ln -sfr "$ICONS/places/distributor-logo-symbolic.svg" "$ICONS/$name.svg"
done
# Other Aurora logo variants: point them at ours too
for f in "$ICONS"/places/auroralogo-*.svg; do
    [[ "$f" == *symbolic* ]] && continue
    [[ -e "$f" || -L "$f" ]] && ln -sfr "$ICONS/distributor-logo.svg" "$f"
done

install -m644 "$B/banner.svg" "$PIX/nebulon-banner.svg"
for name in aurora-banner.svg fedora-logo.svg fedora_whitelogo.svg; do
    rm -f "$PIX/$name"
    ln -sr "$PIX/nebulon-banner.svg" "$PIX/$name"
done
rm -f "$PIX/fedora-logo-sprite.svg"
ln -sr "$ICONS/distributor-logo.svg" "$PIX/fedora-logo-sprite.svg"

render "$B/banner.svg" "$PIX/fedora-logo.png" 400 100
render "$B/banner.svg" "$PIX/fedora-logo-small.png" 128 32
render "$B/banner.svg" "$PIX/fedora_logo_med.png" 200 50
for name in system-logo system-logo-white; do
    render "$B/distributor-logo.svg" "$PIX/$name.png" 256 256
done
render "$B/distributor-logo.svg" "$PIX/fedora-logo-sprite.png" 128 128

gtk-update-icon-cache -f /usr/share/icons/hicolor || true

### Wallpaper (KDE wallpaper package + the default.jxl links Aurora's screens point at)
WP=/usr/share/wallpapers/NebulonPrime
install -d "$WP/contents/images"
# Lossless, so the night sky's dark gradients don't band
cjxl "$B/wallpaper.png" "$WP/contents/images/1672x941.jxl" -d 0
install -m 0644 "$B/wallpaper-preview.png" "$WP/contents/screenshot.png"
cat > "$WP/metadata.json" <<'EOF'
{
    "KPlugin": {
        "Authors": [{ "Name": "Nebulon Prime" }],
        "Id": "NebulonPrime",
        "Name": "Nebulon Prime"
    }
}
EOF
for name in default.jxl default-dark.jxl; do
    rm -f "/usr/share/backgrounds/$name"
    ln -sr "$WP/contents/images/1672x941.jxl" "/usr/share/backgrounds/$name"
done
# Anything still asking for Aurora's default wallpaper by name gets ours
rm -rf /usr/share/wallpapers/Aurora
ln -sr "$WP" /usr/share/wallpapers/Aurora

# Login screen (Plasma Login Manager) background
install -d /usr/lib/plasmalogin
cat > /usr/lib/plasmalogin/defaults.conf <<'EOF'
[Greeter]
WallpaperPlugin=org.kde.image

[Greeter][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/NebulonPrime/
PreviewImage=file:///usr/share/wallpapers/NebulonPrime/
EOF

### Boot splash (Plymouth spinner theme watermark), then rebuild the initramfs that carries it
PLY=/usr/share/plymouth/themes/spinner
install -d "$PLY"
render "$B/banner.svg" "$PLY/watermark.png" 440 110
cp "$PLY/watermark.png" "$PLY/kinoite-watermark.png"

KERNEL_VERSION="$(ls /usr/lib/modules | sort -V | tail -n1)"
/usr/bin/dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"

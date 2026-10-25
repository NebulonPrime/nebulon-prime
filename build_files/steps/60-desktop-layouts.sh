#!/bin/bash
# Windows-style desktop layouts, shipped as KDE Global Themes ("look-and-feel" packages).
# Users switch in System Settings > Colors & Themes > Global Theme (tick "Desktop and window layout").
# Windows 11 style is the default for new users.

set -ouex pipefail

SRC=/ctx/desktop
LNF=/usr/share/plasma/look-and-feel
PROFILE=/usr/share/kde-settings/kde-profile/default/xdg
ACCENT="139,92,246" # Nebulon violet

make_theme() { # make_theme <id> <display name> <layout.js> <color scheme> <icon theme>
    local id="org.nebulonprime.$1.desktop" dir
    dir="$LNF/$id"
    install -d "$dir/contents/layouts"

    cat > "$dir/metadata.json" <<EOF
{
    "KPackageStructure": "Plasma/LookAndFeel",
    "KPlugin": {
        "Authors": [{ "Name": "Nebulon Prime" }],
        "Description": "$2 taskbar and Start menu",
        "Id": "$id",
        "License": "GPL-2.0-or-later",
        "Name": "Nebulon Prime – $2"
    },
    "X-Plasma-MainScript": "defaults"
}
EOF

    cat > "$dir/contents/defaults" <<EOF
[kdeglobals][KDE]
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=$4
AccentColor=$ACCENT

[kdeglobals][Icons]
Theme=$5

[plasmarc][Theme]
name=default

[kcminputrc][Mouse]
cursorTheme=breeze_cursors

[kwinrc][WindowSwitcher]
LayoutName=org.kde.breeze.desktop

[kwinrc][DesktopSwitcher]
LayoutName=org.kde.breeze.desktop

[kwinrc][org.kde.kdecoration2]
library=org.kde.breeze

[KSplash]
Theme=org.kde.breeze.desktop
EOF

    cat "$SRC/common.js" "$SRC/$3" > "$dir/contents/layouts/org.kde.plasma.desktop-layout.js"
}

make_theme win11 "Windows 11 style" win11.js BreezeDark breeze-dark
make_theme win10 "Windows 10 style" win10.js BreezeDark breeze-dark
make_theme win7 "Windows 7 style" win7.js BreezeLight breeze

### Defaults for new users (Aurora ships these in the KDE profile; we replace the branding-specific ones)
install -d "$PROFILE"

# Keep Aurora's font settings, but switch theme, colours and accent
sed -i \
    -e "s|^LookAndFeelPackage=.*|LookAndFeelPackage=org.nebulonprime.win11.desktop|" \
    "$PROFILE/kdeglobals"
grep -q '^AccentColor=' "$PROFILE/kdeglobals" ||
    sed -i "/^\[General\]/a AccentColor=$ACCENT" "$PROFILE/kdeglobals"

cat > "$PROFILE/ksplashrc" <<'EOF'
[KSplash]
Theme=org.kde.breeze.desktop
EOF

cat > "$PROFILE/kscreenlockerrc" <<'EOF'
[Greeter]
WallpaperPlugin=org.kde.image

[Greeter][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/NebulonPrime/
PreviewImage=file:///usr/share/wallpapers/NebulonPrime/
EOF

# Remove Aurora's own Global Themes so the theme list only offers Nebulon Prime layouts
rm -rf "$LNF"/dev.getaurora.*

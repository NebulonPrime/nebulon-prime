#!/bin/bash
# Give the OS its own name in os-release, the boot menu and "About this System".

set -ouex pipefail

: "${OS_ID:?}" "${OS_PRETTY_NAME:?}" "${OS_VARIANT:?}"

FEDORA_VERSION="$(rpm -E %fedora)"

sed -i \
    -e "s|^NAME=.*|NAME=\"${OS_PRETTY_NAME}\"|" \
    -e "s|^PRETTY_NAME=.*|PRETTY_NAME=\"${OS_PRETTY_NAME} (based on Fedora ${FEDORA_VERSION})\"|" \
    -e "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${OS_ID}\"|" \
    -e "s|^VARIANT_ID=.*|VARIANT_ID=${OS_ID}-${OS_VARIANT}|" \
    -e "s|^HOME_URL=.*|HOME_URL=\"https://github.com/\"|" \
    /usr/lib/os-release

# Keep ID=fedora / ID_LIKE so Fedora tooling and apps keep working; add our own fields.
grep -q '^IMAGE_ID=' /usr/lib/os-release || echo "IMAGE_ID=${OS_ID}" >> /usr/lib/os-release
sed -i "s|^IMAGE_ID=.*|IMAGE_ID=${OS_ID}|" /usr/lib/os-release

# KDE "About this System" page (Aurora also ships one in the KDE profile; replace both)
for f in /etc/xdg/kcm-about-distrorc /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc; do
    mkdir -p "$(dirname "$f")"
    cat > "$f" <<EOF
[General]
LogoPath=/usr/share/pixmaps/system-logo.png
Name=${OS_PRETTY_NAME}
Variant=${OS_VARIANT}
Website=
EOF
done

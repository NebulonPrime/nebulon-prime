#!/bin/bash
# Set the OS name and GitHub owner everywhere in one go.
# Usage: ./rename-os.sh <os-id> "<Pretty Name>" <github-user-or-org>
#   e.g. ./rename-os.sh novaguard "Novaguard OS" my-github-name

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <os-id> \"<Pretty Name>\" <github-user-or-org>" >&2
    exit 1
fi

new_id="$1"
new_name="$2"
new_owner="$3"

cd "$(dirname "$0")"

old_id="$(sed -n 's/^IMAGE_NAME=//p' image-template.env)"
old_owner="$(sed -n 's/^REPO_ORGANIZATION="\(.*\)"/\1/p' image-template.env)"

sed -i \
    -e "s|^IMAGE_NAME=.*|IMAGE_NAME=${new_id}|" \
    -e "s|^OS_ID=.*|OS_ID=${new_id}|" \
    -e "s|^OS_PRETTY_NAME=.*|OS_PRETTY_NAME=\"${new_name}\"|" \
    -e "s|^REPO_ORGANIZATION=.*|REPO_ORGANIZATION=\"${new_owner}\"|" \
    image-template.env

sed -i "s|ghcr.io/${old_owner}/${old_id}|ghcr.io/${new_owner,,}/${new_id}|" disk_config/iso*.toml

echo "Renamed ${old_id} -> ${new_id} (\"${new_name}\"), owner ${old_owner} -> ${new_owner}"

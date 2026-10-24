#!/bin/bash
# Automatic snapshots of users' home folders. The read-only system protects the OS itself;
# snapshots protect personal files (bad deletes, ransomware) and can be restored in Btrfs Assistant.

set -ouex pipefail

dnf5 install -y snapper btrfs-assistant

systemctl enable snapshots-setup.service
systemctl enable snapper-timeline.timer snapper-cleanup.timer

#!/bin/bash
# Entry point for the image build. Runs each numbered step in order.

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

for step in /ctx/steps/*.sh; do
    echo "::group:: ===== $(basename "$step") ====="
    bash "$step"
    echo "::endgroup::"
done

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Base image: Aurora (Fedora Atomic + KDE Plasma) from Universal Blue.
# The CI builds two variants from this one file:
#   ghcr.io/ublue-os/aurora:stable              -> AMD / Intel graphics
#   ghcr.io/ublue-os/aurora-nvidia-open:stable  -> NVIDIA (RTX 20-series and newer, GTX 16-series)
ARG BASE_IMAGE=ghcr.io/ublue-os/aurora:stable
FROM ${BASE_IMAGE}

# OS branding, set from image-template.env by the Justfile / CI
ARG OS_ID=myos
ARG OS_PRETTY_NAME="MyOS"
ARG OS_VARIANT=main

### MODIFICATIONS
## All changes live in build_files/ (scripts) and system_files/ (files copied to /).
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    OS_ID="${OS_ID}" OS_PRETTY_NAME="${OS_PRETTY_NAME}" OS_VARIANT="${OS_VARIANT}" \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

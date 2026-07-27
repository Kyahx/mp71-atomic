# BASE_TAG=stable-nvidia adds ublue's nvidia driver (negativo17) for when the 3090 moves in:
#   podman build --build-arg BASE_TAG=stable-nvidia -t localhost/mp71-atomic:dev .
ARG BASE_TAG=stable

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image — full ucore (not ucore-minimal): this host actively serves SMB shares
# over a real ZFS pool, so the NAS/HCI layer (samba, zfs) is load-bearing here, not
# dead weight.
FROM ghcr.io/ublue-os/ucore:${BASE_TAG}

### MODIFICATIONS
## MacPro7,1-specific enablement — see build_files/mp71-enablement.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/mp71-enablement.sh && \
    ostree container commit

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

# Define required labels for this bootc image to be recognized as such.
LABEL containers.bootc 1
LABEL ostree.bootable 1

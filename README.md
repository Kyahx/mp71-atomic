# mp71-atomic

A [bootc](https://bootc-dev.github.io/bootc/)-based image for a MacPro7,1 (2019 Mac Pro)
running headless as a multi-GPU LLM/container host. Transactional upgrades and rollbacks,
delivered as an OCI image.

## Attribution

This project started as a fork of [`kansei-os/t2-atomic`](https://github.com/kansei-os/t2-atomic). The Containerfile/Justfile/CI structure here descends from that project.

t2-atomic's actual T2 enablement — the `t2linux` kernel swap, wifi/BT firmware, keyboard/trackpad
dracut hooks, `t2fanrd` — targets T2 *laptops* and doesn't apply to the Mac Pro 2019, so none of it
is carried here. If you have a T2 MacBook/Mac mini/iMac, you want their project, not this one. The primary use case
for this project is a headless home lab server.

Base image is full [`ublue-os/ucore`](https://github.com/ublue-os/ucore) (`ucore:stable`, not
`ucore-minimal`) — a "batteries included" Fedora CoreOS bootc image with podman, cockpit,
tailscale, firewalld, tuned, and the NAS/HCI layer (samba, zfs, mergerfs, snapraid). Samba is
load-bearing here: this host actively serves SMB shares over a real ZFS pool.

## What this adds on top of `ucore:stable`

See `build_files/mp71-enablement.sh` — currently: `apfs-fuse`, `avahi`(-tools), `cockpit-ostree`,
`rocm-smi`, matching what's manually layered on the host today so the image build is the single
source of truth. An `amdgpu-dkms` build step is a planned future addition (see the `local-llm`
project's `rocm-large-tier-dkms-swap` plan) — not yet implemented. The goal is to fold in whatever
host-local layering makes sense (AMD ROCm enablement, avahi, etc.) so the image build stays the
single source of truth instead of ad hoc `rpm-ostree install`.

## Building locally

```
just build mp71-atomic dev                                 # stable ucore base
BASE_TAG=stable-nvidia just build mp71-atomic dev-nvidia    # nvidia driver variant (for future GPU swaps)
just lint                                                   # shellcheck build_files/*.sh
```

Both flavors build and pass `bootc container lint`. Nothing here is booted/switched onto the live
host automatically — that stays a deliberate, separate step.

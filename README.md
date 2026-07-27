# mp71-atomic

A [bootc](https://bootc-dev.github.io/bootc/)-based image for a MacPro7,1 (2019 Mac Pro tower)
running headless as a multi-GPU LLM/container host. Transactional upgrades and rollbacks,
delivered as an OCI image.

## Attribution

This project started as a fork of [`kansei-os/t2-atomic`](https://github.com/kansei-os/t2-atomic),
which pioneered the bootc-based approach to Apple T2 hardware enablement on Fedora Atomic. The
Containerfile/Justfile/CI structure here descends from that project (itself building on the
[ublue-os image template](https://github.com/ublue-os/image-template)).

t2-atomic's actual T2 enablement — the `t2linux` kernel swap, wifi/BT firmware, keyboard/trackpad
dracut hooks, `t2fanrd` — targets T2 *laptops* and doesn't apply to a Mac Pro tower, so none of it
is carried here. If you have a T2 MacBook/Mac mini/iMac, you want their project, not this one.

Base image is [`ublue-os/ucore`](https://github.com/ublue-os/ucore) (`ucore-minimal`) — a
"batteries included" Fedora CoreOS bootc image providing podman, cockpit, tailscale, firewalld,
tuned, and ZFS out of the box, without the NAS/HCI layer (samba, mergerfs, snapraid) this host
doesn't use.

## What this adds over `ucore-minimal`

See `build_files/mp71-enablement.sh` — currently: `apfs-fuse`, `avahi`(-tools), `cockpit-ostree`,
`rocm-smi`, matching what's manually layered on the host today so the image build is the single
source of truth. An `amdgpu-dkms` build step is a planned future addition (see the `local-llm`
project's `rocm-large-tier-dkms-swap` plan) — not yet implemented.

## Building locally

```
just build mp71-atomic dev                          # stable ucore-minimal base
BASE_TAG=stable-nvidia just build mp71-atomic dev-nvidia   # nvidia driver variant (for future GPU swaps)
just lint                                            # shellcheck build_files/*.sh
```

Both flavors build and pass `bootc container lint`. Nothing here is booted/switched onto the live
host automatically — that stays a deliberate, separate step.

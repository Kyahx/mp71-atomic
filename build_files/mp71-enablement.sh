#!/bin/bash
set -ouex pipefail

# MacPro7,1 (2019 Mac Pro tower) enablement — deliberately NOT the t2linux laptop
# enablement this repo forked from. This host already runs a stock ucore kernel with
# working amdgpu + normal SMC-driven fan/thermal behavior (verified via sensors/rpm-ostree
# on the running host, no t2linux COPR kernel involved). A Mac Pro tower has no internal
# keyboard/trackpad/touch bar/battery, so the wifi firmware, t2fanrd, keyboard dracut hook,
# and kernel swap from upstream's t2-enablement.sh don't apply here and are dropped.

# lm_sensors/sg3_utils already ship in the ucore base image — nothing to add there.
# wodim/xorriso/libinput(-utils)/radeontop were t2-atomic laptop cruft (optical-drive
# slot-load, touchpad, unused GPU tool) — this host doesn't use them, dropped.
#
# These are what's actually manually `rpm-ostree install`-layered on the running host
# today (see `rpm-ostree status -v` LayeredPackages) — baking them in here so the image
# build is the single source of truth instead of drifting from ad hoc layering.
dnf5 -y install apfs-fuse avahi avahi-tools cockpit-ostree rocm-smi

# Hook point: amdgpu-dkms build step goes here once decided
# (see local-llm/plan/rocm-large-tier-dkms-swap.plan.md, Path A/B/C — not yet implemented).

dnf clean all

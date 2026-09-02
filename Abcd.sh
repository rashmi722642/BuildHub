#!/bin/bash

# =========================================================
# PIXELOS ANDROID 17 - MARBLE
# =========================================================

# =========================================================
# REPO INIT
# =========================================================

repo init -u https://github.com/PixelOS-AOSP/android_manifest.git -b seventeen --git-lfs

echo "=================="
echo "Repo init success"
echo "=================="


# =========================================================
# BUILD SYNC
# =========================================================

/opt/crave/resync.sh

echo "============="
echo "Sync success"
echo "============="


# =========================================================
# DEVICE / VENDOR / KERNEL TREES
# =========================================================

git clone https://github.com/rashmi722642/android_device_xiaomi_marble.git device/xiaomi/marble

git clone https://github.com/rashmi722642/android_device_xiaomi_sm8450-common.git device/xiaomi/sm8450-common

git clone https://github.com/rashmi722642/hardware_dolby.git hardware/dolby

git clone https://github.com/rashmi722642/android_hardware_xiaomi.git hardware/xiaomi

git clone https://github.com/rashmi722642/android_kernel_xiaomi_sm8450.git kernel/xiaomi/sm8450

git clone https://github.com/rashmi722642/android_kernel_xiaomi_sm8450-devicetrees.git kernel/xiaomi/sm8450-devicetrees

git clone https://github.com/rashmi722642/android_kernel_xiaomi_sm8450-modules.git kernel/xiaomi/sm8450-modules

git clone https://github.com/rashmi722642/android_vendor_xiaomi_marble.git vendor/xiaomi/marble

git clone https://github.com/rashmi722642/vendor_xiaomi_marble-firmware.git vendor/xiaomi/marble-firmware

git clone https://github.com/rashmi722642/android_vendor_xiaomi_sm8450-common.git vendor/xiaomi/sm8450-common

git clone https://github.com/Pixelify-devices/device_xiaomi_miuicamera-marble device/xiaomi/miuicamera-marble

git clone https://github.com/Pixelify-devices/vendor_xiaomi_miuicamera-marble vendor/xiaomi/miuicamera-marble

git clone https://github.com/AOSPA/android_device_xiaomi_sepolicy device/xiaomi/sepolicy


# =========================================================
# TEST KEYS
# =========================================================

git clone https://github.com/xenxynon/certs vendor/aosp/signing/keys

git clone https://github.com/xenxynon/certs

echo "======================================"
echo "All device trees cloned successfully"
echo "======================================"


# =========================================================
# TEMPORARY ZYGOTE FIX
#
# Remove:
#   ro.zygote=zygote64_32
#
# Keep:
#   ro.zygote=zygote64
# =========================================================

echo "======================================"
echo "Applying temporary zygote fix"
echo "======================================"

grep -RIl 'ro\.zygote=zygote64_32' \
    device vendor build/make \
    --include='*.mk' \
    --include='*.prop' \
    --include='*.bp' \
    2>/dev/null | while read -r f; do

    echo "[ZYGO-FIX] Removing from: $f"

    sed -i '/ro\.zygote=zygote64_32/d' "$f"

done


echo "======================================"
echo "Checking remaining zygote64_32"
echo "======================================"

grep -Rns 'ro\.zygote=zygote64_32' \
    device vendor build/make \
    --include='*.mk' \
    --include='*.prop' \
    --include='*.bp' \
    2>/dev/null || true


echo "======================================"
echo "Zygote temporary fix completed"
echo "======================================"


# =========================================================
# EXPORT
# =========================================================


export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true

echo "======= Export Done ======="


# =========================================================
# BUILD ENVIRONMENT
# =========================================================

source build/envsetup.sh

echo "==========================="
echo "Build environment ready"
echo "==========================="


# =========================================================
# 
# =========================================================

breakfast marble userdebug


# =========================================================
# FINAL ZYGOTE CONFIG CHECK
# =========================================================

echo "======================================"
echo "FINAL ZYGOTE CONFIG"
echo "======================================"

grep -RnsE 'ro\.zygote[?]?=' \
    device/xiaomi \
    vendor/xiaomi \
    build/make/target/product \
    --include='*.mk' \
    --include='*.prop' \
    2>/dev/null | head -100 || true

echo "======================================"


# =========================================================
# BUILD PIXELOS
# =========================================================

echo "======================================"
echo "Starting PixelOS Android 17 build"
echo "======================================"

m pixelos


# =========================================================
# BUILD OUTPUT
# =========================================================

echo "======================================"
echo "Build completed - checking output"
echo "======================================"

ls -lh "$OUT"

echo "======================================"
echo "PixelOS build finished"
echo "======================================"

#!/usr/bin/env bash
crave run --no-patch -- "
# 1. Init & Sync
repo init -u https://github.com/PixelOS-AOSP/android_manifest.git -b seventeen --git-lfs
/opt/crave/resync.sh

# 2. Clean old folders
rm -rf device/xiaomi/marble device/xiaomi/sm8450-common hardware/dolby hardware/xiaomi kernel/xiaomi/sm8450 kernel/xiaomi/sm8450-devicetrees kernel/xiaomi/sm8450-modules vendor/xiaomi/marble vendor/xiaomi/marble-firmware vendor/xiaomi/sm8450-common device/xiaomi/miuicamera-marble vendor/xiaomi/miuicamera-marble device/xiaomi/sepolicy vendor/aosp/signing/keys certs

# 3. Clone trees
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

# 4. Clone keys
git clone https://github.com/xenxynon/certs vendor/aosp/signing/keys
git clone https://github.com/xenxynon/certs certs

# 5. Setup env
source build/envsetup.sh
breakfast marble userdebug

# 6. Build & Sign
m target-files-package otatools
sign_target_files_apks -o -d certs \
    out/target/product/marble/obj/PACKAGING/target_files_intermediates/*target_files*.zip \
    signed-target_files.zip
ota_from_target_files -k certs/releasekey \
    signed-target_files.zip \
    signed-ota_update.zip
ls out/target/product/marble > out.txt
"

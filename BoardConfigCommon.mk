#
# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

COMMON_PATH := device/motorola/sm7435-common

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_dlkm \
    vendor_boot

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

# Audio
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PAL_HIDL := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_SUPPORTS_OPENSOURCE_STHAL := true
TARGET_USES_QCOM_MM_AUDIO := true
TARGET_PAL_SPKR_PROTECTION_PATH := /mnt/vendor/persist/factory/audio/audio.cal

# Bootloader
TARGET_NO_BOOTLOADER := true

# Broken
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES  := true

# DTB / DTBO
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_USES_QCOM_MERGE_DTBS_SCRIPT := true
TARGET_NEEDS_DTBOIMAGE := true
TARGET_MERGE_DTBS_WILDCARD ?= parrot*base

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs

# Kernel
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE += \
    firmware_class.path=/vendor/firmware_mnt/image \
    printk.devkmsg=on \
    sysctl.kernel.firmware_config.force_sysfs_fallback=1
BOARD_BOOTCONFIG += \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3
BOARD_BOOTCONFIG += androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Platform
BOARD_ROOT_EXTRA_SYMLINKS := \
    /vendor/fsg:/fsg

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_RECOVERYIMAGE_PARTITION_SIZE ?= 134217728
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_BUILD_VENDOR_RAMDISK_IMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_MOT_DP_GROUP_PARTITION_LIST := product system system_ext vendor vendor_dlkm
BOARD_SUPER_PARTITION_GROUPS := mot_dp_group
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_EROFS_PCLUSTER_SIZE := 262144
BOARD_EROFS_COMPRESSOR := lz4hc,12

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/init/fstab.qcom

SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

# SELinux
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
include hardware/motorola/sepolicy/qti/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/private
PRODUCT_PUBLIC_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/public

# Verified Boot
BOARD_AVB_ENABLE := true

ifneq (,$(AVB_CUSTOM_KEY_PATH))
BOARD_AVB_ALGORITHM := $(AVB_CUSTOM_ALGORITHM)
BOARD_AVB_KEY_PATH := $(AVB_CUSTOM_KEY_PATH)
else
AVB_CUSTOM_ALGORITHM := SHA256_RSA2048
AVB_CUSTOM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
endif

ifneq ($(WITH_AVB),true)
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
endif
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := $(AVB_CUSTOM_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(AVB_CUSTOM_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# inherit from the proprietary version
include vendor/motorola/sm7435-common/BoardConfigVendor.mk

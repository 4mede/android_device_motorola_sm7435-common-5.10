#
# Copyright (C) 2024 The LineageOS Project
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

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Platform
TARGET_BOARD_PLATFORM := parrot

# ADB
PRODUCT_PROPERTY_OVERRIDES +=\
    ro.adb.secure=0 \
    ro.debuggable=1 \
    persist.sys.usb.config=adb

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.3-impl \
    audioadsprpcd \
    audio.bluetooth.default \
    audio.primary.parrot \
    audio.r_submix.default \
    audio.usb.default \
    lib_bt_aptx \
    lib_bt_ble \
    lib_bt_bundle \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libfmpal \
    sound_trigger.primary.parrot \
    vendor.qti.hardware.AGMIPC@1.0-service

AUDIO_HAL_DIR := vendor/qcom/opensource/audio-hal/primary-hal

PRODUCT_COPY_FILES += \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.base-arm.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm.policy \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.base-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm64.policy \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm.policy \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy \
    $(AUDIO_HAL_DIR)/configs/common/bluetooth_qti_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_audio_policy_configuration.xml \
    $(AUDIO_HAL_DIR)/configs/common/bluetooth_qti_hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_hearing_aid_audio_policy_configuration.xml \
    $(AUDIO_HAL_DIR)/configs/parrot/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml \
    $(AUDIO_HAL_DIR)/configs/parrot/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_parrot/audio_effects.xml \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml
    
PRODUCT_ODM_PROPERTIES += \
    aaudio.mmap_policy=1 \
    vendor.audio.offload.buffer.size.kb=256

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.audio.auto.scenario=true \
    persist.vendor.audio.misound.disable=true \
    ro.audio.monitorRotation=true \
    ro.audio.spatializer_enabled=true \
    ro.audio.spatializer_transaural_enabled_default=false \
    ro.config.alarm_vol_steps=15 \
    ro.config.system_vol_steps=15 \
    ro.config.vc_call_vol_default=9 \
    ro.config.vc_call_vol_steps=11 \
    ro.vendor.audio.camera.loopback.support=false \
    ro.vendor.audio.feature.spatial=7 \
    ro.vendor.audio.gain.support=true \
    ro.vendor.audio.soundtrigger.appdefine.cnn.level=45 \
    ro.vendor.audio.soundtrigger.appdefine.gmm.level=65 \
    ro.vendor.audio.soundtrigger.appdefine.gmm.user.level=55 \
    ro.vendor.audio.soundtrigger.appdefine.vop.level=10 \
    ro.vendor.audio.soundtrigger.xanzn.cnn.level=158 \
    ro.vendor.audio.soundtrigger.xanzn.gmm.level=80 \
    ro.vendor.audio.soundtrigger.xanzn.gmm.user.level=80 \
    ro.vendor.audio.soundtrigger.xanzn.vop.level=41 \
    ro.vendor.audio.soundtrigger.xatx.cnn.level=95 \
    ro.vendor.audio.soundtrigger.xatx.gmm.level=54 \
    ro.vendor.audio.soundtrigger.xatx.gmm.user.level=54 \
    ro.vendor.audio.soundtrigger.xatx.vop.level=0 \
    ro.vendor.audio.support.sound.id=true

# Bluetooth
PRODUCT_VENDOR_PROPERTIES += \
    persist.sys.fflag.override.settings_bluetooth_hearing_aid=true \
    persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2 \
    persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false \
    persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true \
    persist.vendor.qcom.bluetooth.scram.enabled=false \
    persist.vendor.qcom.bluetooth.twsp_state.enabled=false \
    persist.vendor.service.bdroid.soc.alwayson=true \
    ro.vendor.bluetooth.csip_qti=true
    
# Camera
PRODUCT_VENDOR_PROPERTIES += \
    camera.disable_zsl_mode=1 \
    ro.camera.enableCamera1MaxZsl=1 \
    persist.vendor.camera.privapp.list=com.motorola.camera3

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    init.qti.display_boot.rc \
    init.qti.display_boot.sh \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.demura-service
    
PRODUCT_ODM_PROPERTIES += \
    debug.sf.enable_hwc_vds=0 \
    persist.sys.sf.color_mode=0 \
    ro.surface_flinger.set_idle_timer_ms?=1100 \
    ro.surface_flinger.set_touch_timer_ms?=200 \
    ro.surface_flinger.supports_background_blur=0 \
    vendor.display.disable_3d_adaptive_tm=0 \
    vendor.display.vds_allow_hwc=1

PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=120 \
    persist.sys.sf.native_mode=258 \
    ro.vendor.display.hwc_thermal_dimming=false \
    ro.vendor.display.nature_mode.enable=true \
    ro.vendor.histogram.enable=true \
    ro.vendor.sre.enable=true
    
# DPM
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.dpm.vndr.feature=1 \
    persist.vendor.dpm.vndr.halservice.enable=1 \
    persist.vendor.dpm.vndr.idletimer.mode=default

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey
  
PRODUCT_VENDOR_PROPERTIES += \
    drm.service.enabled=true
    
# Extras
$(call inherit-product, vendor/custom/common.mk)

$(call inherit-product, hardware/dolby/dolby.mk)

$(call inherit-product, vendor/aospa-priv/keys/keys.mk)

PRODUCT_PACKAGES += \
    RemovePackages

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd
    
# FUSE
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

# GPS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery
    
# Incremental FS
PRODUCT_VENDOR_PROPERTIES += \
    ro.incremental.enable=1

# Init
PRODUCT_PACKAGES += \
    fstab.qcom \
    fstab.qcom.vendor_ramdisk \
    fstab.qcom.zram \
    init.mmi.charge_only.rc \
    init.mmi.chipset.rc \
    init.mmi.rc \
    init.target.rc \
    ueventd.sm7435.rc \
    init.mmi.boot.sh \
    init.mmi.touch.sh \
    init.oem.hw.sh
    
# Kernel
PRODUCT_ENABLE_UFFD_GC := true

# Keymaster
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.keystore_desede=true \
    vendor.gatekeeper.disable_spu=true

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/module/qpnp_adaptive_charge/parameters/charging_enabled)

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay-service.sdm \
    vendor.lineage.livedisplay-service.sysfs

$(call soong_config_set_bool,livedisplay_sdm,enable_dm,false)
$(call soong_config_set_bool,livedisplay_sysfs,enable_se,true)

# Media
PRODUCT_VENDOR_PROPERTIES += \
    debug.stagefright.c2inputsurface=-1 \
    ro.mediaserver.64b.enable=true \
    vendor.media.omx=0

# Motorola
PRODUCT_PACKAGES += \
    MotoActions \
    MotoCommonOverlay
    
PRODUCT_VENDOR_PROPERTIES += \
    ro.mot.build.customerid=global

# Mountpoints
PRODUCT_PACKAGES += \
    vendor_fsg_mountpoint \
    vendor_super_fsg_mountpoint \
    vendor_super_modem_mountpoint

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResCommon \
    LineageApertureAppCommon \
    LineageSdkCommon \
    SettingsProviderResCommon \
    SystemUIResCommon \
    WifiResCommon \
    FrameworksResTarget \
    NcmTetheringOverlay \
    WifiResTarget

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_parrot/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_ravelin/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/product_privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sysconfig/hotword-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hotword-hiddenapi-package-whitelist.xml

# Power
TARGET_PROVIDES_POWERHAL := true

PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    libqti-perfd-client

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json
    
# QTI Components
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    alarm \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    media \
    overlay \
    perf \
    telephony \
    usb \
    wfd \
    wlan
    
# Radio
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.data.iwlan.enable=true \
    persist.vendor.radio.add_power_save=1 \
    persist.vendor.radio.dynamic_sar=1 \
    persist.vendor.radio.redir_party_num=0 \
    ro.vendor.radio.build_profile=v-stable

# RFS MSM MPSS symlinks
PRODUCT_PACKAGES += \
    rfs_msm_mpss_readonly_vendor_fsg_symlink

# Sensors
PRODUCT_PACKAGES += \
    sensors.motorola \
    android.hardware.sensors-service.multihal
    
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.sensors.enable.mag_filter=true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/motorola \
    vendor/aospa/interfaces/power-libperfmgr
    
# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.qti \
    android.hardware.usb.gadget-service.qti \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    usb_compositions.conf

PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/usb/etc

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# VINTF
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/motorola/vintf/device_framework_matrix.xml
DEVICE_MANIFEST_FILE += device/motorola/sm7435-common/vintf/manifest.xml

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

# WiFi firmware symlinks
TARGET_WIFI_VARIANTS ?= adrastea qca6750
$(foreach variant,$(TARGET_WIFI_VARIANTS), \
    $(eval PRODUCT_PACKAGES += \
        firmware_$(variant)_wlan_mac.bin_symlink \
        firmware_$(variant)_WCNSS_qcom_cfg.ini_symlink) \
)

$(foreach variant,$(TARGET_WIFI_VARIANTS), \
    $(eval PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/configs/wifi/$(variant)/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/$(variant)/WCNSS_qcom_cfg.ini) \
)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# Inherit from vendor blobs
$(call inherit-product, vendor/motorola/sm7435-common/sm7435-common-vendor.mk)

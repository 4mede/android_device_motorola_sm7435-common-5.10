#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups as base_lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/sm7435-common',
    'hardware/motorola',
    'hardware/qcom/display',
    'hardware/qcom/display/gralloc',
    'hardware/qcom/display/libdebug',
    'vendor/qcom/common/system/gps',
    'vendor/qcom/common/system/telephony',
    'vendor/qcom/common/vendor/adreno/s',
    'vendor/qcom/common/vendor/display/5.10',
    'vendor/qcom/common/vendor/media/5.10',
    'vendor/qcom/common/vendor/perf',
    'vendor/qcom/common/vendor/wlan',
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


def lib_fixup_moto_suffix(lib: str, *args, **kwargs):
    return f'{lib}_moto'


lib_fixups: lib_fixups_user_type = {
    **base_lib_fixups,
    'audio.primary.parrot': lib_fixup_moto_suffix,
    (
        'com.qualcomm.qti.dpm.api@1.0',
        'com.qualcomm.qti.imscmservice*',
        'com.qualcomm.qti.uceservice*',
        'vendor.qti.data.*',
        'vendor.qti.diaghal@1.0',
        'vendor.qti.hardware.data.*',
        'vendor.qti.hardware.data.connectionfactory-V1-ndk_platform',
        'vendor.qti.hardware.data.ka-V1-ndk_platform',
        'vendor.qti.hardware.data.dataactivity-V1-ndk_platform',
        'vendor.qti.hardware.dpmservice*',
        'vendor.qti.hardware.embmssl*',
        'vendor.qti.hardware.limits*',
        'vendor.qti.hardware.ListenSoundModel@1.0',
        'vendor.qti.hardware.mwqemadapter@1.0',
        'vendor.qti.hardware.qccsyshal*',
        'vendor.qti.hardware.qccvndhal@1.0',
        'vendor.qti.hardware.radio.*',
        'vendor.qti.hardware.radio.ims-V12-ndk_platform',
        'vendor.qti.hardware.radio.qtiradio-V8-ndk_platform',
        'vendor.qti.hardware.slmadapter@1.0',
        'vendor.qti.hardware.wifidisplaysession@1.0',
        'vendor.qti.imsrtpservice@3.0',
        'vendor.qti.ims.*',
        'vendor.qti.latency*',
    ): lib_fixup_vendor_suffix,
    'libqsap_sdk': lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/permissions/moto-telephony.xml': blob_fixup()
        .regex_replace('/system/', '/system_ext/'),
    'system_ext/etc/permissions/moto-ims-ext.xml': blob_fixup()
        .regex_replace('/system/', '/system_ext/'),
    'system_ext/lib64/libwfdnative.so': blob_fixup()
        .add_needed('libinput_shim.so'),
    'system_ext/priv-app/ims/ims.apk': blob_fixup()
        .apktool_patch('ims-patches'),
    ('vendor/bin/hw/android.hardware.security.keymint-service-qti','vendor/lib64/libqtikeymint.so',): blob_fixup()
        .replace_needed('android.hardware.security.keymint-V1-ndk_platform.so', 'android.hardware.security.keymint-V1-ndk.so')
        .replace_needed('android.hardware.security.secureclock-V1-ndk_platform.so','android.hardware.security.secureclock-V1-ndk.so')
        .replace_needed('android.hardware.security.sharedsecret-V1-ndk_platform.so', 'android.hardware.security.sharedsecret-V1-ndk.so')
        .add_needed('android.hardware.security.rkp-V1-ndk.so'),
    'vendor/bin/init.kernel.post_boot.sh': blob_fixup()
        .regex_replace('ro.boot.using_zram_from_fstab', 'ro.vendor.zram.swapon'),
    'vendor/etc/sensors/hals.conf': blob_fixup()
        .add_line_if_missing('sensors.moto_ext.so'),
    ('vendor/etc/media_codecs_parrot_v0.xml', 'vendor/etc/media_codecs_parrot_v1.xml',
        'vendor/etc/media_codecs_parrot_v2.xml', 'vendor/etc/media_codecs_ravelin.xml'): blob_fixup()
        .regex_replace('.*media_codecs_(google_audio|google_c2|google_telephony|google_video|vendor_audio|dolby_audio).*\n', ''),
    'vendor/etc/public.libraries.txt': blob_fixup()
        .regex_replace('libqti-perfd-client.so\n', ''),
    ('vendor/lib64/libgarden.so', 'vendor/lib64/libgarden_haltests_e2e.so'): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so')
        .replace_needed('vendor.qti.gnss-V3-ndk_platform.so','vendor.qti.gnss-V5-ndk_platform.so'),
    'vendor/lib64/sensors.moto.so': blob_fixup()
        .add_needed('libbase_shim.so'),
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libhidlbase_shim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'sm7435-common',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()

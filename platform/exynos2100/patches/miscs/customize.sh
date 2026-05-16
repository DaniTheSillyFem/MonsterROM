LOG "- Disabling encryption"
# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos2100")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2//g" "$WORK_DIR/vendor/etc/fstab.exynos2100"

LOG_STEP_IN "- Fixing vendor display props"
# DPI
LCD_DENSITY="$(GET_PROP "vendor" "ro.sf.lcd_density")"
if [ "$LCD_DENSITY" ]; then
    SET_PROP "vendor" "ro.sf.init.lcd_density" "$LCD_DENSITY"
else
    ABORT "ro.sf.lcd_density prop not found in vendor"
fi
LOG_STEP_OUT

LOG_STEP_IN "- Removing unsupported Qualcomm location/QCC stack"
GET_SYSTEM_EXT()
{
    if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
        echo "system_ext"
    else
        echo "system/system/system_ext"
    fi
}

_SED_DELETE_IF_EXISTS()
{
    [ -f "$1" ] || return 0
    sed -i "$2" "$1"
}

DELETE_FROM_WORK_DIR "system_ext" "priv-app/com.qualcomm.location"
DELETE_FROM_WORK_DIR "system_ext" "etc/permissions/com.qualcomm.location.xml"
DELETE_FROM_WORK_DIR "system_ext" "etc/permissions/privapp-permissions-com.qualcomm.location.xml"
DELETE_FROM_WORK_DIR "system_ext" "app/QCC"
DELETE_FROM_WORK_DIR "system_ext" "etc/permissions/com.qti.qcc.vendor_qcc.xml"
DELETE_FROM_WORK_DIR "system_ext" "bin/qccsyshal@1.2-service"
DELETE_FROM_WORK_DIR "system_ext" "bin/qccsyshal_aidl-service"
DELETE_FROM_WORK_DIR "system_ext" "etc/init/vendor.qti.hardware.qccsyshal@1.2-service.rc"
DELETE_FROM_WORK_DIR "system_ext" "etc/init/vendor.qti.qccsyshal_aidl-service.rc"
DELETE_FROM_WORK_DIR "system_ext" "etc/vintf/manifest/vendor.qti.qccsyshal_aidl-service.xml"
DELETE_FROM_WORK_DIR "system_ext" "lib64/libqcc.so"
DELETE_FROM_WORK_DIR "system_ext" "lib64/libqcc_file_agent_sys.so"
DELETE_FROM_WORK_DIR "system_ext" "lib64/libqccdme.so"
DELETE_FROM_WORK_DIR "system_ext" "lib64/libqccfileservice.so"

_SED_DELETE_IF_EXISTS "$WORK_DIR/$(GET_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml" "/com\.qualcomm\.location/d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/system/system/etc/sysconfig/qti_whitelist.xml" "/com\.qualcomm\.location/d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/system/system/etc/deviceidle/reviewed_allowlist.xml" "/com\.qualcomm\.location/d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/system/system/etc/permissions/platform.xml" "/com\.qualcomm\.location/d"

LOG_STEP_IN "- Removing invalid vendor property sets"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/build.prop" "/^\(net\.dns1\|net\.dns2\|persist\.demo\.hdmirotationlock\|ro\.em\.version\|vendor\.hwc\.exynos\.vsync_mode\|ro\.smps\.enable\|security\.securehw\.available\|security\.securenvm\.available\|ro\.apk_verity\.mode\)=/d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop persist\.rmnet\.mux /d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop persist\.rmnet\.data\.enable /d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop persist\.data\.wda\.enable /d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop persist\.data\.df\.agg\.dl_pkt /d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop persist\.data\.df\.agg\.dl_size /d"
_SED_DELETE_IF_EXISTS "$WORK_DIR/vendor/etc/init/init.exynos2100.rc" "/setprop ro\.crypto\.fuse_sdcard /d"
LOG_STEP_OUT

unset -f GET_SYSTEM_EXT _SED_DELETE_IF_EXISTS
LOG_STEP_OUT

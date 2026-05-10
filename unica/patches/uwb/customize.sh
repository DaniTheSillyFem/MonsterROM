SOURCE_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$SOURCE_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$SOURCE_FIRMWARE")"
TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

SOURCE_HAS_UWB="$(test -f "$FW_DIR/$SOURCE_FIRMWARE_PATH/vendor/etc/permissions/android.hardware.uwb.xml" && echo "true" || echo "false")"
TARGET_HAS_UWB="$(test -f "$FW_DIR/$TARGET_FIRMWARE_PATH/vendor/etc/permissions/android.hardware.uwb.xml" && echo "true" || echo "false")"

# [
ADD_TARGET_UWB_FILE()
{
    local FILE="$1"
    local LABEL="${2:-u:object_r:system_file:s0}"

    if [ -f "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/$FILE" ]; then
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/$FILE" 0 0 644 "$LABEL"
    fi
}

REMOVE_UWB_STACK()
{
    DELETE_FROM_WORK_DIR "product" "overlay/UwbRROverlay.apk"
    DELETE_FROM_WORK_DIR "system" "system/app/UwbTest"
    DELETE_FROM_WORK_DIR "system" "system/etc/init/init.system.uwb.rc"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.samsung.android.uwb_extras.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/org.carconnectivity.android.digitalkey.timesync.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.dcktimesync.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.sec.android.app.uwbtest.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/libuwb-cal.conf"
    DELETE_FROM_WORK_DIR "system" "system/etc/pp_model.tflite"
    DELETE_FROM_WORK_DIR "system" "system/framework/com.samsung.android.uwb_extras.jar"
    DELETE_FROM_WORK_DIR "system" "system/framework/semuwb-service.jar"
    DELETE_FROM_WORK_DIR "system" "system/lib/libtflite_uwb_jni.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/libtflite_uwb_jni.so"
    DELETE_FROM_WORK_DIR "system_ext" "framework/org.carconnectivity.android.digitalkey.timesync.jar"
    DELETE_FROM_WORK_DIR "system_ext" "priv-app/DckTimeSyncService"
}
# ]

if $TARGET_HAS_UWB; then
    LOG_STEP_IN "- Syncing target UWB config"
    ADD_TARGET_UWB_FILE "etc/libuwb-cal.conf"
    ADD_TARGET_UWB_FILE "etc/pp_model.tflite"

    if ! $SOURCE_HAS_UWB; then
        LOG "- Adding S24+ (e2sxxx) UWB userspace blobs"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/app/UwbTest"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/etc/init/init.system.uwb.rc"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/etc/permissions/com.samsung.android.uwb_extras.xml"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/framework/com.samsung.android.uwb_extras.jar"
        ADD_TO_WORK_DIR "e2sxxx" "system" "system/lib64/libtflite_uwb_jni.so"
    fi
    LOG_STEP_OUT
else
    if $SOURCE_HAS_UWB; then
        LOG_STEP_IN "- Removing source UWB stack for non-UWB target"
        REMOVE_UWB_STACK
        if [ -f "$WORK_DIR/product/etc/build.prop" ]; then
            sed -i "/^ro.boot.uwbcountrycode=/d" "$WORK_DIR/product/etc/build.prop"
        fi
        LOG_STEP_OUT
    else
        LOG "\033[0;33m! Nothing to do\033[0m"
    fi
fi

unset SOURCE_FIRMWARE_PATH TARGET_FIRMWARE_PATH SOURCE_HAS_UWB TARGET_HAS_UWB
unset -f ADD_TARGET_UWB_FILE REMOVE_UWB_STACK

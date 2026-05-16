SOURCE_MODEL=$(echo -n "$SOURCE_FIRMWARE" | cut -d "/" -f 1)
SOURCE_REGION=$(echo -n "$SOURCE_FIRMWARE" | cut -d "/" -f 2)
MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

SPEN_SOURCE=""
if [ -d "$FW_DIR/${SOURCE_MODEL}_${SOURCE_REGION}/system/system/media/audio/pensounds" ]; then
    SPEN_SOURCE="$SOURCE_FIRMWARE"
elif [ -d "$FW_DIR/${MODEL}_${REGION}/system/system/media/audio/pensounds" ]; then
    SPEN_SOURCE="$TARGET_FIRMWARE"
fi

if [ "$SPEN_SOURCE" ]; then
    LOG_STEP_IN "- Adding SPen stack"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/permissions/com.sec.feature.spen_usp_level70.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/public.libraries-smps.samsung.txt"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/etc/sysconfig/airviewdictionaryservice.xml"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/lib64/libsmpsft.smps.samsung.so"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/media/audio/pensounds"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/priv-app/AirCommand"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/priv-app/AirReadingGlass"
    ADD_TO_WORK_DIR "$SPEN_SOURCE" "system" "system/priv-app/SmartEye"
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_SPEN_SENSITIVITY_ADJUSTMENT" "900"
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_GARAGE_SPEC" "type=insert, bundled=true"
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_VERSION" "70"
    LOG_STEP_OUT
else
    LOG "- SPen support not detected in target device. Ignoring."
fi

unset SOURCE_MODEL SOURCE_REGION MODEL REGION SPEN_SOURCE

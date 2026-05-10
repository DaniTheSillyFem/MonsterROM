if [[ "$SOURCE_BOARD_API_LEVEL" == "$TARGET_BOARD_API_LEVEL" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

# [
TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

TARGET_FIRMWARE_HAS_SYSTEM_EXT_FILE()
{
    local FILE="$1"

    [ -e "$FW_DIR/$TARGET_FIRMWARE_PATH/system_ext/$FILE" ] || \
        [ -e "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/system_ext/$FILE" ] || \
        [ -e "$FW_DIR/$TARGET_FIRMWARE_PATH/system/system_ext/$FILE" ]
}

ADD_TARGET_VNDK_APEX() {
    local APEX="apex/com.android.vndk.v$TARGET_BOARD_API_LEVEL.apex"

    if TARGET_FIRMWARE_HAS_SYSTEM_EXT_FILE "$APEX"; then
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "$APEX" 0 0 644 "u:object_r:system_file:s0"
        return $?
    fi

    case "$TARGET_BOARD_API_LEVEL" in
        "30")
            ADD_TO_WORK_DIR "a73xqxx" "system_ext" "apex/com.android.vndk.v30.apex" 0 0 644 "u:object_r:system_file:s0"
            ;;
        *)
            ABORT "No target firmware or prebuilt APEX available for VNDK $TARGET_BOARD_API_LEVEL"
            ;;
    esac
}
# ]

if $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
    SYS_EXT_DIR="$WORK_DIR/system_ext"
else
    SYS_EXT_DIR="$WORK_DIR/system/system/system_ext"
fi

if [ "$SOURCE_BOARD_API_LEVEL" -gt "34" ] && [ "$TARGET_BOARD_API_LEVEL" -gt "34" ]; then
    :
elif [ "$SOURCE_BOARD_API_LEVEL" -gt "34" ] && [ "$TARGET_BOARD_API_LEVEL" -le "34" ]; then
    ADD_TARGET_VNDK_APEX
    LOG "- Patching ${SYS_EXT_DIR//$WORK_DIR/}/etc/vintf/manifest.xml"
    EVAL "sed -i \"\\\$d\" \"$SYS_EXT_DIR/etc/vintf/manifest.xml\""
    {
        echo "    <vendor-ndk>"
        echo "        <version>$TARGET_BOARD_API_LEVEL</version>"
        echo "    </vendor-ndk>"
        echo "</manifest>"
    } >> "$SYS_EXT_DIR/etc/vintf/manifest.xml"
elif [ "$SOURCE_BOARD_API_LEVEL" -le "34" ] && [ "$TARGET_BOARD_API_LEVEL" -gt "34" ]; then
    DELETE_FROM_WORK_DIR "system_ext" "apex/com.android.vndk.v$SOURCE_BOARD_API_LEVEL.apex"
    LOG "- Patching ${SYS_EXT_DIR//$WORK_DIR/}/etc/vintf/manifest.xml"
    EVAL "sed -i -e \"/vendor-ndk/d\" -e \"/version>/d\" \"$SYS_EXT_DIR/etc/vintf/manifest.xml\""
elif [ ! -f "$SYS_EXT_DIR/apex/com.android.vndk.v$TARGET_BOARD_API_LEVEL.apex" ]; then
    DELETE_FROM_WORK_DIR "system_ext" "apex/com.android.vndk.v$SOURCE_BOARD_API_LEVEL.apex"
    ADD_TARGET_VNDK_APEX
    LOG "- Patching ${SYS_EXT_DIR//$WORK_DIR/}/etc/vintf/manifest.xml"
    EVAL "sed -i \"s/version>$SOURCE_BOARD_API_LEVEL/version>$TARGET_BOARD_API_LEVEL/g\" \"$SYS_EXT_DIR/etc/vintf/manifest.xml\""
fi

unset TARGET_FIRMWARE_PATH SYS_EXT_DIR
unset -f TARGET_FIRMWARE_HAS_SYSTEM_EXT_FILE ADD_TARGET_VNDK_APEX

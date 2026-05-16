_LOG() { if $DEBUG; then LOGW "$1"; else ABORT "$1"; fi }

ENSURE_FRAMEWORK_SYSTEM_SDK()
{
    local MANIFEST="$WORK_DIR/system/system/etc/vintf/manifest.xml"
    local CONFIG_SDK="$SOURCE_PLATFORM_SDK_VERSION"
    local PROP_SDK
    local SDK
    local TMP

    if [ ! -f "$MANIFEST" ]; then
        return 0
    fi

    PROP_SDK="$(GET_PROP "system" "ro.build.version.sdk")"
    SDK="$CONFIG_SDK"
    if [[ "$PROP_SDK" =~ ^[0-9]+$ ]] && {
        [ ! "$SDK" ] || [ "$PROP_SDK" -gt "$SDK" ]
    }; then
        SDK="$PROP_SDK"
    fi

    if ! [[ "$SDK" =~ ^[0-9]+$ ]]; then
        return 0
    fi

    # libvintf rejects boot when ro.build.version.sdk is newer than framework manifest system-sdk.
    if sed -n '/<system-sdk>/,/<\/system-sdk>/p' "$MANIFEST" | grep -q "<version>$SDK</version>"; then
        return 0
    fi

    LOG "- Adding system SDK $SDK to ${MANIFEST//$WORK_DIR/}"
    TMP="$(mktemp)"
    if grep -q "<system-sdk>" "$MANIFEST"; then
        awk -v sdk="$SDK" '
            /<\/system-sdk>/ && !done {
                print "        <version>" sdk "</version>"
                done = 1
            }
            { print }
        ' "$MANIFEST" > "$TMP"
    else
        awk -v sdk="$SDK" '
            /<\/manifest>/ && !done {
                print "    <system-sdk>"
                print "        <version>" sdk "</version>"
                print "    </system-sdk>"
                done = 1
            }
            { print }
        ' "$MANIFEST" > "$TMP"
    fi

    EVAL "mv -f \"$TMP\" \"$MANIFEST\""
}

if [ -f "$SRC_DIR/target/$TARGET_CODENAME/vintf/compatibility_matrix.device.xml" ]; then
    LOG "- Adding /system/system/etc/vintf/compatibility_matrix.device.xml"
    EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/vintf/compatibility_matrix.device.xml\" \"$WORK_DIR/system/system/etc/vintf/compatibility_matrix.device.xml\""
elif [[ "$SOURCE_PLATFORM_SDK_VERSION" == "$TARGET_PLATFORM_SDK_VERSION" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/vintf/compatibility_matrix.device.xml"
else
    _LOG "File not found: $SRC_DIR/target/$TARGET_CODENAME/vintf/compatibility_matrix.device.xml"
fi

if [ -f "$SRC_DIR/target/$TARGET_CODENAME/vintf/manifest.xml" ]; then
    LOG "- Adding /system/system/etc/vintf/manifest.xml"
    EVAL "cp -a \"$SRC_DIR/target/$TARGET_CODENAME/vintf/manifest.xml\" \"$WORK_DIR/system/system/etc/vintf/manifest.xml\""
elif [[ "$SOURCE_PLATFORM_SDK_VERSION" == "$TARGET_PLATFORM_SDK_VERSION" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/vintf/manifest.xml"
else
    LOG "- Target has no Vendor interface objects blobs change needed . Ignoring."
fi

ENSURE_FRAMEWORK_SYSTEM_SDK

unset -f _LOG ENSURE_FRAMEWORK_SYSTEM_SDK

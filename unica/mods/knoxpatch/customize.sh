# Nuke WSM
DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-wsm.samsung.txt"
DELETE_FROM_WORK_DIR "system" "system/lib/libhal.wsm.samsung.so"
DELETE_FROM_WORK_DIR "system" "system/lib/vendor.samsung.hardware.security.wsm.service-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhal.wsm.samsung.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.wsm.service-V1-ndk.so"

_FIND_DECODED_SMALI()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATTERN="$3"
    local FILE_PATH

    if ! DECODE_APK "$PARTITION" "$FILE" >&2; then
        return 0
    fi
    FILE_PATH="$APKTOOL_DIR/$PARTITION/${FILE//system\//}"
    find "$FILE_PATH" -type f -path "$PATTERN" | sort | head -n 1
}

_REL_SMALI()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATH="$3"
    local FILE_PATH="$APKTOOL_DIR/$PARTITION/${FILE//system\//}"

    echo "${PATH#$FILE_PATH/}"
}

_PATCH_AFTER_ONCE()
{
    local FILE="$1"
    local NEEDLE="$2"
    local INSERT="$3"
    local MARKER="$4"

    if grep -q -F "$MARKER" "$FILE"; then
        return 0
    fi

    NEEDLE="$NEEDLE" INSERT="$INSERT" perl -0pi -e '
        my $needle = $ENV{"NEEDLE"};
        my $insert = $ENV{"INSERT"};
        my $done = 0;
        s{(\Q$needle\E\n)}{if ($done) { $& } else { $done = 1; $1."\n".$insert."\n" }}e;
    ' "$FILE"

    grep -q -F "$MARKER" "$FILE" || ABORT "Failed to patch ${FILE//$APKTOOL_DIR\//}"
}

_PATCH_BEFORE_ONCE()
{
    local FILE="$1"
    local NEEDLE="$2"
    local INSERT="$3"
    local MARKER="$4"

    if grep -q -F "$MARKER" "$FILE"; then
        return 0
    fi

    NEEDLE="$NEEDLE" INSERT="$INSERT" perl -0pi -e '
        my $needle = $ENV{"NEEDLE"};
        my $insert = $ENV{"INSERT"};
        my $done = 0;
        s{(\Q$needle\E)}{if ($done) { $& } else { $done = 1; $insert."\n\n".$1 }}e;
    ' "$FILE"

    grep -q -F "$MARKER" "$FILE" || ABORT "Failed to patch ${FILE//$APKTOOL_DIR\//}"
}

_FORCE_BOOL_FIELD_ONCE()
{
    local FILE="$1"
    local FIELD="$2"
    local MARKER="$3"

    if grep -q -F "$MARKER" "$FILE"; then
        return 0
    fi

    FIELD="$FIELD" MARKER="$MARKER" perl -0pi -e '
        my $field = $ENV{"FIELD"};
        my $marker = $ENV{"MARKER"};
        my $done = 0;
        s{(^[ \t]*iget-boolean ([vp]\d+), [^\n]+, \Q$field\E[ \t]*\n)}
         {if ($done) { $& } else { $done = 1; $1."\n    # ".$marker."\n    const/4 ".$2.", 0x1\n" }}egm;
    ' "$FILE"

    grep -q -F "$MARKER" "$FILE" || ABORT "Failed to patch ${FILE//$APKTOOL_DIR\//}"
}

_PATCH_SYSTEM_PROPERTIES_GETS()
{
    local FILE="$1"

    if grep -q -F "KnoxPatch: spoof SystemProperties.get(String)" "$FILE" \
        && grep -q -F "KnoxPatch: spoof SystemProperties.get(String, String)" "$FILE"; then
        return 0
    fi

    perl -0pi -e '
        s{
            (\.method\ public\ static[^\n]*\ get\(Ljava/lang/String;\)Ljava/lang/String;\n)
            [ \t]+\.locals\ \d+\n
            (\s+\.annotation\ runtime\ Landroid/annotation/SystemApi;\n\s+\.end\ annotation\n\n)
            \s+invoke-static\ \{p0\},\ Landroid/os/SystemProperties;->native_get\(Ljava/lang/String;\)Ljava/lang/String;\n\n
            \s+move-result-object\ p0\n\n
            \s+return-object\ p0\n
            \.end\ method
        }{$1    .locals 1\n$2    invoke-static {p0}, Lio/mesalabs/unica/KnoxPatchHooks;->onSystemPropertiesGet(Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object v0\n\n    # KnoxPatch: spoof SystemProperties.get(String)\n    if-eqz v0, :cond_knoxpatch_get\n\n    return-object v0\n\n    :cond_knoxpatch_get\n    invoke-static {p0}, Landroid/os/SystemProperties;->native_get(Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object p0\n\n    return-object p0\n.end method}x;

        s{
            (\.method\ public\ static[^\n]*\ get\(Ljava/lang/String;Ljava/lang/String;\)Ljava/lang/String;\n)
            [ \t]+\.locals\ \d+\n
            (\s+\.annotation\ runtime\ Landroid/annotation/SystemApi;\n\s+\.end\ annotation\n\n)
            \s+invoke-static\ \{p0,\ p1\},\ Landroid/os/SystemProperties;->native_get\(Ljava/lang/String;Ljava/lang/String;\)Ljava/lang/String;\n\n
            \s+move-result-object\ p0\n\n
            \s+return-object\ p0\n
            \.end\ method
        }{$1    .locals 1\n$2    invoke-static {p0}, Lio/mesalabs/unica/KnoxPatchHooks;->onSystemPropertiesGet(Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object v0\n\n    # KnoxPatch: spoof SystemProperties.get(String, String)\n    if-eqz v0, :cond_knoxpatch_get_default\n\n    return-object v0\n\n    :cond_knoxpatch_get_default\n    invoke-static {p0, p1}, Landroid/os/SystemProperties;->native_get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object p0\n\n    return-object p0\n.end method}x;
    ' "$FILE"

    grep -q -F "KnoxPatch: spoof SystemProperties.get(String)" "$FILE" \
        || ABORT "Failed to patch ${FILE//$APKTOOL_DIR\//}"
    grep -q -F "KnoxPatch: spoof SystemProperties.get(String, String)" "$FILE" \
        || ABORT "Failed to patch ${FILE//$APKTOOL_DIR\//}"
}

_RETURN_IF_METHOD_EXISTS()
{
    local PARTITION="$1"
    local FILE="$2"
    local SMALI="$3"
    local METHOD="$4"
    local VALUE="$5"
    local FILE_PATH="$APKTOOL_DIR/$PARTITION/${FILE//system\//}/$SMALI"

    if [ ! -f "$FILE_PATH" ]; then
        LOG "\033[0;33m! Smali not found, skipping KnoxPatch hook: /$PARTITION/$FILE/$SMALI\033[0m"
        return 0
    fi

    if ! grep "^\.method.*" "$FILE_PATH" | grep -q -F -- "$METHOD"; then
        LOG "\033[0;33m! Method not found, skipping KnoxPatch hook: $METHOD\033[0m"
        return 0
    fi

    SMALI_PATCH "$PARTITION" "$FILE" "$SMALI" "return" "$METHOD" "$VALUE"
}

# Add KnoxPatchHooks
APPLY_PATCH "system" "system/framework/framework.jar" \
    "$MODPATH/framework.jar/0001-Introduce-KnoxPatchHooks.patch"
SMALI_PATCH "system" "system/framework/framework.jar" \
    "smali/android/app/Instrumentation.smali" "replace" \
    'newApplication(Ljava/lang/Class;Landroid/content/Context;)Landroid/app/Application;' \
    'return-object p0' \
    '    invoke-static {p1}, Lio/mesalabs/unica/KnoxPatchHooks;->init(Landroid/content/Context;)V\n\n    return-object p0' \
    > /dev/null
SMALI_PATCH "system" "system/framework/framework.jar" \
    "smali/android/app/Instrumentation.smali" "replace" \
    'newApplication(Ljava/lang/ClassLoader;Ljava/lang/String;Landroid/content/Context;)Landroid/app/Application;' \
    'return-object p0' \
    '    invoke-static {p3}, Lio/mesalabs/unica/KnoxPatchHooks;->init(Landroid/content/Context;)V\n\n    return-object p0' \
    > /dev/null
SYSTEM_PROPERTIES_PATH="$(_FIND_DECODED_SMALI "system" "system/framework/framework.jar" "*/android/os/SystemProperties.smali")"
if [ "$SYSTEM_PROPERTIES_PATH" ]; then
    _PATCH_SYSTEM_PROPERTIES_GETS "$SYSTEM_PROPERTIES_PATH"
else
    ABORT "SystemProperties.smali not found in framework.jar"
fi
ENTERPRISE_DEVICE_MANAGER_PATH="$(_FIND_DECODED_SMALI "system" "system/framework/knoxsdk.jar" "*/com/samsung/android/knox/EnterpriseDeviceManager.smali")"
if [ "$ENTERPRISE_DEVICE_MANAGER_PATH" ]; then
    if ! grep -q -F "Lio/mesalabs/unica/KnoxPatchHooks;->onEDMGetAPILevel()I" "$ENTERPRISE_DEVICE_MANAGER_PATH"; then
        SMALI_PATCH "system" "system/framework/knoxsdk.jar" \
            "$(_REL_SMALI "system" "system/framework/knoxsdk.jar" "$ENTERPRISE_DEVICE_MANAGER_PATH")" "replace" \
            'getAPILevel()I' \
            'invoke-static {}, Lcom/samsung/android/knox/EdmUtils;->getAPILevelForInternal()I' \
            'invoke-static {}, Lio/mesalabs/unica/KnoxPatchHooks;->onEDMGetAPILevel()I'
    fi
else
    ABORT "EnterpriseDeviceManager.smali not found in knoxsdk.jar"
fi

# Bypass ICD verification
SAMSUNG_KEYSTORE_ATTEST_PATH="$(_FIND_DECODED_SMALI "system" "system/framework/samsungkeystoreutils.jar" "*/com/samsung/android/security/keystore/AttestParameterSpec.smali")"
if [ "$SAMSUNG_KEYSTORE_ATTEST_PATH" ]; then
    _RETURN_IF_METHOD_EXISTS "system" "system/framework/samsungkeystoreutils.jar" \
        "$(_REL_SMALI "system" "system/framework/samsungkeystoreutils.jar" "$SAMSUNG_KEYSTORE_ATTEST_PATH")" \
        'isVerifiableIntegrity()Z' 'true'
fi

SERVICES_ATTEST_UTILS_PATH="$(_FIND_DECODED_SMALI "system" "system/framework/services.jar" "*/com/samsung/android/security/keystore/AttestationUtils.smali")"
if [ "$SERVICES_ATTEST_UTILS_PATH" ]; then
    _FORCE_BOOL_FIELD_ONCE "$SERVICES_ATTEST_UTILS_PATH" \
        'Lcom/samsung/android/security/keystore/AttestParameterSpec;->mVerifiableIntegrity:Z' \
        'KnoxPatch: force verifiable integrity'

    _FORCE_BOOL_FIELD_ONCE "$SERVICES_ATTEST_UTILS_PATH" \
        'Lcom/samsung/android/security/keystore/AttestParameterSpec;->mSAKUidRequired:Z' \
        'KnoxPatch: force SAK UID'
fi

# Disable SAK in DarManagerService
DAR_MANAGER_PATH="$(_FIND_DECODED_SMALI "system" "system/framework/services.jar" "*/com/android/server/knox/dar/DarManagerService.smali")"
if [ "$DAR_MANAGER_PATH" ]; then
    DAR_MANAGER_SMALI="$(_REL_SMALI "system" "system/framework/services.jar" "$DAR_MANAGER_PATH")"
    _RETURN_IF_METHOD_EXISTS "system" "system/framework/services.jar" "$DAR_MANAGER_SMALI" \
        'checkDeviceIntegrity([Ljava/security/cert/Certificate;)Z' 'true'
    _RETURN_IF_METHOD_EXISTS "system" "system/framework/services.jar" "$DAR_MANAGER_SMALI" \
        'isDeviceRootKeyInstalled()Z' 'true'
    _RETURN_IF_METHOD_EXISTS "system" "system/framework/services.jar" "$DAR_MANAGER_SMALI" \
        'isKnoxKeyInstallable()Z' 'true'
else
    ABORT "DarManagerService.smali not found in services.jar"
fi

# Disable root checks in StorageManagerService
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/StorageManagerService.smali" "return" \
    'isRootedDevice()Z' 'false'

# Spoof ROT/IntegrityStatus in Knox Matrix
if [ -d "$WORK_DIR/system/system/priv-app/KmxService" ]; then
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/common/util/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/common/util/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/sdk/trustchain/util/RootOfTrust.smali" "return" \
        'getVerifiedBootState()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/sdk/trustchain/util/RootOfTrust.smali" "return" \
        'isDeviceLocked()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/common/util/IntegrityStatus.smali" "return" \
        'getStatus()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/common/util/IntegrityStatus.smali" "return" \
        'isNormal()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/fabrickeystore/keystore/cert/IntegrityStatus.smali" "return" \
        'isNormal()Z' 'true'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/sdk/trustchain/util/IntegrityStatus.smali" "return" \
        'getStatus()I' '0'
    SMALI_PATCH "system" "system/priv-app/KmxService/KmxService.apk" \
        "smali_classes2/com/samsung/android/kmxservice/sdk/trustchain/util/IntegrityStatus.smali" "return" \
        'isNormal()Z' 'true'
else
    LOG "\033[0;33m! KmxService removed by deknox, skipping Knox Matrix spoof hooks\033[0m"
fi

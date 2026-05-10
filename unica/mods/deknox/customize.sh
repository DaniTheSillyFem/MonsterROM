# KnoxGuard
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxGuard"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml"

# DualDAR
DELETE_FROM_WORK_DIR "system" "system/bin/dualdard"
DELETE_FROM_WORK_DIR "system" "system/etc/init/dualdard.rc"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libdualdar.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/aidl_comm_ddar_client.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.ddar-V1-ndk.so"

# Blockchain
DELETE_FROM_WORK_DIR "system" "system/app/BlockchainBasicKit"
DELETE_FROM_WORK_DIR "system" "system/framework/service-samsung-blockchain.jar"
DELETE_FROM_WORK_DIR "system" "system/etc/sysconfig/preinstalled-packages-com.samsung.android.coldwalletservice.xml"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_comm.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_keystore.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_direct_comm.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.blockchain@1.0.so"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete

# Payment
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_direct_comm.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_spay.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_comm.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.payment@1.0.so"

# MPOS
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.mpos.xml"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libhidl_comm_mpos_tui_client.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.mpos-V1-ndk.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.mpos_tui@1.0.so"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxMposAgent"

# eSE COS
DELETE_FROM_WORK_DIR "system" "system/bin/sem_daemon"
DELETE_FROM_WORK_DIR "system" "system/etc/init/sem_early.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.sem.factoryapp.xml"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_sem.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semAidl.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semRil.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semTlc.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/libspictrl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.sem-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/priv-app/SEMFactoryApp"

# Weaver
# DELETE_FROM_WORK_DIR "system" "system/lib64/libhermes_cred.so"
# DELETE_FROM_WORK_DIR "system" "system/lib64/android.hardware.weaver-V2-ndk.so"

# HDM
DELETE_FROM_WORK_DIR "system" "system/priv-app/HdmApk"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.hdmapp.xml"

# WSM
DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-wsm.samsung.txt"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhal.wsm.samsung.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.wsm.service-V1-ndk.so"

# Knox ZeroTrust
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.zt.framework.xml"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxZtFramework"

# Knox Matrix
DELETE_FROM_WORK_DIR "system" "system/bin/fabric_crypto"
DELETE_FROM_WORK_DIR "system" "system/etc/init/fabric_crypto.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/FabricCryptoLib.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.kmxservice.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/vintf/manifest/fabric_crypto_manifest.xml"
DELETE_FROM_WORK_DIR "system" "system/framework/FabricCryptoLib.jar"
DELETE_FROM_WORK_DIR "system" "system/lib64/com.samsung.security.fabric.cryptod-V1-cpp.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.fkeymaster-V1-cpp.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.fkeymaster-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KmxService"

# Other Knox APKs
DELETE_FROM_WORK_DIR "system" "system/priv-app/KPECore"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxCore"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxERAgent"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxFrameBufferProvider"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxNetworkFilter"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxNeuralNetworkRuntime"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxPushManager"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxSandbox"
DELETE_FROM_WORK_DIR "system" "system/priv-app/knoxanalyticsagent"
DELETE_FROM_WORK_DIR "system" "system/priv-app/knoxvpnproxyhandler"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.knox.vpn.proxyhandler.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.analytics.uploader.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.app.networkfilter.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.er.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.kfbp.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.knnr.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.kpecore.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.pushmanager.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.sandbox.xml"

_DEKNOX_FIND_SMALI()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATTERN="$3"
    local FILE_PATH

    if ! DECODE_APK "$PARTITION" "$FILE" >&2; then
        return 0
    fi

    FILE_PATH="$APKTOOL_DIR/$PARTITION/${FILE//system\//}"
    find "$FILE_PATH" -type f -path "$PATTERN" | sort
}

_DEKNOX_REL_SMALI()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATH="$3"
    local FILE_PATH="$APKTOOL_DIR/$PARTITION/${FILE//system\//}"

    echo "${PATH#$FILE_PATH/}"
}

_DEKNOX_RETURN_OPTIONAL()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATTERN="$3"
    local METHOD="$4"
    local VALUE="$5"
    local FOUND=false
    local SMALI_PATH

    while IFS= read -r SMALI_PATH; do
        [ "$SMALI_PATH" ] || continue
        FOUND=true
        if grep "^\.method.*" "$SMALI_PATH" | grep -q -F -- "$METHOD"; then
            SMALI_PATCH "$PARTITION" "$FILE" \
                "$(_DEKNOX_REL_SMALI "$PARTITION" "$FILE" "$SMALI_PATH")" \
                "return" "$METHOD" "$VALUE"
        else
            LOG "\033[0;33m! Method not found, skipping deknox hook: $METHOD\033[0m"
        fi
    done < <(_DEKNOX_FIND_SMALI "$PARTITION" "$FILE" "$PATTERN")

    $FOUND || LOG "\033[0;33m! Smali not found, skipping deknox hook: $PATTERN\033[0m"
}

_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL()
{
    local PARTITION="$1"
    local FILE="$2"
    local PATTERN="$3"
    local METHOD="$4"
    local FOUND=false
    local SMALI_PATH

    while IFS= read -r SMALI_PATH; do
        [ "$SMALI_PATH" ] || continue
        FOUND=true
        if grep "^\.method.*" "$SMALI_PATH" | grep -q -F -- "$METHOD"; then
            local DECL
            local LOC=".locals 0"
            local REG="p0"

            DECL="$(grep "^\.method.*" "$SMALI_PATH" | grep -F -- "$METHOD" | head -n 1)"
            if [[ "$DECL" == *" static "* ]] && [[ "$METHOD" == *"()"* ]]; then
                LOC=".locals 1"
                REG="v0"
            fi

            LOG "- Replacing return value of method \"$METHOD\" in ${SMALI_PATH//$APKTOOL_DIR\//} to empty string"
            awk -v FN="$METHOD" -v LOC="$LOC" -v REG="$REG" '
                BEGIN { inside = 0 }
                /^\.method/ && index($0, FN) {
                    print
                    print "    " LOC
                    print ""
                    print "    const-string " REG ", \"\""
                    print ""
                    print "    return-object " REG
                    inside = 1
                    next
                }
                inside && /^\.end method/ {
                    print
                    inside = 0
                    next
                }
                inside { next }
                { print }
            ' "$SMALI_PATH" > "$SMALI_PATH.tmp" && mv "$SMALI_PATH.tmp" "$SMALI_PATH"
        else
            LOG "\033[0;33m! Method not found, skipping deknox hook: $METHOD\033[0m"
        fi
    done < <(_DEKNOX_FIND_SMALI "$PARTITION" "$FILE" "$PATTERN")

    $FOUND || LOG "\033[0;33m! Smali not found, skipping deknox hook: $PATTERN\033[0m"
}

_DEKNOX_PATCH_FILE_ONCE()
{
    local FILE="$1"
    local MARKER="$2"
    local SCRIPT="$3"
    local BEFORE
    local AFTER

    if ! grep -q -F "$MARKER" "$FILE"; then
        return 0
    fi

    BEFORE="$(sha1sum "$FILE")"
    perl -0pi -e "$SCRIPT" "$FILE"
    AFTER="$(sha1sum "$FILE")"

    if [[ "$BEFORE" == "$AFTER" ]]; then
        LOG "\033[0;33m! Deknox marker found but no change made in ${FILE//$APKTOOL_DIR\//}: $MARKER\033[0m"
    fi
}

LOG_STEP_IN "- Applying One UI 8.5 Knox service guards"
DECODE_APK "system" "system/framework/services.jar"
SERVICES_JAR_DIR="$APKTOOL_DIR/system/framework/services.jar"
SYSTEMSERVER_KNOX_LAMBDA="$SERVICES_JAR_DIR/smali/com/android/server/SystemServer\$\$ExternalSyntheticLambda10.smali"
SYSTEMSERVER_SMALI="$SERVICES_JAR_DIR/smali/com/android/server/SystemServer.smali"
EDM_SERVICE_IMPL="$SERVICES_JAR_DIR/smali/com/android/server/enterprise/EnterpriseDeviceManagerServiceImpl.smali"

if [ -f "$SYSTEMSERVER_KNOX_LAMBDA" ]; then
    _DEKNOX_PATCH_FILE_ONCE "$SYSTEMSERVER_KNOX_LAMBDA" "SemService" \
        's{\n[ \t]*const-string(?:/jumbo)? [vp]\d+, "SemService"\n.*?invoke-virtual \{[vp]\d+\}, Landroid/util/TimingsTraceLog;->traceEnd\(\)V\n}{}sg;'
    _DEKNOX_PATCH_FILE_ONCE "$SYSTEMSERVER_KNOX_LAMBDA" "Blockchain Service" \
        's{\n[ \t]*const-string(?:/jumbo)? [vp]\d+, "Blockchain Service"\n.*?invoke-virtual \{[vp]\d+\}, Landroid/util/TimingsTraceLog;->traceEnd\(\)V\n}{}sg;'
    _DEKNOX_PATCH_FILE_ONCE "$SYSTEMSERVER_KNOX_LAMBDA" "MPOS Service" \
        's{\n[ \t]*const-string(?:/jumbo)? [vp]\d+, "MPOS Service"\n.*?invoke-virtual \{[vp]\d+\}, Landroid/util/TimingsTraceLog;->traceEnd\(\)V\n}{}sg;'
fi

if [ -f "$SYSTEMSERVER_SMALI" ]; then
    _DEKNOX_PATCH_FILE_ONCE "$SYSTEMSERVER_SMALI" "StartKnoxGuard" \
        's{invoke-static \{\}, Landroid/os/FactoryTest;->isFactoryBinary\(\)Z\n\n[ \t]*move-result v0\n\n[ \t]*if-nez v0, (:cond_[0-9a-f]+)}{goto $1}sg;'
fi

if [ -f "$EDM_SERVICE_IMPL" ]; then
    _DEKNOX_PATCH_FILE_ONCE "$EDM_SERVICE_IMPL" "hdm_service" \
        's{\n[ \t]*new-instance ([vp]\d+), Lcom/android/server/enterprise/hdm/HdmService;.*?invoke-static \{\1, [vp]\d+\}, Lcom/android/server/enterprise/EnterpriseDeviceManagerServiceImpl\$Injector;->addLazySystemService\(Lcom/android/server/enterprise/EnterpriseServiceCallback;Ljava/lang/String;\)V\n}{}sg;'
fi
LOG_STEP_OUT

LOG_STEP_IN "- Nuking Knox version strings"
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/framework/knoxsdk.jar" \
    "*/com/samsung/android/knox/ddar/DualDARPolicy.smali" \
    'getDualDARVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/framework/knoxsdk.jar" \
    "*/com/samsung/android/knox/hdm/HdmManager.smali" \
    'getHdmVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "*/com/samsung/android/knox/ddar/DualDARPolicy.smali" \
    'getDualDARVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "*/com/samsung/android/knox/hdm/HdmManager.smali" \
    'getHdmVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "*/com/samsung/android/settings/deviceinfo/softwareinfo/SecuritySoftwareVersionPreferenceController.smali" \
    'getESECOSValue()Ljava/lang/String;'
_DEKNOX_RETURN_OPTIONAL "system" "system/priv-app/SecSettings/SecSettings.apk" \
    "*/com/samsung/android/settings/deviceinfo/softwareinfo/KnoxVersionPreferenceController.smali" \
    'getAvailabilityStatus()I' '0x3'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "*/com/samsung/android/knox/ddar/DualDARPolicy.smali" \
    'getDualDARVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system" "system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk" \
    "*/com/samsung/android/knox/hdm/HdmManager.smali" \
    'getHdmVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "*/com/samsung/android/knox/ddar/DualDARPolicy.smali" \
    'getDualDARVersion()Ljava/lang/String;'
_DEKNOX_RETURN_EMPTY_STRING_OPTIONAL "system_ext" "priv-app/StorageManager/StorageManager.apk" \
    "*/com/samsung/android/knox/hdm/HdmManager.smali" \
    'getHdmVersion()Ljava/lang/String;'
LOG_STEP_OUT

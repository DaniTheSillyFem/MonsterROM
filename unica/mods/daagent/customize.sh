DAAGENT_APK_DIR="$APKTOOL_DIR/system/app/DAAgent/DAAgent.apk"
DAAGENT_PROVIDER_SMALI="$DAAGENT_APK_DIR/smali/com/samsung/android/da/daagent/provider/DualAppProvider.smali"
DAAGENT_UTILITY_SMALI="$DAAGENT_APK_DIR/smali/com/samsung/android/da/daagent/utils/DAUtility.smali"
DAAGENT_WHITELIST_SMALI="$DAAGENT_APK_DIR/smali/com/samsung/android/da/daagent/provider/WhiteListApps.smali"
DAAGENT_MANIFEST="$DAAGENT_APK_DIR/AndroidManifest.xml"

DECODE_APK "system" "system/app/DAAgent/DAAgent.apk"

if [ ! -f "$DAAGENT_WHITELIST_SMALI" ]; then
    ABORT "WhiteListApps.smali not found in DAAgent"
fi

LOG "- Installing dynamic Dual Messenger whitelist"
EVAL "cp -a \"$MODPATH/DAAgent.apk/smali/com/samsung/android/da/daagent/provider/WhiteListApps.smali\" \"$DAAGENT_WHITELIST_SMALI\""

if ! grep -q 'android.intent.action.PACKAGE_ADDED' "$DAAGENT_MANIFEST"; then
    LOG "- Registering Dual Messenger package-change receiver"
    perl -0pi -e 's{(                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>\n            </intent-filter>)}{$1\n            <intent-filter android:priority="1000">\n                <action android:name="android.intent.action.PACKAGE_ADDED"/>\n                <action android:name="android.intent.action.PACKAGE_REMOVED"/>\n                <data android:scheme="package"/>\n            </intent-filter>}s' "$DAAGENT_MANIFEST"
fi

if ! grep -q 'DAAgent: refresh dynamic whitelist before provider query' "$DAAGENT_PROVIDER_SMALI"; then
    LOG "- Hooking DualAppProvider whitelist query"
    perl -0pi -e 's{(\n    new-instance p0, Landroid/database/MatrixCursor;)}{\n    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;\n\n    move-result-object p1\n\n    invoke-static {p1}, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->refreshWhiteList(Landroid/content/Context;)V\n\n    # DAAgent: refresh dynamic whitelist before provider query\n$1}s' "$DAAGENT_PROVIDER_SMALI"
fi

if ! grep -q 'DAAgent: refresh dynamic whitelist before system server sync' "$DAAGENT_UTILITY_SMALI"; then
    LOG "- Hooking DAUtility whitelist sync"
    perl -0pi -e 's{(\.method public static updateWhitelistAppsInSystemServer\(Landroid/content/Context;\)V\n    \.locals 10\n)}{$1\n    invoke-static {p0}, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->refreshWhiteList(Landroid/content/Context;)V\n\n    # DAAgent: refresh dynamic whitelist before system server sync\n}s' "$DAAGENT_UTILITY_SMALI"
fi

grep -q 'DAAgent: refresh dynamic whitelist before provider query' "$DAAGENT_PROVIDER_SMALI" \
    || ABORT "Failed to hook DualAppProvider whitelist query"
perl -0ne 'exit(/DAAgent: refresh dynamic whitelist before provider query.*?\n    new-instance p0, Landroid\/database\/MatrixCursor;/s ? 0 : 1)' "$DAAGENT_PROVIDER_SMALI" \
    || ABORT "DualAppProvider whitelist refresh was inserted after MatrixCursor creation"
grep -q 'DAAgent: refresh dynamic whitelist before system server sync' "$DAAGENT_UTILITY_SMALI" \
    || ABORT "Failed to hook DAUtility whitelist sync"

unset DAAGENT_APK_DIR DAAGENT_PROVIDER_SMALI DAAGENT_UTILITY_SMALI DAAGENT_WHITELIST_SMALI DAAGENT_MANIFEST

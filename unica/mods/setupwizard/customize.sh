DECODE_APK "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk"

LOG "- Enabling navigation bar type settings step"
SETUPWIZARD_APK_DIR="$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk"
NAVBAR_STEP_CANDIDATES="$(find "$SETUPWIZARD_APK_DIR" -type f -name "*.smali" -exec grep -l -F "navigationbar_setting" {} + || true)"
while IFS= read -r NAVBAR_STEP_PATH; do
    [ "$NAVBAR_STEP_PATH" ] || continue
    if grep -q "^\.method.*d(Landroid/content/Context;Z)Ljava/util/ArrayList;" "$NAVBAR_STEP_PATH"; then
        NAVBAR_STEP_SMALI="${NAVBAR_STEP_PATH#$SETUPWIZARD_APK_DIR/}"
        break
    fi
done <<< "$NAVBAR_STEP_CANDIDATES"

if [ ! "$NAVBAR_STEP_SMALI" ]; then
    ABORT "Could not find setup wizard navigation bar step smali"
fi

SMALI_PATCH "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk" \
    "$NAVBAR_STEP_SMALI" "replace" \
    "d(Landroid/content/Context;Z)Ljava/util/ArrayList;" \
    "navigationbar_setting" \
    "this_string_does_not_exist" \
    > /dev/null

SETUPWIZARD_ACTIVITY_PATH="$(find "$SETUPWIZARD_APK_DIR" -type f -path "*/com/sec/android/app/SecSetupWizard/SecSetupWizardActivity.smali" | sort | head -n 1)"
if [ ! "$SETUPWIZARD_ACTIVITY_PATH" ]; then
    ABORT "Could not find setup wizard activity smali"
fi
SETUPWIZARD_ACTIVITY_SMALI="${SETUPWIZARD_ACTIVITY_PATH#$SETUPWIZARD_APK_DIR/}"
while IFS= read -r LINE; do
    if [[ "$LINE" == .method* ]]; then
        NAVBAR_ACTIVITY_METHOD="${LINE##* }"
    elif [[ "$LINE" == *"navigationbar_setting"* ]] && [ "$NAVBAR_ACTIVITY_METHOD" ]; then
        break
    elif [[ "$LINE" == ".end method"* ]]; then
        NAVBAR_ACTIVITY_METHOD=""
    fi
done < "$SETUPWIZARD_ACTIVITY_PATH"

if [ ! "$NAVBAR_ACTIVITY_METHOD" ]; then
    ABORT "Could not find setup wizard navigation bar activity method"
fi

SMALI_PATCH "system" "system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk" \
    "$SETUPWIZARD_ACTIVITY_SMALI" "replace" \
    "$NAVBAR_ACTIVITY_METHOD" \
    "navigationbar_setting" \
    "this_string_does_not_exist" \
    > /dev/null

LOG "- Disabling Recommended apps step"
EVAL "sed -i \"/omcagent/d\" \"$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/res/values/arrays.xml\""

# Dynamically patch SecSetupWizard_Global
# - Add missing/non-xml files in place
# - Patch existing files
#   - Use the first line of the file to tell sed how to apply the rest of the content
#   - Exception made for files under *res/values* where the "resources" tag gets nuked
while IFS= read -r f; do
    f="${f//$MODPATH\/SecSetupWizard_Global.apk\//}"

    if [ ! -f "$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/$f" ] || \
            [[ "$f" != *".xml" ]]; then
        LOG "- Adding \"$f\" to /system/system/priv-app/SecSetupWizard_Global.apk"
        EVAL "mkdir -p \"$(dirname "$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/$f")\""
        EVAL "cp -a \"$MODPATH/SecSetupWizard_Global.apk/${f//\$/\\$}\" \"$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/${f//\$/\\$}\""
    else
        LOG "- Patching \"$f\" in /system/system/priv-app/SecSetupWizard_Global.apk"
        if [[ "$f" == *"res/values"* ]]; then
            PATCH_INST="/<\/resources>/i"
            CONTENT="$(sed -e "/?xml/d" -e "/resources>/d" "$MODPATH/SecSetupWizard_Global.apk/$f")"
        else
            PATCH_INST="$(head -n 1 "$MODPATH/SecSetupWizard_Global.apk/$f")"
            CONTENT="$(tail -n +2 "$MODPATH/SecSetupWizard_Global.apk/$f")"
        fi
        CONTENT="$(sed -e "s/\"/\\\\\"/g" -e "s/\\\\\\\\\"/\\\\\\\\\\\\\\\\\\\\\"/g" -e "s/\\$/\\\\$/g" -e "s/ /\\\ /g" -e "s/\\\\n/\\\\\\\\\n/g" <<< "$CONTENT")"
        CONTENT="$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' <<< "$CONTENT")"
        EVAL "sed -i \"$PATCH_INST $CONTENT\" \"$APKTOOL_DIR/system/priv-app/SecSetupWizard_Global/SecSetupWizard_Global.apk/$f\""
    fi
done < <(find "$MODPATH/SecSetupWizard_Global.apk" -type f)

unset PATCH_INST CONTENT SETUPWIZARD_APK_DIR NAVBAR_STEP_PATH NAVBAR_STEP_SMALI \
    NAVBAR_STEP_CANDIDATES SETUPWIZARD_ACTIVITY_SMALI SETUPWIZARD_ACTIVITY_PATH \
    NAVBAR_ACTIVITY_METHOD LINE

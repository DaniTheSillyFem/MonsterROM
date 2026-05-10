MULTIUSER_SECSETTINGS_APK="system/priv-app/SecSettings/SecSettings.apk"
MULTIUSER_SECSETTINGS_DIR="$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk"
MULTIUSER_SWITCH='    <com.android.settings.widget.SettingsMainSwitchPreference android:title="@string/multiple_users_main_switch_title" android:key="multiple_users_main_switch" android:order="1" settings:controller="com.android.settings.users.MultiUserMainSwitchPreferenceController" settings:keywords="@string/multiple_users_main_switch_keywords" />'

MULTIUSER_METHOD_RETURNS_TRUE()
{
    local SMALI_FILE="$1"
    local METHOD="$2"

    awk -v FN="$METHOD" '
        BEGIN { inside = 0; reg = ""; found = 0 }
        /^\.method/ && index($0, FN) {
            inside = 1
            reg = ""
            next
        }
        inside && /^[[:space:]]*const[^[:space:]]*[[:space:]]+[vp][0-9]+,[[:space:]]*0x1([[:space:]]|$)/ {
            reg = $0
            sub(/^[[:space:]]*const[^[:space:]]*[[:space:]]+/, "", reg)
            sub(/,.*/, "", reg)
            next
        }
        inside && reg != "" && $0 ~ "^[[:space:]]*return[[:space:]]+" reg "([[:space:]]|$)" {
            found = 1
            next
        }
        inside && /^\.end method/ {
            inside = 0
            reg = ""
        }
        END { exit(found ? 0 : 1) }
    ' "$SMALI_FILE"
}

DECODE_APK "system" "$MULTIUSER_SECSETTINGS_APK"

USER_SETTINGS_XML="$MULTIUSER_SECSETTINGS_DIR/res/xml/user_settings.xml"
if [ -f "$USER_SETTINGS_XML" ]; then
    if grep -q -F 'android:key="multiple_users_main_switch"' "$USER_SETTINGS_XML"; then
        LOG "\033[0;33m! Multi-user main switch already present. Skipping\033[0m"
    else
        sed -i "/xmlns:android=/a\\$MULTIUSER_SWITCH" "$USER_SETTINGS_XML"
        LOG "- Adding multi-user main switch to SecSettings user_settings.xml"
    fi
else
    LOG "\033[0;33m! user_settings.xml not found, skipping multi-user switch\033[0m"
fi

RUNE_SMALI="$(find "$MULTIUSER_SECSETTINGS_DIR" -type f -path "*/com/samsung/android/settings/Rune.smali" | sort | head -n 1)"
if [ ! "$RUNE_SMALI" ]; then
    LOG "\033[0;33m! SecSettings Rune.smali not found, skipping multi-user settings hook\033[0m"
else
    RUNE_REL="${RUNE_SMALI#$MULTIUSER_SECSETTINGS_DIR/}"
    for METHOD in \
        'supportUserSettings(Landroid/content/Context;)Z' \
        'supportUserSettings(Landroid/content/Context;Z)Z'
    do
        if grep "^\.method.*" "$RUNE_SMALI" | grep -q -F -- "$METHOD"; then
            if MULTIUSER_METHOD_RETURNS_TRUE "$RUNE_SMALI" "$METHOD"; then
                LOG "\033[0;33m! $METHOD already force-enabled. Skipping\033[0m"
            else
                SMALI_PATCH "system" "$MULTIUSER_SECSETTINGS_APK" "$RUNE_REL" "return" "$METHOD" "true"
            fi
        fi
    done
fi

unset MULTIUSER_SECSETTINGS_APK MULTIUSER_SECSETTINGS_DIR MULTIUSER_SWITCH \
    USER_SETTINGS_XML RUNE_SMALI RUNE_REL METHOD
unset -f MULTIUSER_METHOD_RETURNS_TRUE

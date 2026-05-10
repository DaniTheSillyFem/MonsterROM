.class public abstract Lcom/samsung/android/da/daagent/provider/WhiteListApps;
.super Ljava/lang/Object;
.source "MonsterROM dynamic whitelist"


# static fields
.field public static final CHINA_SALES_CODES:[Ljava/lang/String;

.field public static DUAL_APP_WHITELIST_PACKAGES:[Ljava/lang/String;

.field public static DUAL_APP_WHITELIST_PACKAGES_FOR_CHINA:[Ljava/lang/String;

.field public static sAppsListCount:I


# direct methods
.method static constructor <clinit>()V
    .locals 7

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/String;

    sput-object v0, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->DUAL_APP_WHITELIST_PACKAGES:[Ljava/lang/String;

    sput-object v0, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->DUAL_APP_WHITELIST_PACKAGES_FOR_CHINA:[Ljava/lang/String;

    const-string v1, "CHN"

    const-string v2, "CHM"

    const-string v3, "CBK"

    const-string v4, "CTC"

    const-string v5, "CHU"

    const-string v6, "CHC"

    filled-new-array/range {v1 .. v6}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->CHINA_SALES_CODES:[Ljava/lang/String;

    return-void
.end method

.method public static decodeString(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    const/4 v0, 0x0

    invoke-static {p0, v0}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p0

    new-instance v0, Ljava/lang/String;

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    return-object v0
.end method

.method public static refreshWhiteList(Landroid/content/Context;)V
    .locals 7

    if-eqz p0, :cond_done

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.MAIN"

    const/4 v3, 0x0

    invoke-direct {v1, v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const-string v2, "android.intent.category.LAUNCHER"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    const/16 v2, 0x80

    invoke-virtual {p0, v1, v2}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    sput v2, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->sAppsListCount:I

    new-instance v2, Landroid/content/pm/ResolveInfo$DisplayNameComparator;

    invoke-direct {v2, p0}, Landroid/content/pm/ResolveInfo$DisplayNameComparator;-><init>(Landroid/content/pm/PackageManager;)V

    invoke-interface {v1, v2}, Ljava/util/List;->sort(Ljava/util/Comparator;)V

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_loop
    :goto_loop
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_finish

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/ResolveInfo;

    iget-object v1, v1, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;

    iget-object v1, v1, Landroid/content/pm/ActivityInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;

    iget v3, v1, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit16 v3, v3, 0x81

    const/4 v4, 0x1

    if-nez v3, :cond_system_app

    move v3, v4

    goto :goto_user_app

    :cond_system_app
    move v3, v2

    :goto_user_app
    iget-object v5, v1, Landroid/content/pm/ApplicationInfo;->metaData:Landroid/os/Bundle;

    if-eqz v5, :cond_metadata_done

    const-string v6, "com.samsung.android.multiuser.install_only_owner"

    invoke-virtual {v5, v6, v2}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v5

    if-eqz v5, :cond_metadata_done

    move v2, v4

    :cond_metadata_done
    if-eqz v3, :cond_loop

    if-nez v2, :cond_loop

    iget-object v1, v1, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_loop

    :cond_finish
    new-array p0, v2, [Ljava/lang/String;

    invoke-interface {v0, p0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/lang/String;

    sput-object p0, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->DUAL_APP_WHITELIST_PACKAGES:[Ljava/lang/String;

    sput-object p0, Lcom/samsung/android/da/daagent/provider/WhiteListApps;->DUAL_APP_WHITELIST_PACKAGES_FOR_CHINA:[Ljava/lang/String;

    :cond_done
    return-void
.end method

# [
FLOPPYKRNL_REPO="https://github.com/FlopKernel-Series/flop_exynos2100_kernel"
FLOPPYKRNL_BUILD_ARGS="${FLOPPYKRNL_BUILD_ARGS:-k}"

BUILD_KERNEL()
{
    local PARENT=$(pwd)
    
    # Ensure we are in the correct directory
    cd "$KERNEL_TMP_DIR" || ABORT "BUILD_KERNEL: Cannot find $KERNEL_TMP_DIR"

    LOG "- Running build for ${TARGET_CODENAME}"
    EVAL "DO_ZIP=0 DO_TAR=0 DEVICE=\"${TARGET_NAME}\" CODENAME=\"${TARGET_CODENAME}\" bash ./build/ckbuild.sh ${FLOPPYKRNL_BUILD_ARGS}"

    cd "$PARENT"
}

REPACK_BOOT_IMAGE()
{
    local IMAGE="$1"
    local BOOT_TMP="$TMP_DIR-floppy-boot"
    local MKBOOTIMG_ARGS

    if [ ! -f "$WORK_DIR/kernel/boot.img" ]; then
        ABORT "File not found: ${WORK_DIR//$SRC_DIR\//}/kernel/boot.img"
    fi

    EVAL "rm -rf \"$BOOT_TMP\""
    EVAL "mkdir -p \"$BOOT_TMP\""
    EVAL "cp -a \"$WORK_DIR/kernel/boot.img\" \"$BOOT_TMP/boot.img\""

    MKBOOTIMG_ARGS="$(unpack_bootimg --boot_img "$BOOT_TMP/boot.img" --out "$BOOT_TMP/out" --format mkbootimg 2>&1)"
    if [ ! -f "$BOOT_TMP/out/kernel" ]; then
        ABORT "Failed to extract boot.img\n\n$MKBOOTIMG_ARGS"
    fi

    EVAL "cp -a \"$IMAGE\" \"$BOOT_TMP/out/kernel\""
    LOG "- Repacking boot.img with FloppyKernel Image"
    EVAL "mkbootimg $MKBOOTIMG_ARGS -o \"$BOOT_TMP/new-boot.img\""
    echo -n "SEANDROIDENFORCE" >> "$BOOT_TMP/new-boot.img"
    EVAL "mv -f \"$BOOT_TMP/new-boot.img\" \"$WORK_DIR/kernel/boot.img\""
    EVAL "rm -rf \"$BOOT_TMP\""
}

SAFE_PULL_CHANGES()
{
    set -eo pipefail
    local PARENT=$(pwd)

    cd "$KERNEL_TMP_DIR" || ABORT "SAFE_PULL: Directory missing"
    EVAL "git fetch origin"

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)
    BASE=$(git merge-base @ origin/main)

    if [[ "$LOCAL" == "$REMOTE" ]]; then
        LOG "- Local branch is up-to-date."
    elif [[ "$LOCAL" == "$BASE" ]]; then
        LOG "- Fast-forwarding."
        EVAL "git pull --ff-only"
    else
        LOGW "- Local branch diverged or ahead. Resetting to remote."
        git reset --hard origin/floppy-main
    fi

    cd "$PARENT"
}

REPLACE_KERNEL_BINARIES()
{
    # 1. Define the directory name based on your requirement
    # Using 'out' as the parent folder
    KERNEL_TMP_DIR="out/kernel_tmp-${TARGET_PLATFORM}"

    # 2. Check if the directory is missing
    if [[ ! -d "$KERNEL_TMP_DIR" ]]; then
        LOG "- Kernel directory missing. Cloning into $KERNEL_TMP_DIR..."
        # Ensure 'out' exists before cloning
        mkdir -p -- "out"
        EVAL "git clone --branch floppy-main --single-branch --recurse-submodules \"$FLOPPYKRNL_REPO\" \"$KERNEL_TMP_DIR\"" || ABORT "Clone failed"
    fi

    # 3. Repository Sync
    if [[ -d "$KERNEL_TMP_DIR/.git" ]]; then
        cd "$KERNEL_TMP_DIR" || exit
        LOG "- Syncing source code..."
        git fetch --all
        git reset --hard FETCH_HEAD
        cd - > /dev/null || exit
    else
        ABORT "Directory exists but is not a git repo: $KERNEL_TMP_DIR"
    fi

    # 4. Execute Build
    LOG "- Starting kernel build process."
    BUILD_KERNEL

    # 5. Artifact Management
    [[ ! -d "$WORK_DIR/kernel" ]] && mkdir -p -- "$WORK_DIR/kernel"

    local IMAGE="$KERNEL_TMP_DIR/out/arch/arm64/boot/Image"
    local IMAGE_GZ="$KERNEL_TMP_DIR/out/arch/arm64/boot/Image.gz"
    local VENDOR_BOOT="$KERNEL_TMP_DIR/build/images/vendor_boot.img"
    local DTBO="$KERNEL_TMP_DIR/build/images/dtbo.img"

    if [ ! -f "$IMAGE" ] && [ -f "$IMAGE_GZ" ]; then
        IMAGE="$IMAGE_GZ"
    fi

    if [ ! -f "$IMAGE" ]; then
        ABORT "FloppyKernel Image not found: ${IMAGE//$SRC_DIR\//}"
    fi
    if [ ! -f "$VENDOR_BOOT" ]; then
        ABORT "FloppyKernel vendor_boot.img not found: ${VENDOR_BOOT//$SRC_DIR\//}"
    fi

    if [[ "$IMAGE" == *.gz ]]; then
        LOG "- Decompressing FloppyKernel Image.gz"
        EVAL "gzip -cd \"$IMAGE\" > \"$TMP_DIR-floppy-Image\""
        IMAGE="$TMP_DIR-floppy-Image"
    fi

    REPACK_BOOT_IMAGE "$IMAGE"
    EVAL "rm -f \"$TMP_DIR-floppy-Image\""

    LOG "- Replacing vendor_boot.img"
    EVAL "cp -a \"$VENDOR_BOOT\" \"$WORK_DIR/kernel/vendor_boot.img\""

    if [ -f "$DTBO" ]; then
        LOG "- Replacing dtbo.img"
        EVAL "cp -a \"$DTBO\" \"$WORK_DIR/kernel/dtbo.img\""
    else
        LOGW "FloppyKernel build did not output dtbo.img; keeping target dtbo.img"
    fi
}
# ]

REPLACE_KERNEL_BINARIES

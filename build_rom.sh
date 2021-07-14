# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/ArrowOS/android_manifest.git -b arrow-11.0 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/DHAMPOT/dependencies.git --depth 1 -b arrow .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
lunch arrow_platina-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export ARROW_GAPPS=true
export SKIP_API_CHECK=true
export SKIP_ABI_CHECK=true
export TZ=Asia/Jakarta
m bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
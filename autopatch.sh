#!/bin/bash
ksu_patches=(
	"ksu01-add-susfs-1.5.5-to-ksu.patch"
	"ksu02-fix-get_cred_rsu-generation.patch"
)

kern_patches=(
	"kernel01-remove-hardcode-on-build.patch"
	"kernel02-backport-bpf.patch"
	"kernel03-add-ksu-next.patch"
	"kernel04-integrate-susfs-1.5.5-for-kernel-4.14.patch"
	"kernel05-fix-susfs-build-on-sweet.patch"
	"kernel06-enable-kprobe-for-sweet.patch"
	"kernel07-enable-susfs-overlayfs.patch"
)

git clone --depth=1 https://github.com/pixelos-devices/android_kernel_xiaomi_sm6150
git clone --depth=1 https://github.com/KernelSU-Next/KernelSU-Next
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
export CLANG_R530567=$PWD/linux-x86/clang-r530567
cd android_kernel_xiaomi_sm6150
chmod u+x build.sh
cd drivers
ln -sf $PWD/../../KernelSU-Next/kernel kernelsu
cd ..
for i in "${kern_patches[@]}"; do
	patch -p1 < ../$i
done

cd ../KernelSU-Next
for i in "${ksu_patches[@]}"; do
	patch -p1 < ../$i
done

echo "autosetup: ok!!"

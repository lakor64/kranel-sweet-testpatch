#!/bin/bash
ksu_patches=(
	"ksu01-add-susfs-1.5.5-to-ksu.patch"
	"ksu02-fix-get_cred_rsu-generation.patch"
)

kern_a16_patches=(
	"kernel-a16-01-remove-hardcode-on-build.patch"
	"kernel-a16-02-backport-bpf.patch"
	"kernel-a16-03-add-ksu-next.patch"
	"kernel-a16-04-integrate-susfs-1.5.5-for-kernel-4.14.patch"
	"kernel-a16-05-fix-susfs-build-on-sweet.patch"
	"kernel-a16-06-enable-kprobe-for-sweet.patch"
	"kernel-a16-07-enable-susfs-overlayfs.patch"
)

kern_a14_patches=(

)

android_ver=$(cat android_version 2>/dev/null)
if [ "$android_ver" != "16" ] && [ "$android_ver" != "14" ]; then
	echo "Invalid android version: $android_ver, check file \"android_version\""
	exit -1
fi


if [ "$android_ver" == "16" ]; then
	git clone --depth=1 https://github.com/pixelos-devices/android_kernel_xiaomi_sm6150 kernel_a16
	kern_patches="${kern_a16_patches[@]}"
	kern_dir="kernel_a16"
fi

if [ "$android_ver" == "14" ]; then
	git clone --depth=1  https://github.com/itsshashanksp/kernel_xiaomi_sm6150 kernel_a14
	kern_patches="${kern_a14_patches[@]}"
	kern_dir="kernel_a14"
fi

git clone --depth=1 https://github.com/KernelSU-Next/KernelSU-Next
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
git clone --depth=5 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/
cd aarch64-linux-android-4.9
git reset --HARD 0a0604336d4d1067aa1aaef8d3779b31fcee841d

cd $kern_dir
chmod u+x build.sh
cd drivers
ln -sf $PWD/../../KernelSU-Next/kernel kernelsu
cd ..
for i in "${kern_patches[@]}"; do
	patch -p1 < ../$i
done

if [ "$android_version" == "14"]; then
	curl https://raw.githubusercontent.com/itsshashanksp/Scripts/main/kernel.sh > kernel.sh
	chmod +x kernel.sh
fi

cd ../KernelSU-Next
for i in "${ksu_patches[@]}"; do
	patch -p1 < ../$i
done

echo "autosetup: ok!!"

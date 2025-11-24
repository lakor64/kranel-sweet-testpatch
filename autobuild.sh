#!/bin/bash
export CLANG_R530567=$PWD/linux-x86/clang-r530567
export CLANG_R547379=$PWD/linux-x86/clang-r547379
export BINUTILS_245=$PWD/aarch64-linux-android-4.9

android_version=$(cat android_version 2>/dev/null)
if [ "$android_version" == "16" ]; then
	cd kernel_a16
	echo "sweet" | ./build.sh
fi
if [ "$android_version" == "14" ]; then
	cd kernel_a14
	export KERNEL_VERSION_TAG=v4.14.355
	export DEVICE_TYPE=sweet
	bash kernel.sh
fi


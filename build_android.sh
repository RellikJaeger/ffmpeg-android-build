#!/usr/bin/env bash
export NDK=/Volumes/Data/Git/android-ndk-r14b
export PREFIX=`pwd`/build
export SONAME=libbzffmpeg.so

echo NDK-Dir=${NDK}
echo PREFIX=${PREFIX}

root_dir=`pwd`

cd $root_dir/x264

./build_android_all.sh


cd $root_dir/ffmpeg

./build_android_all.sh

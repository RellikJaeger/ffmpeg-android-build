#!/usr/bin/env bash
export NDK=/Users/guaishou/Git/ndk/android-ndk-r14b
export PREFIX=`pwd`/build
export SONAME=libbzffmpeg.so

echo NDK-Dir=${NDK}
echo PREFIX=${PREFIX}

root_dir=`pwd`

cd $root_dir/x264

./build_android_all.sh

echo start build mp3lame
cd $root_dir/mp3lame
$NDK/ndk-build NDK_LIBS_OUT=../build/mp3lame/ NDK_OUT=../build/mp3lame/
echo build mp3lame end

cd $root_dir/ffmpeg

./build_android_all.sh

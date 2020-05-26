#!/bin/bash

#arm64 最小必须是android-21
PLATFORM=$NDK/platforms/android-21/arch-arm64/
PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=aarch64 \
--cc=$PREBUILT/bin/aarch64-linux-android-gcc \
--cross-prefix=$PREBUILT/bin/aarch64-linux-android- \
--nm=$PREBUILT/bin/aarch64-linux-android-nm \
--extra-cflags="-I${PREFIX}/x264/android/arm64/include" \
--extra-ldflags="-L${PREFIX}/x264/android/arm64/lib" "


temp_prefix=${PREFIX}/ffmpeg/android/arm64-v8a
rm -rf $temp_prefix
export PATH=$PREBUILT/bin/:$PATH/


function build_arm64
{
  ./configure \
  --logfile=conflog.txt \
  --target-os=android \
  --prefix=${temp_prefix} \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --extra-cflags="" \
  --extra-ldflags="-lx264 -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
  ${COMMON_SET}


  make clean
  make -j10
  make install

   aarch64-linux-android-gcc \
   --sysroot=$PLATFORM \
   -L$temp_prefix/lib \
   -shared -o $temp_prefix/${SONAME} \
   -Wl,--whole-archive \
   libavcodec/libavcodec.a \
   libavfilter/libavfilter.a \
   libswresample/libswresample.a \
   libavformat/libavformat.a \
   libavutil/libavutil.a \
   libswscale/libswscale.a \
   libpostproc/libpostproc.a \
   ${PREFIX}/x264/android/arm64/lib/libx264.a \
   -Wl,--no-whole-archive -lm -lz


    cp $temp_prefix/${SONAME} $temp_prefix/libffmpeg-debug.so
    aarch64-linux-android-strip --strip-unneeded $temp_prefix/${SONAME}

    echo SO-Dir=${temp_prefix}/${SONAME}
}

build_arm64

cp config.h $temp_prefix/config.h

echo Android ARM64 builds finished

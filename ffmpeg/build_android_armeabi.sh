#!/bin/bash

PLATFORM=$NDK/platforms/android-14/arch-arm/
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=arm \
--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
--extra-cflags="-I${PREFIX}/x264/android/arm/include" \
--extra-ldflags="-L${PREFIX}/x264/android/arm/lib" "


temp_prefix=${PREFIX}/ffmpeg/android/armeabi
rm -rf $temp_prefix
export PATH=$PREBUILT/bin/:$PATH/


function build_ARMv6
{
  ./configure \
  --target-os=android \
  --prefix=${temp_prefix} \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --extra-cflags=" -O3 -fpic -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 -mfloat-abi=softfp -mfpu=vfp -marm -march=armv6 -DHAVE_ISNAN -DHAVE_ISINF" \
  --extra-ldflags="-lx264 -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
  ${COMMON_SET} \
  --disable-doc \
  --enable-neon

  make clean
  make -j10
  make install

   arm-linux-androideabi-gcc \
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
   ${PREFIX}/x264/android/arm/lib/libx264.a \
   -Wl,--no-whole-archive -lm -lz

    cp $temp_prefix/${SONAME} $temp_prefix/libffmpeg-debug.so
    arm-linux-androideabi-strip --strip-unneeded $temp_prefix/${SONAME}

    echo SO-Dir=${temp_prefix}/${SONAME}
}



build_ARMv6

cp config.h $temp_prefix/config.h

echo Android ARMEABI builds finished

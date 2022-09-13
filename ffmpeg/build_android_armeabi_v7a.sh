#!/bin/bash

PLATFORM=$NDK/platforms/android-16/arch-arm
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

echo PLATFORM=${PLATFORM}

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=arm \
--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
--extra-cflags="-I${PREFIX}/x264/android/arm/include" \
--extra-ldflags="-L${PREFIX}/x264/android/arm/lib" \
--extra-cflags="-I${PREFIX}/../mp3lame/include" \
--extra-ldflags="-L${PREFIX}/mp3lame/local/armeabi-v7a" "

temp_prefix=${PREFIX}/ffmpeg/android/armeabi-v7a
rm -rf $temp_prefix
export PATH=$PREBUILT/bin/:$PATH/

function build_ARMv7() {
  ./configure \
    --pkg-config="--static" \
    --target-os=android \
    --prefix=${temp_prefix} \
    ${GENERAL} \
    --sysroot=$PLATFORM \
    --extra-cflags="-DANDROID -fPIC -ffunction-sections -funwind-tables -fstack-protector -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300" \
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
    ${PREFIX}/x264/android/arm/lib/libx264.a \
    ${PREFIX}/mp3lame/local/armeabi-v7a/libmp3lame.a \
    -Wl,--no-whole-archive -lm -lz

  cp $temp_prefix/${SONAME} $temp_prefix/libffmpeg-debug.so
  arm-linux-androideabi-strip --strip-unneeded $temp_prefix/${SONAME}

  echo SO-Dir=${temp_prefix}/${SONAME}
}

export PKG_CONFIG_PATH=/Users/guaishou/Git/Github/ffmpeg-android-build/build/x264/android/arm/lib/pkgconfig
export PKG_CONFIG_LIBDIR=/Users/guaishou/Git/Github/ffmpeg-android-build/build/x264/android/arm/lib/pkgconfig
#exec /usr/bin/pkg-config "$@"
build_ARMv7

cp config.h $temp_prefix/config.h

echo Android ARMv7-a builds finished

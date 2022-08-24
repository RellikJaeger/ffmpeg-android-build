## FFmpeg is compiled using Android NDK

### 中文文档：

1. 目前该脚本支持armeabi-v7a arm64-v8a，目前我对FFmpeg裁剪了很多目前编译出来的库4M多，音视频开发常见的功能都包含进去了
2. ffmpeg 版本5.1.0
4. NDK版本r14b，下载地址：https://developer.android.com/ndk/downloads/older_releases (这个是Google的需要科学上网, 我下载了一份放到了我的服务器上：https://www.raoyunsoft.com/public/android-ndk-r14b-darwin-x86_64.zip)
5. build目录下是已经编译好的, 如果不能编译就先用着吧
6. 编译环境Mac 12.5.1（理论上其它环境也可以使用这个脚本编译）


FFMpeg下载地址： http://ffmpeg.org/download.html
没有采用libx264，libx264是GPL协议，对商业软件不优化友好，采用了mpeg4代替视频编码

### Build
必备软件:autoconf automake libtool pkg-config curl cmake gcc gperf texinfo yasm nasm bison autogen
1. cd ffmpeg and run ./configure 
2. edit build_android.sh NDK path
3. `$ ./build_android.sh`
4. libffmpeg.so will be built to `build/ffmpeg/android/{armeabi-v7a arm64-v8a}/`

编译好的工程地址：https://github.com/bookzhan/ffmpeg-android-build.git

我开源的音视频处理库：https://github.com/bookzhan/bzmedia 目前正在整理代码，会相继开源编码，解码，音视频编辑功能，欢迎持续关注

------

### English documentation：

1. The script currently supports armeabi-v7a arm64-v8a. At present, I have cropped a lot of the currently compiled library 4M for FFmpeg, and the common functions of audio and video development are included.
2. ffmpeg version 5.1.0
4. NDK version r14b, download address: https://developer.android.com/ndk/downloads/older_releases
5. The build directory is already compiled, if you can't compile, use it first
6. Compile environment Mac 12.5.1 (in theory, other environments can also use this script to compile)



FFMpeg download address: http://ffmpeg.org/download.html
Not using libx264, libx264 is GPL protocol, not friendly to commercial software optimization, using mpeg4 instead of video encoding


### Build
Essential software:autoconf automake libtool pkg-config curl cmake gcc gperf 
1. cd ffmpeg and run ./configure
2. edit build_android.sh NDK path
3. `$ ./build_android.sh`
4. libffmpeg.so will be built to `build/ffmpeg/android/{armeabi-v7a arm64-v8a}/`

Compiled project address：https://github.com/bookzhan/ffmpeg-android-build.git

My open source audio and video processing library: https://github.com/bookzhan/bzmedia is currently finishing the code, will have open source encoding, decoding, audio and video editing functions, welcome continuous attention
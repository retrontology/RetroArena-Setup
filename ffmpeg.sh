#!/usr/bin/env bash

# This file is part of The RetroArena (TheRA)
#
# The RetroArena (TheRA) is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#

rp_module_id="ffmpeg"
rp_module_desc="FFmpeg v3.4"
rp_module_licence="LGPL v2.1+ https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/refs/heads/release/3.4:/LICENSE.md"
rp_module_section=""
rp_module_flags=""

function get_ver_ffmpeg() {
    echo "3.4"
}

function depends_ffmpeg() {
    aptInstall checkinstall
    apt build-dep -y --force-yes ffmpeg
}

function sources_ffmpeg() {
    local ver="$(get_ver_ffmpeg)"
    local branch="release/$ver"
    gitPullOrClone "$md_build/$ver" https://git.ffmpeg.org/ffmpeg.git "$branch"
    cd "$ver"
}

function build_ffmpeg() {
    cd "$md_build/$ver"
    ./configure --prefix=/usr --extra-version=0ubuntu0.16.04.1 --build-suffix=-ffmpeg --toolchain=hardened --libdir=/usr/lib/arm-linux-gnueabihf --incdir=/usr/include/arm-linux-gnueabihf --cc=cc --cxx=g++ --enable-gpl --enable-shared --disable-stripping --disable-decoder=libopenjpeg --enable-avresample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libmodplug --enable-libmp3lame --enable-libopenjpeg --enable-libopus --enable-libpulse --enable-librtmp --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxvid --enable-libzvbi --enable-openal --enable-opengl --enable-libdc1394 --enable-libiec61883 --enable-libzmq --enable-frei0r --enable-libx264 --enable-libopencv --enable-decoder=atrac3 --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=atrac3p --enable-decoder=mp3 --enable-decoder=pcm_s16le --enable-decoder=pcm_s8 --enable-demuxer=h264 --enable-demuxer=m4v --enable-demuxer=mpegvideo --enable-demuxer=mpegps --enable-demuxer=mp3 --enable-demuxer=avi --enable-demuxer=aac --enable-demuxer=pmp --enable-demuxer=oma --enable-demuxer=pcm_s16le --enable-demuxer=pcm_s8 --enable-muxer=avi --enable-demuxer=wav --enable-encoder=pcm_s16le --enable-encoder=huffyuv --enable-encoder=ffv1 --enable-encoder=mjpeg --enable-parser=h264 --enable-parser=mpeg4video --enable-parser=mpegaudio --enable-parser=mpegvideo --enable-parser=aac --enable-parser=aac_latm
    make -j7
    md_ret_require=(
        "$md_build/ffmpeg"
        "$md_build/ffplay"
        "$md_build/ffprobe"
        "$md_build/ffserver"
        "$md_build/libavdevice/libavdevice-ffmpeg.so"
        "$md_build/libavfilter/libavfilter-ffmpeg.so"
        "$md_build/libavformat/libavformat-ffmpeg.so"
        "$md_build/libavcodec/libavcodec-ffmpeg.so"
        "$md_build/libavresample/libavresample-ffmpeg.so"
        "$md_build/libpostproc/libpostproc-ffmpeg.so"
        "$md_build/libswresample/libswresample-ffmpeg.so"
        "$md_build/libswscale/libswscale-ffmpeg.so"
        "$md_build/libavutil/libavutil-ffmpeg.so"
}

function remove_old_ffmpeg() {
    # remove our old ffmpeg packages
    sudo apt-get -y purge ffmpeg libavutil-dev
    sudo apt-get -y autoremove
}

function install_ffmpeg() {
    remove_old_ffmpeg
    cd "$md_build/$ver"
    sudo checkinstall -y --deldoc=yes --pkgversion=3.4
    ldconfig
    echo "ffmpeg hold" | dpkg --set-selections
}

function revert_ffmpeg() {
    aptUpdate
    aptInstall --force-yes ffmpeg
}

function remove_ffmpeg() {
    dpkg -r ffmpeg
    apt-get autoremove -y
}

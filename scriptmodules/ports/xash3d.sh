#!/usr/bin/env bash

# This file is part of The RetroArena (TheRA)
#
# The RetroArena (TheRA) is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#

rp_module_id="xash3d"
rp_module_desc="Xash3D - An Open Source Gold Source Engine"
rp_module_licence="GPL3 https://raw.githubusercontent.com/FWGS/xash3d/master/COPYING"
rp_module_section="prt"
rp_module_flags="noinstclean !aarch64"

function depends_xash3d() {
    getDepends libxext-dev libsdl2-dev libsdl2-image-dev libopenal-dev
}

function sources_xash3d() {
    gitPullOrClone "$md_build/xash3d" "https://github.com/ptitSeb/xash3d"
    gitPullOrClone "$md_build/halflife" "https://github.com/retrontology/halflife"
    gitPullOrClone "$md_build/XashXT" "https://github.com/retrontology/XashXT"
    gitPullOrClone "$md_build/glshim" "https://github.com/ptitSeb/glshim"
}

function build_xash3d() {
    cd glshim
    cmake . -DBCMHOST=1
    make GL -j8
    cd ../xash3d
    mkdir build
    cd build
    cmake .. -DRPI=ON -DXASH_SDL=ON -DXASH_VGUI=OFF -DHL_SDK_DIR="$md_build"/halflife/ -DCMAKE_C_FLAGS="-mcpu=cortex-a15 -mtune=cortex-a15.cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations" -DCMAKE_CXX_FLAGS="-mcpu=cortex-a15 -mtune=cortex-a15.cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -funsafe-math-optimizations" -DCMAKE_INSTALL_PREFIX="$md_inst"
    make -j8
    cd ../../halflife/dlls
    make -f Makefile.rpi -j8
    cd ../../XashXT/client
    make -f Makefile.rpi -j8
    md_ret_require=(
        "$md_build/glshim/lib/libGL.so.1"
        "$md_build/xash3d/build/engine/libxash.so"
        "$md_build/xash3d/build/mainui/libxashmenu.so"
        "$md_build/xash3d/build/game_launch/xash3d"
        "$md_build/halflife/dlls/hl.so"
        "$md_build/halflife/dlls/hl_bs.so"
        "$md_build/XashXT/client/client.so"
        "$md_build/XashXT/client/bsclient.so"
    )
}

function install_xash3d() {
    cd xash3d/build
    make install
    cp "$md_build/glshim/lib/libGL.so.1" "$md_inst"/lib/
    cp "$md_build/halflife/dlls/hl.so" "$md_inst"/lib/
    cp "$md_build/halflife/dlls/hl_bs.so" "$md_inst"/lib/
    cp "$md_build/XashXT/client/client.so" "$md_inst"/lib/
    cp "$md_build/XashXT/client/bsclient.so" "$md_inst"/lib/
}

function configure_xash3d() {
    addPort "$md_id" "Half-Life" "Xash3D - Half-Life" "LIBGL_FB=1 LIBGL_BATCH=1 LD_LIBRARY_PATH=$md_inst/lib/xash3d $md_inst/bin/xash3d -console -debug "
}

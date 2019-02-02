#!/usr/bin/env bash

# This file is part of The RetroArena (TheRA)
#
# The RetroArena (TheRA) is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#

rp_module_id="moonlight-embedded"
rp_module_desc="moonlight-embedded - Gamestream client for embedded systems"
rp_module_licence="GPL3 https://raw.githubusercontent.com/irtimmer/moonlight-embedded/master/LICENSE"
rp_module_section="prt"
rp_module_flags=""

function depends_moonlight-embedded() {
    getDepends cmake libsdl2-dev libopus-dev libavahi-client-dev libavahi-common-dev libenet-dev libenet-doc libenet7 libenet7-dbg ffmpeg
}

function sources_moonlight-embedded() {
    gitPullOrClone "$md_build" https://github.com/AreaScout/moonlight-embedded
}

function build_moonlight-embedded() {
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX="$md_inst"
    make -j7
    md_ret_require=(
        ""
        ""
    )
}

function install_moonlight-embedded() {
    cd build
    make install
}

function configure_moonlight-embedded() {
    addPort "$md_id" "moonlight-embedded" "Moonlight-Embedded - Gamestream client for embedded systems" "LD_LIBRARY_PATH=$md_inst/lib $md_inst/bin/moonlight"
}

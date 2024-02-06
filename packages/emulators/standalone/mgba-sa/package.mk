# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2023-present - The JELOS Project (https://github.com/JustEnoughLinuxOS)

PKG_NAME="mgba-sa"
PKG_VERSION="bba2c131a172d6a209e9a96b827e670723deb0af"
PKG_LICENSE="Mozilla Public License Version 2.0"
PKG_SITE="https://mgba.io/"
PKG_URL="https://github.com/mgba-emu/mgba.git"
PKG_DEPENDS_TARGET="toolchain mesa ffmpeg libzip qt5"
PKG_LONGDESC="mGBA is an emulator for running Game Boy Advance games. It also supports Game Boy and Game Boy Color games."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET+="-DCMAKE_BUILD_TYPE=Release \
					   -DBUILD_LTO=ON"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/lib
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/qt/mgba-qt ${INSTALL}/usr/bin
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/libmgba.so* ${INSTALL}/usr/lib
  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

  chmod +x ${INSTALL}/usr/bin/start_mgba.sh
  chmod +x ${INSTALL}/usr/bin/mgba_gen_controller.sh

  mkdir -p ${INSTALL}/usr/config/${PKG_NAME}
  cp ${PKG_DIR}/config/common/* ${INSTALL}/usr/config/${PKG_NAME}
}

post_install() {
    case ${DEVICE} in
      S922X)
        LIBEGL="export SDL_VIDEO_GL_DRIVER=\/usr\/lib\/egl\/libGL.so.1 SDL_VIDEO_EGL_DRIVER=\/usr\/lib\/egl\/libEGL.so.1"
      ;;
      *)
        LIBEGL=""
      ;;
    esac
    sed -e "s/@LIBEGL@/${LIBEGL}/g" \
        -i ${INSTALL}/usr/bin/start_mgba.sh
}

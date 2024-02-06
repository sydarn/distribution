#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

export MGBA_HOME=/storage/.config/mgba
export MGBA_CONFIG=/usr/config/mgba/mgba.template

if [ ! -d "$MGBA_HOME" ]
then
  mkdir /storage/.config/mgba
fi

if [ ! -f "$MGBA_HOME/config.ini" ]
then
    /usr/bin/bash /usr/bin/mgba_gen_config.sh
fi

#Emulation Station Features
GAME=$(echo "${1}"| sed "s#^/.*/##")
CORE=$(echo "${2}"| sed "s#^/.*/##")
PLATFORM=$(echo "${3}"| sed "s#^/.*/##")
STRETCH=$(get_setting stretch "${PLATFORM}" "${GAME}")
SHADER=$(get_setting shader "${PLATFORM}" "${GAME}")

#Set the cores to use
CORES=$(get_setting "cores" "${PLATFORM}" "${GAME}")
if [ "${CORES}" = "little" ]
then
  EMUPERF="${SLOW_CORES}"
elif [ "${CORES}" = "big" ]
then
  EMUPERF="${FAST_CORES}"
else
  ### All..
  unset EMUPERF
fi


#Run mgba
@LIBEGL@
${EMUPERF} /usr/bin/mgba-qt

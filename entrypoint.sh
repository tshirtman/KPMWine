#!/usr/bin/env sh

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH;C:\\gstreamer\\1.0\\x86_64\\lib\\pkgconfig"

export DISPLAY=:20
Xvfb $DISPLAY &

$@

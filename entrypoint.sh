#!/usr/bin/env sh

# x11vnc  -create -env FD_PROG=/usr/bin/fluxbox \
# 	-env X11VNC_FINDDISPLAY_ALWAYS_FAILS=1 \
#         -env X11VNC_CREATE_GEOM=${1:-1920x1080x24} \
#         -gone 'killall Xvfb' \
#         -bg -nopw &

Xvfb :20 &

export DISPLAY=:20

$@

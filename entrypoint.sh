#!/usr/bin/env sh

export DISPLAY=:20
Xvfb $DISPLAY &

$@

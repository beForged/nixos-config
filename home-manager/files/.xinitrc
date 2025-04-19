#!/bin/sh

feh --bg-fill --randomize ~/pictures/*

# picom --experimental-backends &

# 25 mb ram for debug log
exec i3 --shmlog-size=26214400

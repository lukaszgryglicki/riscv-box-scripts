#!/bin/bash
# ALWAYS rescale, even if the video is already low res enough
if [ -z "$1" ]
then
    echo "$0: required video file name"
    exit 1
fi

width=$(ffmpeg -i "$1" 2>&1 | grep Video: | grep -Po '\d{3,5}x\d{3,5}' | cut -d'x' -f1)
if [ -z "$width" ]
then
    echo "$0: cannot get $1 video width"
    exit 1
fi
height=$(ffmpeg -i "$1" 2>&1 | grep Video: | grep -Po '\d{3,5}x\d{3,5}' | cut -d'x' -f2)
if [ -z "$height" ]
then
    echo "$0: cannot get $1 video height"
    exit 1
fi
echo "$1 is ($width x $height)"

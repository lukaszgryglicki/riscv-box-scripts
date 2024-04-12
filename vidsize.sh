#!/bin/bash
# ALWAYS rescale, even if the video is already low res enough
if [ -z "$1" ]
then
    echo "$0: required video file name"
    exit 1
fi

for f in "$@"
do
    width=$(ffmpeg -i "$f" 2>&1 | grep Video: | grep -Po '\d{3,5}x\d{3,5}' | cut -d'x' -f1)
    if [ -z "$width" ]
    then
        echo "$0: cannot get $f video width"
        continue
    fi
    height=$(ffmpeg -i "$f" 2>&1 | grep Video: | grep -Po '\d{3,5}x\d{3,5}' | cut -d'x' -f2)
    if [ -z "$height" ]
    then
        echo "$0: cannot get $f video height"
        continue
    fi
    echo "$f is ($width x $height)"
done

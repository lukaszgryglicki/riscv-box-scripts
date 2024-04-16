#!/bin/bash
# ALWAYS=1 - process, even if the video is already low res enough
# REMOVE=1 - remove source file if succeeded
# OUTPUT=file.mp4 - hardcode output file name
# MIN_WIDTH=w - minimal video width to be considered for further processing
# MIN_HEIGHT=h - minimal video height to be considered for further processing
#
nw=800
nh=500

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

ima=$(file -b -i "$1" | grep 'image/')
if [ ! -z "$ima" ]
then
    echo "$0: $1 is an image not video ($ima)"
    file "$1"
    exit 1
fi

if ( [ ! -z "$MIN_WIDTH" ] && [ "$width" -lt "$MIN_WIDTH" ] )
then
    echo "$0: specified min width $MIN_WIDTH - $1 width is $width, skipping"
    exit 0
fi

if ( [ ! -z "$MIN_HEIGHT" ] && [ "$height" -lt "$MIN_HEIGHT" ] )
then
    echo "$0: specified min height $MIN_HEIGHT - $1 height is $height, skipping"
    exit 0
fi

output="${1%.*}_adjvid.mp4"
if [ ! -z "$OUTPUT" ]
then
    output="$OUTPUT"
fi

if ( [ "$width" -le "$nw" ] && [ "$height" -le "$nh" ] )
then
    echo "$1 is already lower than or equal ($nw x $nh) no action needed"
    if [ -z "$ALWAYS" ]
    then
        if [ ! -z "$REMOVE" ]
        then
            mv "$1" "$output"
            echo "moved "$1" to "$output" without re-encoding"
        fi
        exit 0
    fi
    echo "$0 proceeding anyway, but without rescaling"
    no_rescale=1
else
    echo "rescaling $1 from ($width x $height) not to exceed ($nw x $nh)"
    if [ "$width" -lt "$height" ]
    then
        flip=1
        echo "$0: detected vertical video"
    fi
fi

if [ ! -z "$no_rescale" ]
then
    ffmpeg -nostats -loglevel error -hide_banner -threads 4 -y -i "$1" -c:v libx264 -crf 25 -preset:v ultrafast -preset:a ultrafast -tune fastdecode -strict experimental -c:a aac -b:a 64k -ac 1 -ar 22050 -dn -sn "$output" || exit 1
else
    if [ -z "$flip" ]
    then
        ffmpeg -nostats -loglevel error -hide_banner -threads 4 -y -i "$1" -c:v libx264 -crf 25 -preset:v ultrafast -preset:a ultrafast -tune fastdecode -filter:v "scale=$nw:-2" -strict experimental -c:a aac -b:a 64k -ac 1 -ar 22050 -dn -sn "$output" || exit 1
    else
        ffmpeg -nostats -loglevel error -hide_banner -threads 4 -y -i "$1" -c:v libx264 -crf 25 -preset:v ultrafast -preset:a ultrafast -tune fastdecode -filter:v "scale=-2:$nh" -strict experimental -c:a aac -b:a 64k -ac 1 -ar 22050 -dn -sn "$output" || exit 1
    fi
fi


if [ ! -z "$REMOVE" ]
then
    rm -f "$1" && echo "$1 removed"
fi

# nw=1280
# nh=800
# ffmpeg -y -i "$1" -c:v libx264 -crf 25 -preset ultrafast -tune fastdecode -filter:v "scale='min($nw,iw)':'min($nh,ih)':force_original_aspect_ratio=decrease,pad=$nw:$nh:(ow-iw)/2:(oh-ih)/2" -map 0 -c:a copy -c:s copy "$output" || exit 1
# ultrafast superfast veryfast fast
# ffmpeg -hide_banner -y -i "$1" -c:v libx264 -crf 23 -preset ultrafast -tune film -filter:v "scale='min($nw,iw)':'min($nh,ih)'" -map 0 -c:a copy -c:s copy "$output"
# ffmpeg -y -i "$1" -c:v libx265 -crf 21 -tag:v hvc1 -preset fast -filter:v "scale='min($nw,iw)':min'($nh,ih)':force_original_aspect_ratio=decrease,pad=$nw:$nh:(ow-iw)/2:(oh-ih)/2" -map 0 -c:a copy -c:s copy "$output"
# ffmpeg -nostats -loglevel 0 -y -i "$1" -c:v libx264 -crf 21 -preset veryfast -filter:v "scale='min($nw,iw)':min'($nh,ih)':force_original_aspect_ratio=decrease,pad=$nw:$nh:(ow-iw)/2:(oh-ih)/2" -map 0 -c:a copy -c:s copy "$output"
# output="${1%.*}_adjvid.mp4"
# if [ "$output" = "$1" ]
# then
#   output="${1%.*}_adjvid.mp4"
# fi
# if [ "$width" -lt "$height" ]
# then
#    tm=$nh
#    nh=$nw
#    nw=$tm
#    echo "flipped to ($nw x $nh)"
# fi

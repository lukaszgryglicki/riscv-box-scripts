#!/bin/bash
# riscv64
# arecord -f S16_LE -d 10 -r 44100 --device='hw:0,1' record.wav
# amd64
# arecord -f S16_LE -c 2 -d 10 -r 44100 --device='hw:1,0' record.wav
arecord -f S32_LE -c2 -d 10 -r 48000 --device='hw:2,0' record.wav

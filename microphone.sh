#!/bin/bash
arecord -f S16_LE -d 10 -r 44100 --device='hw:0,1' record.wav

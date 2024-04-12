#!/bin/bash
export MESA_GL_VERSION_OVERRIDE=3.2COMPAT
export MESA_GLSL_VERSION_OVERRIDE=320

mpv --vo=x11 --profile=low-latency --ao=alsa --audio-device="alsa/dmix:CARD=LightSoundCard,DEV=0" "$@"

# mpv -vo x11 --ao=alsa --audio-device="alsa/dmix:CARD=LightSoundCard,DEV=0" "$@"
#mpv --vo=x11 --profile=sw-fast --ao=alsa --audio-device="alsa/dmix:CARD=LightSoundCard,DEV=0" "$@"
#mpv --vo=gpu --gpu-api=opengl --opengl-es=yes --ao=alsa --audio-device="alsa/dmix:CARD=LightSoundCard,DEV=0" "$@"
#  libmpv           render API for libmpv
#  gpu              Shader-based GPU Renderer
#  gpu-next         Video output based on libplacebo
#  vdpau            VDPAU with X11
#  wlshm            Wayland SHM video output (software scaling)
#  xv               X11/Xv
#  sdl              SDL 2.0 Renderer
#  dmabuf-wayland   Wayland dmabuf video output
#  vaapi            VA API with X11
#  x11              X11 (software scaling)
#  null             Null video output
#  image            Write video frames to image files
#  tct              true-color terminals
#  caca             libcaca
#  drm              Direct Rendering Manager (software scaling)
#  sixel            terminal graphics using sixels

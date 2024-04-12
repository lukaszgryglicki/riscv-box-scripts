qemu-system-x86_64 \
-m 4G \
-smp 2 \
-hda disk.qcow2 \
-boot d \
-cdrom debian-12.5.0-amd64-netinst.iso \
-vga virtio \
-net tap,ifname=tap0,script=no,downscript=no \
-net nic \
-audio driver=alsa,model=sb16 \
-display type=gtk,show-cursor=on \
-usbdevice mouse \
#-display type=sdl,gl=es,show-cursor=on
#-display egl-headless,gl=core,show-cursor=on \
#-cdrom debian-12.5.0-amd64-netinst.iso \
#-cdrom noble-mini-iso-amd64.iso \
#-cdrom FreeBSD-15.0-CURRENT-amd64-20240404-112783ebbc31-269103-disc1.iso \
#-net nic,model=virtio \
#-net tap,ifname=tap0,script=no,downscript=no,hostfwd=tcp::8080-:80 \
#-net tap,ifname=tap0,script=no,downscript=no \
#-device AC97 \
#-vga qxl \
#-enable-kvm \
#-netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 \
#-device virtio-net-pci,netdev=net0 \

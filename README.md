freenivi-os
=========

Freenivi OS contains the scripts needed to build freenivi images. The buildsystem is using Yocto/OpenEmbedded and the scripts comes from the Angstrom build system.


Supported boards
----------------

The following hardware are supported by the Freenivi team:
- Raspberry Pi
- Nitrogen6x


How to build
------------

This is a quick howto for building a fresh Freenivi image.

Before you need to get all required modules and configure for the wanted machine:

On a Debian or Ubuntu machine you have to install those dependencies :
```bash
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath libsdl1.2-dev xterm
```

```bash
./build.sh init <machine>
```

Then you can configure another machine you want to build to:
```bash
./build.sh config raspberrypi
```

Finally you can start a build using bitbake:
```bash
source ./env.sh
bitbake freenivi-image
```

You will find the images in build/tmp-freenivi-eglibc/deploy/images


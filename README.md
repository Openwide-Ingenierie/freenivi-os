Freenivi OS Builder
===================

Freenivi OS Builder is a tool to build the Freenivi SDK, images and emulator packages.

How to use it
-------------

First, source the file 'set-env.sh' (don't forget to do it at each new session):

     source set-env.sh

Next, create your local.conf file. This file is the base for all the local.conf for the build directories. Create it by copying the local.conf.sample file:

     cp local.conf.sample local.conf

It is interesting to set in local.conf the following value:
   - DL_DIR : where all the downloads will be
   - SSTATE_DIR : where the sstate cache will be

It is useful to share them between build, in order to speed up build process.
Make sure you don't use relative path or "~" in these paths.
It is also useful, if you are using meta-fsl-* layers, to put the license
accept variable in it once you have accepted the license:

     echo 'ACCEPT_FSL_EULA = "1"' >> local.conf

Then you can list the available targets using:

     ls targets/

You can also create your own target file by giving its path as the arguement.
Once you choose your target, call:

     layers config targets/<target>

You can specify the build directory using the '-d' option, and the sources directory using the '-s' option:

     layers config targets/<target> -d <build directory> -s <sources directory>

You can add '-j $(shell grep -c 'cpu cores' /proc/cpuinfo)' to speed up the synchronization (you canoot use it if you need to fill password or user).

Once the synchronization is finished, go into the build directory and call:

     cd <build directory>
     bitbake <bitbake target>

The freenivi bitbake targets are:
  - freenivi-image: build an image
  - freenivi-sdk: build the sdk already packaged
  - freenivi-package-image: build the image packaged
  - freenivi-emulator: build the emulator packaged (if the machine is correct)

_Note_: images and output files are then located in <build directory>/tmp/deploy
      and packages in <build directory>/tmp/deploy/installer-packages

You can generate the target file of the current state by calling:

     layers target <build directory> > <target file>

For more information, use:

     layers --help

The content of a target file is the following:
  - machine="<bitbake machine name>"
  - distro="<bitbake distro name>"
  - local="<additional local.conf line>"
  - layers="<space or newline separated list of bitbake layer name>"
  - manifest="<newline separated list of gits manifest line>"

A gits manifest line has the following format:

     [name],[uri],[branch],[revision]

You can directely change the git repositories using the gits tools:

     gits sync <manifest> -s <sources directory>

The manifest can be a "default" one or a file you give.
You can list the available "default" manifests calling:

     gits list-manifests

To clean a target, use the option '-c cleanall':

    bitbake -c cleanall <package name>

_Note_: '-c <task>' allows you to only do the task <task> (patch, compile, rootfs) for the target.
_Note_: '-c cleansstate' while not remove the downloads of the target.

To force the execution of the task, add -f option:

    bitbake -f -c <task> <package name>

_Note_: after building a target like freenivi-image, the folder tmp/deploy/image is populated. The file *.sdcard can be used directly to configure an SD Card with the following command:

    sudo dd if=/path/to/freenivi-image-...rootfs.sdcard of=/dev/mmcblk0

All data will be lost. SD Card partitions must be unmounted.

How it works
------------

layers first will use gits, with the manifest in the target file, to get the git repositories. It then create the bblayers.conf file, finding the path of the layers into the repositories. To finish, it create the local.conf by copying the one in the base directory and adding the local, machine et distro variable from the target file.

Examples
--------

Get the bitbake build directory and sources for sabrelite target:

    layers config sabrelite

Reconfigure the bitbake build directory without changing the sources:

    layers config sabrelite -f -n

Get the bitbake build directory for sabrelite and nitrogen targets, using the sabrelite sources for both:

    layers config sabrelite -s sources
    layers config nitrogen -s sources -n

Change the source state of the directory sources to use the manifest master:

    gits sync master -s sources

Problems
--------

P-FNO-1: 

> Compilation error in LuaJIT package have been reported in some cases. They might be due to missing dependancy on the host. If you experiment "sys/types.h: No such file or directory errors", you might need to install on your Debian based distribution the package libc6-dev-i386.

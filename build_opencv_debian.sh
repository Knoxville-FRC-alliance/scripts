#!/bin/bash
# code to build opencv on debian platforms (works on ubuntu, raspbian, etc)
# this will create a file called opencv-ARCH.tar.gz where ARCH is your architecture
# to install, run "sudo tar xfv opencv-ARCH.tar.gz -C /usr/local"


OPENCV_TAR="https://github.com/opencv/opencv/archive/3.4.0.tar.gz"

MAIN_DIR="$PWD"

if [ "$EUID" -ne "0" ]; then
    printf "ERROR: must be root\n"
    sudo $0 $@
    exit $?
fi

# dependencies to build
sudo apt-get -y install python3-dev build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

cd output/
rm -rf opencv*

mkdir opencv_out
OUTPUT_DIR="$PWD/opencv_out"

curl -L $OPENCV_TAR > opencv.tar.gz
tar xf opencv.tar.gz
mv opencv-* opencv_code/
mkdir opencv_code/build; cd opencv_code/build

cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=$OUTPUT_DIR -DWITH_OPENMP=ON

time make -j $(nproc)

make install

echo "that was the time with $(nproc) jobs"


cd $OUTPUT_DIR

tar cJf $MAIN_DIR/opencv-$(uname -m).tar.gz ./*




#!/bin/bash
# code to build opencv on debian platforms (works on ubuntu, raspbian, etc)

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
tar xfv opencv.tar.gz
mv opencv-* opencv_code/
mkdir opencv/build; cd opencv/build

cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=$OUTPUT_DIR -DWITH_OPENMP=ON

make -j $(nproc)

cd $OUTPUT_DIR

tar cJf $MAIN_DIR/opencv-$(uname -m).tar.gz ./*




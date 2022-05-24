#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
#echo $SHELL_FOLDER
TO_INCLUDE_DIR=$SHELL_FOLDER/../third_party/include/
TO_LIB_DIR=$SHELL_FOLDER/../third_party/lib/
TO_DIR=$SHELL_FOLDER/../third_party/

if [ ! -d "$SHELL_FOLDER/../third_party" ]; then
    echo "../third_party not exist."
    exist 1
fi

function build_yaml-cpp() {
    dir=$1
    cd $SHELL_FOLDER/$dir/ && rm -rf build
    mkdir build && cd build
    cmake .. && make -j4
    cp libyaml-cpp.a $TO_LIB_DIR
    cp -r ../include/yaml-cpp $TO_INCLUDE_DIR
}

#function build_librdkafka() {
#    dir=$1
#    cd $SHELL_FOLDER/$dir/
#    find . | xargs fromdos
#    ./configure --enable-static \
#                --prefix=/usr/local/librdkakfa \
#                --install-deps \
#                && make && make install
#    mkdir -p $TO_DIR/librdkafka
#    cp -r /usr/local/librdkakfa/* $TO_DIR/librdkafka/
#}

function build_cppkafka() {
    apt install librdkafka-dev

    dir=$1
    cd $SHELL_FOLDER/$dir/ && rm -rf build
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/cppkafka .. && make -j4 && make install

    mkdir -p $TO_DIR/librdkafka/include $TO_DIR/librdkafka/lib
    cp -r /usr/include/librdkafka/* $TO_DIR/librdkafka/include/
    cp /usr/local/lib/*kafka* $TO_DIR/librdkafka/lib/

    cp -r /usr/local/cppkafka $TO_DIR
}

#build_yaml-cpp submodules/yaml-cpp
build_cppkafka submodules/cppkafka

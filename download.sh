#!/bin/bash

targets=(
    "https://mecab.googlecode.com/files/ mecab-0.996.tar.gz"
    "https://mecab.googlecode.com/files/ mecab-ipadic-2.7.0-20070801.tar.gz"
    "https://repo.continuum.io/archive/ Anaconda3-2.5.0-Linux-x86_64.sh"
    "https://github.com/dmlc/xgboost/archive/ xgboost-0.47.tar.gz 0.47.tar.gz"
    "https://storage.googleapis.com/tensorflow/linux/cpu/ tensorflow-0.7.0-py3-none-linux_x86_64.whl"
)

for target in "${targets[@]}"; do
    items=($target)
    site=${items[0]}
    file=${items[1]}
    arch=${items[2]}
    if [ $arch ]; then
        if [ ! -f ${file} ]; then
            wget $site$arch && mv $arch $file
        fi
    elif [ ! -f ${file} ]; then
        wget $site$file
    fi
done

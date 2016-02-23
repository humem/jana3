#!/bin/bash

if [ ! -f mecab-0.996.tar.gz ]; then
    wget https://mecab.googlecode.com/files/mecab-0.996.tar.gz
fi
if [ ! -f mecab-ipadic-2.7.0-20070801.tar.gz ]; then
    wget https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
fi
if [ ! -f Anaconda3-2.5.0-Linux-x86_64.sh ]; then
    wget https://repo.continuum.io/archive/Anaconda3-2.5.0-Linux-x86_64.sh
fi
if [ ! -f xgboost-0.47.tar.gz ]; then
    wget https://github.com/dmlc/xgboost/archive/0.47.tar.gz
    mv 0.47.tar.gz xgboost-0.47.tar.gz
fi
if [ ! -f tensorflow-0.7.0-py3-none-linux_x86_64.whl ]; then
    wget https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.0-py3-none-linux_x86_64.whl
fi

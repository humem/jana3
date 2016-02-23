FROM ubuntu:14.04

WORKDIR /root

# for build
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        g++ \
        make \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV build_opt -j4

# mecab
COPY mecab-0.996.tar.gz .
#RUN wget -q https://mecab.googlecode.com/files/mecab-0.996.tar.gz && \
RUN tar -xzf mecab-0.996.tar.gz && \
    cd mecab-0.996 && \
    ./configure --enable-utf8-only && \
    make $build_opt && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf mecab*

# ipadic
COPY mecab-ipadic-2.7.0-20070801.tar.gz .
#RUN wget -q https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz && \
RUN tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz && \
    cd mecab-ipadic-2.7.0-20070801 && \
    ./configure --with-charset=utf8 && \
    make $build_opt && \
    make install && \
    cd .. && \
    rm -rf mecab-ipadic*

RUN echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc

# for matplotlib
RUN apt-get update && apt-get install -y --no-install-recommends \
        fonts-takao \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# anaconda3
COPY Anaconda3-2.5.0-Linux-x86_64.sh .
#RUN wget -q https://repo.continuum.io/archive/Anaconda3-2.5.0-Linux-x86_64.sh && \
RUN /bin/bash Anaconda3-2.5.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda*

ENV PATH /opt/conda/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN conda update --all -y && conda install gensim seaborn

RUN pip install mecab-python3 zenhan
RUN pip install chainer

# xgboost
COPY xgboost-0.47.tar.gz .
#RUN wget -q https://github.com/dmlc/xgboost/archive/0.47.tar.gz && \
#    mv 0.47.tar.gz xgboost-0.47.tar.gz && \
RUN tar -xzf xgboost-0.47.tar.gz && \
    cd xgboost-0.47 && \
    make $build_opt && \
    cd python-package && \
    python setup.py install && \
    cd ../.. && \
    rm -rf xgboost*

# tensorflow
COPY tensorflow-0.7.0-py3-none-linux_x86_64.whl .
RUN pip install --upgrade tensorflow-0.7.0-py3-none-linux_x86_64.whl
#RUN pip install --upgrade \
#        https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.0-py3-none-linux_x86_64.whl

RUN python -c "import matplotlib.pyplot"

WORKDIR /work

CMD ["ipython"]

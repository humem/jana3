FROM jupyter/datascience-notebook

# setup for build
ENV build_opt -j4
USER root
WORKDIR /tmp

# pre-requisites for build
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        g++ \
        make \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install mecab
#COPY mecab-0.996.tar.gz .
#RUN \
RUN wget -q https://mecab.googlecode.com/files/mecab-0.996.tar.gz && \
    tar -xzf mecab-0.996.tar.gz && \
    cd mecab-0.996 && \
    ./configure --enable-utf8-only && \
    make $build_opt && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf mecab*

# install ipadic
#COPY mecab-ipadic-2.7.0-20070801.tar.gz .
#RUN \
RUN wget -q https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz && \
    tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz && \
    cd mecab-ipadic-2.7.0-20070801 && \
    ./configure --with-charset=utf8 && \
    make $build_opt && \
    make install && \
    cd .. && \
    rm -rf mecab-ipadic*

# configure mecab with ipadic
RUN echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc

# matplotlib dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        fonts-takao \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# setup python/conda
USER $NB_USER

# install conda packages
RUN conda install --yes \
        gensim \
        && \
    conda clean -yt

# initialize matplotlib
RUN python -c "import matplotlib.pyplot"

# install xgboost
#COPY xgboost-0.47.tar.gz .
#RUN \
RUN wget -q https://github.com/dmlc/xgboost/archive/0.47.tar.gz && \
    mv 0.47.tar.gz xgboost-0.47.tar.gz && \
    tar -xzf xgboost-0.47.tar.gz && \
    cd xgboost-0.47 && \
    make $build_opt && \
    cd python-package && \
    python setup.py install
# workaround for xgboost
RUN cd /opt/conda/lib && \
    mv libgomp.so.1.0.0 libgomp.so.1.0.0.orig && \
    ln -s /usr/lib/x86_64-linux-gnu/libgomp.so.1.0.0 .

# install tensorflow
#COPY tensorflow-0.7.1-cp34-none-linux_x86_64.whl .
#RUN \
RUN wget -q https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.1-cp34-none-linux_x86_64.whl && \
    ln -s tensorflow-0.7.1-cp34-none-linux_x86_64.whl tensorflow-0.7.1-cp35-none-linux_x86_64.whl && \
    pip install tensorflow-0.7.1-cp35-none-linux_x86_64.whl
RUN pip install skflow

# install pypi packages
RUN pip install \
        chainer \
        mecab-python3 \
        zenhan

# clean up
USER root
RUN rm -rf xgboost* tensorflow*

# run
USER $NB_USER
WORKDIR /work
CMD ["ipython"]

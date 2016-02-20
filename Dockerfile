FROM continuumio/anaconda3

# gcc for building mecab
RUN apt-get update && apt-get install -y --no-install-recommends \
            g++ \
            gcc \
            libc6-dev \
            make \
        && rm -rf /var/lib/apt/lists/*

# mecab
WORKDIR /root
RUN wget -q https://mecab.googlecode.com/files/mecab-0.996.tar.gz \
        && tar -xzf mecab-0.996.tar.gz \
        && cd mecab-0.996 \
        && ./configure --enable-utf8-only \
        && make \
        && make install \
        && ldconfig \
        && cd .. \
        && rm -rf mecab-*

# ipadic
RUN wget -q https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz \
        && tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz \
        && cd mecab-ipadic-2.7.0-20070801 \
        && ./configure --with-charset=utf8 \
        && make \
        && make install \
        && cd .. \
        && rm -rf mecab-ipadic-*
RUN echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc

RUN conda update --all -y && conda install gensim

RUN pip install mecab-python3 zenhan

RUN python -c "import matplotlib.pyplot"

WORKDIR /work
CMD ["ipython"]

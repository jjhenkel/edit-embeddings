FROM debian:9.6

RUN apt-get update --fix-missing \
  && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      locales         \
      wget            \
      bzip2           \
      ca-certificates \
      curl            \
      git             \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# C.UTF-8 UTF-8/C.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure \
       --frontend=noninteractive locales \
  && update-locale LANG=C.UTF-8

ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TINI_VERSION=v0.16.1 \
  MINICONDA_VERSION=4.5.11-Linux-x86_64 \
  PATH=/opt/conda/bin:$PATH

RUN wget --quiet \
      https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}.sh \
      -O ~/miniconda.sh \
  && /bin/bash ~/miniconda.sh -b -p /opt/conda \
  && rm ~/miniconda.sh \
  && /opt/conda/bin/conda clean -tipsy \
  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
  && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
  && echo "conda activate base" >> ~/.bashrc

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    /usr/bin/tini

RUN chmod +x /usr/bin/tini \
  && conda install \
       pytorch-cpu \
       torchvision-cpu \
       -c pytorch \
  && conda install tqdm \
  && conda install -c conda-forge tensorboardx

ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/bin/bash" ]

FROM ubuntu

ARG USERNAME=foo
ARG UID=1000

RUN apt-get update \
 && apt-get -y upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gcc g++ automake cmake libtool pkgconf \
    libjson-c-dev libboost-dev libcereal-dev \
    git vim fuse sudo curl wget \
    libfuse-dev libssl-dev

RUN \
  # sshd
  apt-get -y install --no-install-recommends \
    openssh-server \
  # sshd_config
  && printf '%s\n' \
    'PermitRootLogin yes' \
    'PasswordAuthentication yes' \
    'PermitEmptyPasswords yes' \
    'UsePAM no' \
    > /etc/ssh/sshd_config.d/auth.conf \
  # ssh_config
  && printf '%s\n' \
    'Host *' \
    '    StrictHostKeyChecking no' \
    > /etc/ssh/ssh_config.d/ignore-host-key.conf

RUN id $UID && userdel $(id -un $UID) || : \
 && useradd -m -u $UID -s /bin/bash $USERNAME \
 && echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME \
 # delete passwd
 && passwd -d $USERNAME

ARG LIBFABRIC_VER=1.22.0

RUN cd \
 && wget https://github.com/ofiwg/libfabric/archive/refs/tags/v$LIBFABRIC_VER.tar.gz \
 && tar zxfp v$LIBFABRIC_VER.tar.gz \
 &&  cd libfabric-$LIBFABRIC_VER \
 && ./autogen.sh \
 && mkdir build && cd build \
 && ../configure \
 && make -j $(nproc) && make install \
 && ldconfig

ARG MERCURY_VER=2.4.0

RUN cd \
 && wget https://github.com/mercury-hpc/mercury/archive/refs/tags/v$MERCURY_VER.tar.gz \
 && tar zxfp v$MERCURY_VER.tar.gz \
 && cd mercury-$MERCURY_VER \
 && mkdir build && cd build \
 && cmake -DNA_USE_OFI:BOOL=ON -DMERCURY_USE_BOOST_PP:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_BUILD_TYPE:STRING=Debug .. \
 && make -j $(nproc) && make install \
 && ldconfig

ARG ARGOBOTS_VER=1.2

RUN cd \
 && wget https://github.com/pmodels/argobots/releases/download/v$ARGOBOTS_VER/argobots-$ARGOBOTS_VER.tar.gz \
 && tar zxfp argobots-$ARGOBOTS_VER.tar.gz \
 && cd argobots-$ARGOBOTS_VER \
 && mkdir build && cd build \
 && ../configure --enable-perf-opt --enable-affinity --disable-checks \
 && make -j $(nproc) && make install \
 && ldconfig

ARG MARGO_VER=0.18.3

RUN cd \
 && wget https://github.com/mochi-hpc/mochi-margo/archive/refs/tags/v$MARGO_VER.tar.gz \
 && tar zxfp v$MARGO_VER.tar.gz \
 && cd mochi-margo-$MARGO_VER \
 && ./prepare.sh \
 && mkdir build && cd build \
 && ../configure \
 && make -j $(nproc) && make install \
 && ldconfig

ARG THALLIUM_VER=0.14.6

RUN cd \
 && wget https://github.com/mochi-hpc/mochi-thallium/archive/refs/tags/v$THALLIUM_VER.tar.gz \
 && tar zxfp v$THALLIUM_VER.tar.gz \
 && cd mochi-thallium-$THALLIUM_VER \
 && mkdir build && cd build \
 && cmake .. \
 && make -j $(nproc) && make install \
 && ldconfig

USER $USERNAME
RUN cd \
 && printf '%s\n' \
    'export PATH=$HOME/workspace/bin:$PATH' \
    >> .bashrc

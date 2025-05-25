FROM ubuntu

ARG USERNAME=foo
ARG UID=1000

RUN apt-get update \
 && apt-get -y upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gcc g++ automake cmake libtool pkgconf \
    git python3 curl wget bzip2 xz-utils sudo vim \
    libfuse-dev fuse

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

USER $USERNAME
RUN cd \
 && git clone -c feature.manyFiles=true --depth 1 https://github.com/spack/spack.git \
 && . spack/share/spack/setup-env.sh \
 && (cd spack && git clone https://github.com/mochi-hpc/mochi-spack-packages.git && spack repo add mochi-spack-packages) \
 && spack external find autoconf automake libtool cmake m4 pkgconf \
 && spack install mochi-thallium ^mercury~boostsys ^libfabric fabrics=rxm,sockets,tcp,udp \
 && printf '%s\n' \
    '. $HOME/spack/share/spack/setup-env.sh' \
    'export PATH=$HOME/workspace/bin:$PATH' \
    'export LD_LIBRARY_PATH=$HOME/workspace/lib:$LD_LIBRARY_PATH' \
    >> .bashrc

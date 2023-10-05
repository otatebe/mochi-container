FROM ubuntu

ARG USERNAME=foo
ARG UID=1000

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y install gcc automake \
 && apt-get -y install cmake libtool pkgconf \
 && apt-get -y install git python3 bison fuse sudo vim curl \
 && apt-get -y install libfuse-dev libssl-dev

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

RUN useradd -m -u $UID -s /bin/bash $USERNAME \
 && echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME \
 # delete passwd
 && passwd -d $USERNAME

USER $USERNAME
RUN cd \
 && git clone -c feature.manyFiles=true --depth 1 https://github.com/spack/spack.git \
 && . spack/share/spack/setup-env.sh \
 && spack external find automake autoconf libtool cmake m4 pkgconf bison \
 && spack install mochi-margo ^mercury~boostsys ^libfabric fabrics=rxm,sockets,tcp,udp \
 && spack install mochi-thallium \
 && printf '%s\n' \
    '. $HOME/spack/share/spack/setup-env.sh' \
    'export PATH=$HOME/workspace/bin:$PATH' \
    'export LD_LIBRARY_PATH=$HOME/workspace/lib:$LD_LIBRARY_PATH' \
    >> .bashrc

FROM ubuntu

ARG USERNAME=mochi
ARG UID=1000

RUN apt-get update \
 && apt-get -y upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gcc g++ automake cmake libtool pkgconf hwloc libhwloc-dev \
    locales git python3 curl wget bzip2 xz-utils sudo vim \
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

RUN if [ "$UID" -eq 0 ]; then \
      # host is root (e.g. Codespaces): make $USERNAME an alias of UID 0
      useradd -o -m -u 0 -g 0 -s /bin/bash $USERNAME; \
    else \
      (id $UID && userdel $(id -un $UID) || :) \
      && useradd -m -u $UID -s /bin/bash $USERNAME; \
    fi \
 && echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME \
 # delete passwd
 && passwd -d $USERNAME \
 && locale-gen en_US.UTF-8

USER $USERNAME
# when UID is 0, HOME would otherwise resolve to /root
ENV HOME=/home/$USERNAME
RUN cd \
 && git clone -c feature.manyFiles=true --depth 1 https://github.com/spack/spack.git \
 && . spack/share/spack/setup-env.sh \
 && spack external find autoconf automake libtool cmake m4 coreutils hwloc pkgconf \
 && spack install mochi-thallium ^mercury~boostsys ^libfabric fabrics=rxm,sockets,tcp,udp \
 && printf '%s\n' \
    '. $HOME/spack/share/spack/setup-env.sh' \
    'export PATH=$HOME/workspace/bin:$PATH' \
    'export LD_LIBRARY_PATH=$HOME/workspace/lib:$LD_LIBRARY_PATH' \
    >> .bashrc

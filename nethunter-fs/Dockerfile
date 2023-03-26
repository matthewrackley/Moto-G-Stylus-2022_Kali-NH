############################################################
# Dockerfile to build a Kali NetHunter chroot Filesystem
############################################################

# Set the base image to Kali
FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
  && apt-get -y dist-upgrade \
  && apt-get clean

RUN apt-get install -y \
  abootimg \
  apt \
  autoconf \
  automake \
  bc \
  binfmt-support \
  bison \
  build-essential \
  ccache \
  cgpt \
  curl \
  debootstrap \
  device-tree-compiler \
  dos2unix \
  dosfstools \
  e2fsprogs \
  flex \
  g++-multilib \
  gcc-multilib \
  git \
  git-core \
  gnupg \
  gperf \
  kpartx \
  libncurses5-dev \
  lzma \
  lzop \
  m4 \
  nano \
  parted \
  pixz \
  qemu-user-static \
  rsync \
  schedtool \
  sudo \
  u-boot-tools \
  vboot-kernel-utils \
  zip \
  zlib1g-dev

ENV KALI_WORKSPACE /root/nethunter-fs
RUN mkdir -p ${KALI_WORKSPACE}
COPY . ${KALI_WORKSPACE}
WORKDIR ${KALI_WORKSPACE}

CMD ["/root/nethunter-fs/build.sh", "-f"]

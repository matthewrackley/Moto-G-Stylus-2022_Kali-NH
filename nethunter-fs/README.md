# Kali NetHunter FileSystem (FS) - chroot Builder

Build a basic [Kali NetHunter](https://www.kali.org/get-kali/#kali-mobile) chroot filesystem.

- - -

## Docker

**[Dockerfile](Dockerfile)**:

```bash
docker build -t nethunter .
docker run --privileged --name nethunter_build -i -t nethunter 2>&1 | tee output.log
docker cp nethunter_build:/root/nethunter-fs/output .
```

**[Docker registry](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/container_registry)**:

```bash
./docker-push-gitlab.sh
```

- - -

## Installer

### Dependencies

This could be built on any [Debian-based](https://www.debian.org/derivatives/) system but we recommend building on [Kali Linux](https://www.kali.org/).

```bash
apt install -y abootimg autoconf automake bc bison build-essential ccache \
  cgpt curl debootstrap debootstrap device-tree-compiler dos2unix dosfstools \
  e2fsprogs flex g++-multilib gcc-multilib git git-core gnupg gperf kpartx \
  libncurses5-dev lzma lzop m4 parted pixz qemu-user-static rsync schedtool \
  u-boot-tools vboot-kernel-utils vboot-utils xz-utils zip zlib1g-dev
```

### Examples

To create a **full** Kali NetHunter filesystem:

```bash
./build.sh -f
```

To create a **minimal** Kali NetHunter filesystem:

```bash
./build.sh -m
```


Sun May 29 22:51:35 UTC 2022

# Kali NetHunter - Mobile Penetration Testing Platform

[Kali NetHunter](](https://www.kali.org/get-kali/#kali-mobile)) is a Mobile Penetration Testing Platform.

[![Kali NetHunter Logo](./images/nethunter-git-logo.png)](./images/nethunter-git-logo.png)

<!--
The Kali NetHunter project is the first Open-source Android penetration testing platform for Android devices, allowing for access to the Kali toolset from various supported Android devices. There are multiple unique features not possible on other hardware platforms.

The Kali NetHunter interface allows you to easily work with complex configuration files through a local web interface. This feature, together with a custom kernel that supports 802.11 wireless injection and preconfigured connect back VPN services, make the Kali NetHunter a formidable network security tool or discrete drop box - with Kali Linux at the tip of your fingers wherever you are!
-->

Kali NetHunter is an **Android** penetration testing platform targeted towards Nexus and OnePlus devices built on top of [Kali Linux](https://www.kali.org/), which includes some special and unique features.

Of course, you have **all the usual Kali tools** in NetHunter as well as the ability to get a **full VNC session** from your phone to a graphical Kali [chroot](https://www.kali.org/docs/nethunter/nethunter-chroot-manager/), however the strength of NetHunter does not end there.

We've incorporated some amazing features into Kali NetHunter OS which are both powerful and bespoke. From **pre-programmed [HID](https://www.kali.org/docs/nethunter/nethunter-hid-attacks/) Keyboard (Teensy) attacks**, to **[BadUSB](https://www.kali.org/docs/nethunter/nethunter-badusb/) Man In The Middle attacks**, to **one-click [MANA](https://www.kali.org/docs/nethunter/nethunter-mana-wireless/) Evil Access Point setups**, as well as access to the **[Exploit-database](https://www.kali.org/docs/nethunter/nethunter-searchsploit/)**.

And yes, Kali NetHunter natively **supports wireless 802.11 frame injection** with a variety of supported USB NICs.

## Repository Structure

- [./nethunter-fs/](nethunter-fs/) - Kali NetHunter FileSystem (FS) - chroot Builder + [scripts](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-utils) <!-- aka /rootfs/ -> https://kali.download/nethunter-images/current/rootfs/ -->
- [./nethunter-installer/](nethunter-installer/) - Kali NetHunter Installer <!-- aka /images/ -> https://kali.download/nethunter-images/current/ -->
  - [./nethunter-installer/devices/](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-devices) - all the [pre-compiled kernels](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-kernel), kernel modules, and installation scripts
- [./nethunter-rootless/](nethunter-rootless/) - Kali NetHunter (Rootless Edition)

## Documentation and Attack Descriptions

Attack descriptions as well as some documentation to get you started with the installation and setup of Kali NetHunter can be found at: <https://www.kali.org/docs/nethunter/>

## Is Kali NetHunter an Android ROM?

Kali NetHunter is **not** a ROM but is meant to be installed over an existing stock/factory image of Android. It can also be installed over some Cyanogenmod based ROMs depending on device support. It is heavily based on using custom kernels and only supports a select number of devices.

We're relying on you, the community, to port your devices for the full Kali NetHunter experience.

## Frequently Asked Questions

**Q** - Does Kali NetHunter support Marshmallow, or Nexus 9 devices?

**A** - Yes, check our wiki for more information on supported devices and ROMs: <https://www.kali.org/docs/nethunter/#20-nethunter-supported-devices-and-roms>

- - -

**Q** - What kind of attacks does Kali NetHunter support?

**A** - Our wiki has a list of included attack tools: <https://www.kali.org/docs/nethunter/#70-kali-nethunter-attacks-and-features>

- - -

**Q** - Kali NetHunter is awesome! How do I install it?

**A** - Follow the instructions on the wiki: <https://www.kali.org/docs/nethunter/#50-installing-nethunter-on-top-of-android>

- - -

**Q** - What is the best wireless card for Kali NetHunter?

**A** - A list of supported devices and chipsets is on the wiki: <https://www.kali.org/docs/nethunter/wireless-cards/>


Sun May 29 22:51:35 UTC 2022

# emerge_AppImage
> emerge AppImage to remove and install Gentoo Linux ebuilds that is needed for installing and removing packages.

## How to use it:
```
$ chmod +x emerge-{VERSION}.AppImage
$ ./emerge-{VERSION}.AppImage -pv sys-apps/portage
```
* Note that the options `--root=/mnt/host --config-root=/mnt/host` are already included internally.
* This is one implementation of the idea: https://wiki.gentoo.org/wiki/Upgrading_Gentoo#Updating_old_systems
* **Use this with caution**, as there is no guarantee of any kind, and you will be **running it as root**.
* It uses the defaults paths (and don't work with others path yet):
  - **PORTDIR="/var/db/repos/gentoo"**
  - **DISTDIR="/var/cache/distfiles"**
  - **PKGDIR="/var/cache/binpkgs"**

#!/bin/bash
export STAGE3_URL="https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20201004T214503Z/stage3-amd64-20201004T214503Z.tar.xz"
export STAGE3_FILENAME="${STAGE3_URL##*/}"
export STAGE3_NAME="${STAGE3_FILENAME%???????}"

echo "STAGE3_FILENAME: ${STAGE3_FILENAME}"
echo "STAGE3_NAME: ${STAGE3_NAME}"
echo "NAME format: emerge-${STAGE3_NAME}.AppImage"

WORKDIR="workdir"
#=================================================
die() { echo >&2 "$*"; exit 1; };
#=================================================

mkdir "${WORKDIR}"

# Get stage3:
echo "Downloading ${STAGE3_FILENAME} ..."
wget -c "${STAGE3_URL}"

tar xf ${STAGE3_FILENAME} -C "${WORKDIR}"/

mkdir -p ${WORKDIR}/mnt/host

cat > "${WORKDIR}"/etc/resolv.conf << EOF
domain home
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

cat > "${WORKDIR}"/emerge.sh << EOF
#!/bin/bash
source /etc/profile
export ACCEPT_LICENSE="*"
emerge --root=/mnt/host --config-root=/mnt/host \$@
EOF

chmod +x "${WORKDIR}"/emerge.sh

mkdir -p ${WORKDIR}/var/db/repos
mkdir -p ${WORKDIR}/var/cache/distfiles
mkdir -p ${WORKDIR}/var/cache/binpkgs

rm -rf ${WORKDIR}/var/log
mkdir -p ${WORKDIR}/var/log

mkdir -p ${WORKDIR}/usr/src/linux
mkdir -p ${WORKDIR}/lib/modules
#=================================================

wget -nv -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage

chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun ${WORKDIR}
cp resource/* ${WORKDIR}

#-------
./appimagetool.AppImage --appimage-extract
rm ./appimagetool.AppImage

export ARCH=x86_64; squashfs-root/AppRun -v ${WORKDIR} -u 'gh-releases-zsync|ferion11|emerge_Appimage|continuous|emerge-${STAGE3_NAME}.AppImage.zsync' emerge-${STAGE3_NAME}.AppImage

#!/bin/bash
# This file is premade by valve and I didn't add too much. All of the work was done already too, and I just modified it.

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
cd "${TOP}"

# do the setup stuff
mkdir -p xash3d/build
mkdir -p hlsdk-xash3d/build

# cd "$(xash3d/build "$0")"

(cd xash3d/build; cmake -DXASH_SDL=yes -DXASH_VGUI=no -DXASH_NANOGL=yes -DCMAKE_TOOLCHAIN_FILE="${MARVELL_SDK_PATH}/toolchain/steamlink-toolchain.cmake" ../ || exit 2)
(cd xash3d/build; make $MAKE_J || exit 2)

echo "now onto the half life sdk files"

(cd hlsdk-xash3d/build; cmake -DCMAKE_TOOLCHAIN_FILE="${MARVELL_SDK_PATH}/toolchain/steamlink-toolchain.cmake" ../ || exit 2)
(cd hlsdk-xash3d/build; make $MAKE_J || exit 2)
# cmake -DXASH_SDL=yes -DXASH_VGUI=no ../



# make $MAKE_J || exit 2

export DESTDIR="${PWD}/steamlink/apps/halflife-link"

# Copy the files to the app directory
mkdir -p "${DESTDIR}"
cp -v xash3d/build/engine/libxash.so xash3d/build/game_launch/xash3d xash3d/build/mainui/libxashmenu.so "${DESTDIR}"
cp -v xash3d/scripts/xash3d.sh "${DESTDIR}"
cp -vr valve "${DESTDIR}"
cp -vfr xash-extras/. "${DESTDIR}/valve/"
rm -rf "${DESTDIR}/valve/.git"
rm -f "${DESTDIR}/valve/cl_dlls/client.so" "${DESTDIR}/valve/dlls/hl.so"
cp -vf hlsdk-xash3d/build/cl_dll/client.so "${DESTDIR}/valve/cl_dlls"
cp -vf hlsdk-xash3d/build/dlls/hl.so "${DESTDIR}/valve/dlls"
cp -v hlogo.png "${DESTDIR}"
cp -v getconf "${DESTDIR}"
cp -v start.sh "${DESTDIR}"

# REMOVE THIS LATER
# rm -rf xash3d/build
# rm -rf hlsdk-xash3d/build

# Create the table of contents and icon
cat >"${DESTDIR}/toc.txt" <<__EOF__
name=Half-Link
icon=hlogo.png
run=start.sh
__EOF__

# Pack it up
name=$(basename ${DESTDIR})
pushd "$(dirname ${DESTDIR})"
tar zcvf $name.tgz $name || exit 3
rm -rf $name
popd

# All done!
echo "Build complete!"
echo
echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install. The first method works, but a faster method is to enable SSH and scp the halflife folder itself to \"/home/apps\" because the first method takes a very long time. Example: cd to the steamlink/apps folder in the halflife dir, then uncompress the folder and \"scp -r halflife-link root@[steam link IP]:/home/apps\""

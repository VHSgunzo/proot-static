#!/bin/bash
set -e

export MAKEFLAGS="-j$(nproc)"

# WITH_UPX=1

platform="$(uname -s)"
platform_arch="$(uname -m)"

if [ -x "$(which apt 2>/dev/null)" ]
    then
        apt update && apt install -y \
            build-essential clang pkg-config git libtalloc-dev uthash-dev upx
fi

if [ -d build ]
    then
        echo "= removing previous build directory"
        rm -rf build
fi

if [ -d release ]
    then
        echo "= removing previous release directory"
        rm -rf release
fi

# create build and release directory
mkdir build
mkdir release
pushd build

# download proot
git clone https://github.com/proot-me/proot.git
proot_version="$(cd proot && git describe --long --tags|sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g')"
mv proot "proot-${proot_version}"
echo "= downloading proot v${proot_version}"

if [ "$platform" == "Linux" ]
    then
        export CFLAGS="-static"
        export LDFLAGS='--static'
    else
        echo "= WARNING: your platform does not support static binaries."
        echo "= (This is mainly due to non-static libc availability.)"
fi

echo "= building proot"
rm -fv "$(which python3)" "$(which python3-config)"
pushd proot-${proot_version}
env CFLAGS="$CFLAGS -g -O2 -Os -ffunction-sections -fdata-sections" \
    LDFLAGS="$LDFLAGS -Wl,--gc-sections" make -C src proot
popd # proot-${proot_version}

popd # build

shopt -s extglob

echo "= extracting proot binary"
mv build/proot-${proot_version}/src/proot release 2>/dev/null

echo "= striptease"
strip -s -R .comment -R .gnu.version --strip-unneeded release/proot 2>/dev/null

if [[ "$WITH_UPX" == 1 && -x "$(which upx 2>/dev/null)" ]]
    then
        echo "= upx compressing"
        upx -9 --best release/proot 2>/dev/null
fi

echo "= create release tar.xz"
tar --xz -acf proot-static-v${proot_version}-${platform_arch}.tar.xz release
# cp proot-static-*.tar.xz ~/ 2>/dev/null

if [ "$NO_CLEANUP" != 1 ]
    then
        echo "= cleanup"
        rm -rf release build
fi

echo "= proot v${proot_version} done"

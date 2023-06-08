# Maintainer: VHSgunzo <vhsgunzo.github.io>

pkgname='proot-me'
_pkgname='proot'
pkgver=5.4.0.r2.g5f780cb
pkgrel=1
pkgdesc='PRoot is a user-space implementation of chroot, mount --bind, and binfmt_misc without privilege/setup'
arch=('any')
url='https://proot-me.github.io'
license=('GPL')
provides=('proot')
conflicts=('proot' 'proot-bin' 'proot-git')
depends=('talloc')
makedepends=('python-docutils' 'libxslt')
# Build with Python
# depends=('talloc' 'python')
# makedepends=('python-docutils' 'libxslt' 'python-libseccomp')
source=("git+https://github.com/proot-me/${_pkgname}.git")
sha1sums=('SKIP')

pkgver() {
    cd "$srcdir/${_pkgname}"
    git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
    cd "${srcdir}/${_pkgname}/src"
    make HAS_PYTHON_CONFIG= -f GNUmakefile

    cd "${srcdir}/${_pkgname}/doc"
    make HAS_PYTHON_CONFIG= -f GNUmakefile
}

# Build with Python
# build() {
#     cd "${srcdir}/${_pkgname}/src"
#     make -f GNUmakefile
#
#     cd "${srcdir}/${_pkgname}/doc"
#     make -f GNUmakefile
# }

package() {
    cd "${srcdir}/${_pkgname}"

    install -m755 -d "${pkgdir}/usr/bin"
    install -m755 "src/${_pkgname}" "${pkgdir}/usr/bin"

    install -m755 -d "${pkgdir}/usr/share/man/man1/"
    install -m644 -T 'doc/proot/man.1' "${pkgdir}/usr/share/man/man1/${_pkgname}.1"

    install -m755 -d "${pkgdir}/usr/share/doc/proot/"

    install -m644 'CHANGELOG.rst' "${pkgdir}/usr/share/doc/proot"
    install -m644 'doc/proot/index.html' "${pkgdir}/usr/share/doc/proot"
    install -m644 'doc/proot/manual.rst' "${pkgdir}/usr/share/doc/proot"

    install -m755 -d "${pkgdir}/usr/share/doc/proot/stylesheets"
    install -m644 'doc/proot/stylesheets/'* "${pkgdir}/usr/share/doc/proot/stylesheets"
}

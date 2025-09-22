# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="slstatus - status monitor for windows managers"
HOMEPAGE="https://tools.suckless.org/slstatus/"
SRC_URI="https://dl.suckless.org/tools/slstatus-1.1.tar.gz"

S="${WORKDIR}/slstatus-1.1"

LICENSE="MIT"
SLOT="0"
IUSE="tcc"
KEYWORDS="amd64"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="tcc? ( dev-lang/tcc )"

src_prepare() {
    default

    sed -i \
        -e 's|^ @| |g' \
        -e 's|@${CC}|$(CC)|g' \
        -e '/^ echo/d' \
        Makefile || die

    if use !tcc; then
        sed -i \
            -e "s/ -Os / /" \
            -e "/^\(LDFLAGS\|CFLAGS\)/{s| = | += |g;s|-s ||g}" \
            config.mk || die
    fi

    restore_config config.h
}

src_compile() {
    if use tcc; then
        emake CC="tcc"
    else
        emake CC="$(tc-getCC)"
    fi
}

src_install() {
    emake DISTDIR="${D}" PREFIX="${EPREFIX}/usr" install
    save_config config.h
}

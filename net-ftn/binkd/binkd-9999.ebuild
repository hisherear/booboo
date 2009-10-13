# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cvs

DESCRIPTION="Binkd - the binkp daemon for FTN communications"
HOMEPAGE="ftp://happy.kiev.ua/pub/fidosoft/mailer/binkd/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""
IUSE="perl bzip2 zlib https bwlim"

SRC_URI=""

RDEPEND="perl? ( >=dev-lang/perl-5.8.3 )
	 bzip2? ( >=app-arch/bzip2-1.0.3 )
	 zlib? ( >=sys-libs/zlib-1.2.3 )"
DEPEND="${RDEPEND}"

src_unpack() {
	ECVS_SERVER="cvs.happy.kiev.ua:/cvs"
	ECVS_USER="binkd"
	ECVS_PASS=""
	ECVS_AUTH="pserver"
	ECVS_MODULE="binkd"
	ECVS_TOP_DIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"
	ECVS_CVS_OPTIONS="-P"
	cvs_src_unpack
}

src_compile() {
	cd ${ECVS_MODULE}
	cp mkfls/unix/* .
	econf \
		$(use_with perl ) \
		$(use_with bzip2 ) \
	        $(use_with zlib ) \
	        $(use_with https ) \
	        $(use_with bwlim ) \
	        || die "Configure failed!"
	emake || die "emake failed"
}

src_install() {
	cd ${ECVS_MODULE}
	sed	's/$(CONFDIR)/$(prefix)\/$(CONFDIR)/g;s/$(MANDIR)/$(prefix)\/$(MANDIR)/g;' -i Makefile
	einstall || die "einstall failed"
	dodoc \!README HISTORY || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

FULLVER=${PV}-release-20141208165400

DESCRIPTION="Tools for bam file processing"
HOMEPAGE="https://github.com/gt1/biobambam"
SRC_URI="https://github.com/gt1/biobambam/archive/${FULLVER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sci-libs/libmaus"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${FULLVER}

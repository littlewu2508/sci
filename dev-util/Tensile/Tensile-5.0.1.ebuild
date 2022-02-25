# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/hip"

PATCHES=( "${FILESDIR}"/${PN}-4.3.0-output-commands.patch
		  "${FILESDIR}"/${PN}-5.0.1-gfx1031.patch
		  "${FILESDIR}"/Tensile-5.0.1-fix-arch-parse.patch
		  "${FILESDIR}"/Tensile-5.0.1-use-ninja.patch
		  "${FILESDIR}"/Tensile-5.0.1-gentoopath.patch
		  "${FILESDIR}"/1419.patch
	  )

S="${WORKDIR}/${PN}-rocm-${PV}"
CMAKE_USE_DIR="${WORKDIR}/Source"

src_prepare() {
	distutils-r1_src_prepare

	mv ${PN}/Source "${WORKDIR}"/ || die
	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i "${WORKDIR}"/Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i "${WORKDIR}"/Source/CMakeLists.txt || die

	mv ${PN}/cmake "${T}"/ || die

	sed -e "/HipClangVersion/s/0,0,0/$(hipconfig -v)/" \
		-e "/SourcePath/s,os\.path\.join.*$,\"${EPREFIX}/usr/share/${PN}\"," \
		-i ${PN}/Common.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile\", end='')|" \
		-i ${PN}/__init__.py || die

	sed -e "/package_data/d" -e "/data_files/d" -i setup.py || die
	# echo "include Tensile/Components" >> MANIFEST.in || die
}

python_install() {
	distutils-r1_python_install

	python_moduleinto Tensile
	pushd Tensile
	python_domodule Components Configs ReplacementKernels ReplacementKernels-cov3 Tests Utilities Perf
}

src_install() {
	distutils-r1_src_install

	insinto /usr/$(get_libdir)/cmake/${PN}
	doins "${T}"/cmake/*.cmake

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/Source/*
	dosym . /usr/share/${PN}/Source
}

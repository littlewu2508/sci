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
	dev-python/msgpack[${PYTHON_USEDEP}]
	>=dev-util/rocm-smi-4.3.0"
DEPEND="${RDEPEND}
	dev-util/hip"
RESTRICT="test" # test before install is hard.

PATCHES=( "${FILESDIR}"/${PN}-4.3.0-output-commands.patch
		  "${FILESDIR}"/${PN}-5.0.1-gfx1031.patch
		  "${FILESDIR}"/Tensile-5.0.1-fix-arch-parse.patch
		  "${FILESDIR}"/Tensile-5.0.1-use-ninja.patch
		  "${FILESDIR}"/Tensile-5.0.1-gentoopath.patch
		  "${FILESDIR}"/1419.patch
	  )

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	distutils-r1_src_prepare

	pushd ${PN} || die

	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i Source/CMakeLists.txt || die

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	sed -e "/HipClangVersion/s/0,0,0/$(hipconfig -v)/" \
		-e "/SourcePath/s,globalParameters\[\"ScriptPath\"\],${Tensile_share_dir}," \
		-i Common.py || die

	sed -e "/scriptDir/s,os.path.realpath(__file__),${Tensile_share_dir}," -i ReplacementKernels.py || die

	sed -e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" -i ${PN}.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile/Source\", end='')|" -i __init__.py || die

	popd || die

	sed -e "/package_data/d" -e "/data_files/d" -i setup.py || die
}

python_install() {
	distutils-r1_python_install

	python_moduleinto Tensile
	pushd Tensile
	python_domodule Components
	python_newexe Utilities/merge.py ${PN}-merge
}

src_install() {
	distutils-r1_src_install

	pushd ${PN} || die
	insinto /usr/share/${PN}
	doins -r Configs Perf ReplacementKernels ReplacementKernels-cov3 Source
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*.cmake
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AMD's library for BLAS on ROCm."
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${PN}-${PV}.tar.gz
	https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="benchmark test"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-perl/File-Which
	dev-libs/msgpack
	dev-util/cmake
	dev-util/rocm-cmake
	!dev-util/Tensile
	>=dev-python/virtualenv-15.1.0
	>=sys-devel/llvm-roc-4.0.0-r2
	test? ( virtual/blas )
	benchmark? ( virtual/blas )
	"

# stripped library is not working
RESTRICT="strip"

S="${WORKDIR}"/${PN}-rocm-${PV}

rocBLAS_V="0.1"

PATCHES=( "${FILESDIR}"/${PN}-4.1.0-fix-Ninja-build.patch
	"${FILESDIR}"/${PN}-4.1.0-fix-glibc-2.32-and-above.patch
	"${FILESDIR}"/${PN}-4.1.0-link-system-blas.patch )

src_prepare() {
	eapply_user

	pushd "${WORKDIR}"/Tensile-rocm-${PV} || die
	eapply "${FILESDIR}/Tensile-4.1.0-output-commands.patch"
	eapply "${FILESDIR}/Tensile-4.1.0-output-EnabledISA.patch"
	popd || die

	sed -e "/PREFIX rocblas/d" \
		-e "/<INSTALL_INTERFACE/s:include:include/rocblas:" \
		-e "s:rocblas/include:include/rocblas:" \
		-e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:${EPREFIX}/usr/$(get_libdir)/rocblas:" \
		-e "/rocm_install_symlink_subdir( rocblas )/d" -i library/src/CMakeLists.txt || die

	cmake_src_prepare
}

# CMAKE_MAKEFILE_GENERATOR=emake

src_configure() {
	# allow acces to hardware
	addwrite /dev/kfd
	addwrite /dev/dri/
	addwrite /dev/random

	export PATH="${EPREFIX}/usr/lib/llvm/roc/bin:${PATH}"

	local mycmakeargs=(
		-DTensile_LOGIC="asm_full"
		-DTensile_COMPILER="hipcc"
		-DTensile_ARCHITECTURE="all"
		-DTensile_LIBRARY_FORMAT="msgpack"
		-DTensile_CODE_OBJECT_VERSION="V3"
		-DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-${PV}"
		-DBUILD_WITH_TENSILE=ON
		-DBUILD_WITH_TENSILE_HOST=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DBUILD_TESTING=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
	)

	CXX="hipcc" cmake_src_configure

	# do not rerun cmake and the build process in src_install
	sed -e '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_test() {
	cd "${WORKDIR}/${P}_build/clients/staging" || die
	ROCBLAS_TENSILE_LIBPATH="${WORKDIR}/${P}_build/Tensile/library" ./rocblas-test
}

src_install() {
	echo "ROCBLAS_TENSILE_LIBPATH=${EPREFIX}/usr/lib64/rocblas/library" >> 99rocblas || die
	doenvd 99rocblas

	cmake_src_install

	if use benchmark; then
		cd "${WORKDIR}/${P}_build" || die
		dolib.so clients/librocblas_fortran_client.so
		dobin clients/staging/rocblas-bench
		chrpath -d "${ED}/usr/bin/rocblas-bench"
	fi
}

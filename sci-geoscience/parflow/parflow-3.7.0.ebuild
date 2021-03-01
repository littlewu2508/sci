# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# todo: latex, cuda support

EAPI=7

inherit cmake

DESCRIPTION="Open-source, modular, parallel watershed flow model."
HOMEPAGE="https://parflow.org"
SRC_URI="https://github.com/parflow/parflow/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+zlib +hdf5 hypre sundials slurm valgrind timing profiling doxygen +openmp"

DEPEND="
	>=dev-lang/tcl-8.6
	hdf5? ( sci-libs/hdf5[zlib?] )
	sci-libs/silo
	sci-libs/netcdf[hdf5?]
	net-misc/curl
	hypre? ( sci-libs/hypre )
	zlib? ( sys-libs/zlib )
	sundials? ( sci-libs/sundials )
	slurm? ( sys-cluster/slurm )
	valgrind? ( dev-util/valgrind )
	doxygen? ( app-doc/doxygen )
	openmp? ( sys-cluster/openmpi )
"
RDEPEND="${DEPEND}"
BDEPEND=""


src_configure() {
	local mycmakeargs=(
		-DPARFLOW_ENABLE_HDF5=$(usex hdf5 ON OFF)
		-DPARFLOW_ENABLE_HYPRE=$(usex hypre ON OFF)
		-DPARFLOW_ENABLE_ZLIB =$(usex zlib ON OFF)
		-DPARFLOW_ENABLE_SZLIB=OFF
		-DPARFLOW_ENABLE_SLURM=$(usex slurm ON OFF)
		-DPARFLOW_ENABLE_VALGRIND=$(usex valgrind ON OFF)
		-DPARFLOW_ENABLE_ETRACE=OFF
		-DPARFLOW_HAVE_CLM=OFF
		-DPARFLOW_ENABLE_TIMING=$(usex timing ON OFF)
		-DPARFLOW_ENABLE_PROFILING=$(usex profiling ON OFF)
		-DPARFLOW_ENABLE_DOXYGEN=$(usex doxygen ON OFF)
		if use openmp; then
			-DPARFLOW_ACCELERATOR_BACKEND=omp
		else
			-DPARFLOW_ACCELERATOR_BACKEND=none
		fi
	)
}

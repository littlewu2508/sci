# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake cuda distutils-r1 prefix

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/google/benchmark/archive/505be96a.tar.gz -> benchmark-505be96a.tar.gz
https://github.com/pytorch/cpuinfo/archive/5916273f.tar.gz -> cpuinfo-5916273f.tar.gz
https://github.com/NVlabs/cub/archive/d106ddb9.tar.gz -> cub-d106ddb9.tar.gz
https://github.com/pytorch/fbgemm/archive/7794b295.tar.gz -> fbgemm-7794b295.tar.gz
https://github.com/asmjit/asmjit/archive/8b35b4cf.tar.gz -> asmjit-8b35b4cf.tar.gz
https://github.com/pytorch/cpuinfo/archive/ed8b86a2.tar.gz -> cpuinfo-ed8b86a2.tar.gz
https://github.com/google/googletest/archive/cbf019de.tar.gz -> googletest-cbf019de.tar.gz
https://github.com/fmtlib/fmt/archive/cd4af11e.tar.gz -> fmt-cd4af11e.tar.gz
https://github.com/houseroad/foxi/archive/bd6feb6d.tar.gz -> foxi-bd6feb6d.tar.gz
https://github.com/Maratyszcza/FP16/archive/4dfe081c.tar.gz -> FP16-4dfe081c.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b408327a.tar.gz -> FXdiv-b408327a.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176.tar.gz -> gemmlowp-3fb5c176.tar.gz
https://github.com/facebookincubator/gloo/archive/6f7095f6.tar.gz -> gloo-6f7095f6.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/intel/ideep/archive/f9468ff1.tar.gz -> ideep-f9468ff1.tar.gz
https://github.com/intel/mkl-dnn/archive/98be7e8a.tar.gz -> mkl-dnn-98be7e8a.tar.gz
https://github.com/pytorch/kineto/archive/a631215a.tar.gz -> kineto-a631215a.tar.gz
https://github.com/fmtlib/fmt/archive/2591ab91.tar.gz -> fmt-2591ab91.tar.gz
https://github.com/google/googletest/archive/7aca8442.tar.gz -> googletest-7aca8442.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/033d7995.tar.gz -> nccl-033d7995.tar.gz )
https://github.com/Maratyszcza/NNPACK/archive/c07e3a04.tar.gz -> NNPACK-c07e3a04.tar.gz
https://github.com/onnx/onnx/archive/54c38e6e.tar.gz -> onnx-54c38e6e.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/c1532114.tar.gz -> onnx-tensorrt-c1532114.tar.gz
https://github.com/onnx/onnx/archive/765f5ee8.tar.gz -> onnx-765f5ee8.tar.gz
https://github.com/google/benchmark/archive/e776aa02.tar.gz -> benchmark-e776aa02.tar.gz
https://github.com/google/benchmark/archive/e776aa02.tar.gz -> benchmark-e776aa02.tar.gz
https://github.com/Maratyszcza/psimd/archive/072586a7.tar.gz -> psimd-072586a7.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/a134dd5d.tar.gz -> pthreadpool-a134dd5d.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8.tar.gz -> PeachPy-07d8fde8.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e99.tar.gz -> QNNPACK-7d2a4e99.tar.gz
https://github.com/shibatch/sleef/archive/e0a003ee.tar.gz -> sleef-e0a003ee.tar.gz
https://github.com/pytorch/tensorpipe/archive/05e4c890.tar.gz -> tensorpipe-05e4c890.tar.gz
https://github.com/google/googletest/archive/aee0f9d9.tar.gz -> googletest-aee0f9d9.tar.gz
https://github.com/google/libnop/archive/aa95422e.tar.gz -> libnop-aa95422e.tar.gz
https://github.com/libuv/libuv/archive/1dff88e5.tar.gz -> libuv-1dff88e5.tar.gz
https://github.com/google/XNNPACK/archive/55d53a4e.tar.gz -> XNNPACK-55d53a4e.tar.gz
"

# git clone git@github.com:pytorch/pytorch.git && cd pytorch
# git submodules update --init --recursive
# ${FILESDIR}/get_third_paries
# cat SRC_URI src_prepare

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="asan blas cuda +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkldnn mpi +nnpack numa +observers opencl opencv +openmp +python +qnnpack redis rocm static test tools zeromq"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	?? ( cuda rocm )
"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	blas? ( virtual/blas )
	cuda? ( dev-libs/cudnn
		dev-cpp/eigen[cuda] )
	rocm? ( >=dev-util/hip-4.3
			>=dev-libs/rccl-4.3
			>=sci-libs/rocThrust-4.3
			>=sci-libs/hipCUB-4.3
			>=sci-libs/rocPRIM-4.3
			>=sci-libs/miopen-4.3
			>=sci-libs/rocBLAS-4.3
			>=sci-libs/rocRAND-4.3
			>=sci-libs/hipSPARSE-4.3
			>=sci-libs/rocFFT-4.3
			>=dev-util/roctracer-4.3 )
	ffmpeg? ( media-video/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mpi? ( virtual/mpi )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf-python:0/22
	)
	redis? ( dev-db/redis )
	zeromq? ( net-libs/zeromq )
	dev-cpp/eigen
	dev-libs/protobuf:0/22
	dev-libs/libuv
"

#ATen code generation
BDEPEND="dev-python/pyyaml"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-cpp/tbb
	app-arch/zstd
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	sys-fabric/libibverbs
	sys-process/numactl
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.0-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/${PN}-1.6.0-skip-tests.patch
	"${FILESDIR}"/${PN}-1.6.0-global-dlopen.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch
	"${FILESDIR}"/${PN}-1.7.1-no-rpath.patch
	"${FILESDIR}"/${PN}-1.7.1-torch_shm_manager.patch
)

src_prepare() {
	cmake_src_prepare
	eprefixify torch/__init__.py

	rmdir third_party/benchmark
	ln -sv "${WORKDIR}"/benchmark-505be96ab23056580a3a2315abba048f4428b04e third_party/benchmark || die
	rmdir third_party/cpuinfo
	ln -sv "${WORKDIR}"/cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d third_party/cpuinfo || die
	rmdir third_party/cub
	ln -sv "${WORKDIR}"/cub-d106ddb991a56c3df1b6d51b2409e36ba8181ce4 third_party/cub || die
	rmdir third_party/fbgemm
	ln -sv "${WORKDIR}"/FBGEMM-7794b2950b35ddfa7426091e7fb2f991b1407557 third_party/fbgemm || die
	rmdir third_party/fbgemm/third_party/asmjit
	ln -sv "${WORKDIR}"/asmjit-8b35b4cffb62ecb58a903bf91cb7537d7a672211 third_party/fbgemm/third_party/asmjit || die
	rmdir third_party/fbgemm/third_party/cpuinfo
	ln -sv "${WORKDIR}"/cpuinfo-ed8b86a253800bafdb7b25c5c399f91bff9cb1f3 third_party/fbgemm/third_party/cpuinfo || die
	rmdir third_party/fbgemm/third_party/googletest
	ln -sv "${WORKDIR}"/googletest-cbf019de22c8dd37b2108da35b2748fd702d1796 third_party/fbgemm/third_party/googletest || die
	rmdir third_party/fmt
	ln -sv "${WORKDIR}"/fmt-cd4af11efc9c622896a3e4cb599fa28668ca3d05 third_party/fmt || die
	rmdir third_party/foxi
	ln -sv "${WORKDIR}"/foxi-bd6feb6d0d3fc903df42b4feb82a602a5fcb1fd5 third_party/foxi || die
	rmdir third_party/FP16
	ln -sv "${WORKDIR}"/FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3 third_party/FP16 || die
	rmdir third_party/FXdiv
	ln -sv "${WORKDIR}"/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1 third_party/FXdiv || die
	rmdir third_party/gemmlowp/gemmlowp
	ln -sv "${WORKDIR}"/gemmlowp-3fb5c176c17c765a3492cd2f0321b0dab712f350 third_party/gemmlowp/gemmlowp || die
	rmdir third_party/gloo
	ln -sv "${WORKDIR}"/gloo-6f7095f6e9860ce4fd682a7894042e6eba0996f1 third_party/gloo || die
	rmdir third_party/googletest
	ln -sv "${WORKDIR}"/googletest-2fe3bd994b3189899d93f1d5a881e725e046fdc2 third_party/googletest || die
	rmdir third_party/ideep
	ln -sv "${WORKDIR}"/ideep-f9468ff1a3d601b509ebe2c17d2ed0a58dffacee third_party/ideep || die
	rmdir third_party/ideep/mkl-dnn
	ln -sv "${WORKDIR}"/mkl-dnn-98be7e8afa711dc9b66c8ff3504129cb82013cdb third_party/ideep/mkl-dnn || die
	rmdir third_party/kineto
	ln -sv "${WORKDIR}"/kineto-a631215ac294805d5360e0ecceceb34de6557ba8 third_party/kineto || die
	rmdir third_party/kineto/libkineto/third_party/fmt
	ln -sv "${WORKDIR}"/fmt-2591ab91c3898c9f6544fff04660276537d32ffd third_party/kineto/libkineto/third_party/fmt || die
	rmdir third_party/kineto/libkineto/third_party/googletest
	ln -sv "${WORKDIR}"/googletest-7aca84427f224eeed3144123d5230d5871e93347 third_party/kineto/libkineto/third_party/googletest || die
	rmdir third_party/nccl/nccl
	ln -sv "${WORKDIR}"/nccl-033d799524fb97629af5ac2f609de367472b2696 third_party/nccl/nccl || die
	rmdir third_party/NNPACK
	ln -sv "${WORKDIR}"/NNPACK-c07e3a0400713d546e0dea2d5466dd22ea389c73 third_party/NNPACK || die
	rmdir third_party/onnx
	ln -sv "${WORKDIR}"/onnx-54c38e6eaf557b844e70cebc00f39ced3321e9ad third_party/onnx || die
	rmdir third_party/onnx-tensorrt
	ln -sv "${WORKDIR}"/onnx-tensorrt-c153211418a7c57ce071d9ce2a41f8d1c85a878f third_party/onnx-tensorrt || die
	rmdir third_party/onnx-tensorrt/third_party/onnx
	ln -sv "${WORKDIR}"/onnx-765f5ee823a67a866f4bd28a9860e81f3c811ce8 third_party/onnx-tensorrt/third_party/onnx || die
	rmdir third_party/onnx-tensorrt/third_party/onnx/third_party/benchmark
	ln -sv "${WORKDIR}"/benchmark-e776aa0275e293707b6a0901e0e8d8a8a3679508 third_party/onnx-tensorrt/third_party/onnx/third_party/benchmark || die
	rmdir third_party/onnx/third_party/benchmark
	ln -sv "${WORKDIR}"/benchmark-e776aa0275e293707b6a0901e0e8d8a8a3679508 third_party/onnx/third_party/benchmark || die
	rmdir third_party/psimd
	ln -sv "${WORKDIR}"/psimd-072586a71b55b7f8c584153d223e95687148a900 third_party/psimd || die
	rmdir third_party/pthreadpool
	ln -sv "${WORKDIR}"/pthreadpool-a134dd5d4cee80cce15db81a72e7f929d71dd413 third_party/pthreadpool || die
	rmdir third_party/python-peachpy
	ln -sv "${WORKDIR}"/PeachPy-07d8fde8ac45d7705129475c0f94ed8925b93473 third_party/python-peachpy || die
	rmdir third_party/QNNPACK
	ln -sv "${WORKDIR}"/QNNPACK-7d2a4e9931a82adc3814275b6219a03e24e36b4c third_party/QNNPACK || die
	rmdir third_party/sleef
	ln -sv "${WORKDIR}"/sleef-e0a003ee838b75d11763aa9c3ef17bf71a725bff third_party/sleef || die
	rmdir third_party/tensorpipe
	ln -sv "${WORKDIR}"/tensorpipe-05e4c890d4bd5f8ac9a4ba8f3c21e2eba3f66eda third_party/tensorpipe || die
	rmdir third_party/tensorpipe/third_party/googletest
	ln -sv "${WORKDIR}"/googletest-aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e third_party/tensorpipe/third_party/googletest || die
	rmdir third_party/tensorpipe/third_party/libnop
	ln -sv "${WORKDIR}"/libnop-aa95422ea8c409e3f078d2ee7708a5f59a8b9fa2 third_party/tensorpipe/third_party/libnop || die
	rmdir third_party/tensorpipe/third_party/libuv
	ln -sv "${WORKDIR}"/libuv-1dff88e5161cba5c59276d2070d2e304e4dcb242 third_party/tensorpipe/third_party/libuv || die
	rmdir third_party/XNNPACK
	ln -sv "${WORKDIR}"/XNNPACK-55d53a4e7079d38e90acd75dd9e4f9e781d2da35 third_party/XNNPACK || die

	cd third_party/XNNPACK || die
	eapply "${FILESDIR}"/${PN}-1.9.0-xnnpack-gcc11.patch
	cd - || die

	if use cuda; then
		cd third_party/nccl/nccl || die
		eapply "${FILESDIR}"/${PN}-1.6.0-nccl-nvccflags.patch

# 		addpredict /dev/nvidiactl
		cuda_src_prepare
		export CUDAHOSTCXX=$(cuda_gccdir)/g++
	fi

	if use rocm; then
		eapply "${FILESDIR}"/${PN}-1.9.1-rocm.patch

		#Allow escaping sandbox
		addread /dev/kfd
		addread /dev/dri
		addwrite /dev/kfd
		addwrite /dev/dri

		ebegin "HIPifying cuda sources"
		python tools/amd_build/build_amd.py
		eapply "${FILESDIR}"/${PN}-1.9.1-fix-wrong-hipify.patch
		eend $?

		local ROCM_VERSION="$(hipconfig -v)-"
		export PYTORCH_ROCM_ARCH="${AMDGPU_TARGETS}"
		sed -e "/set(roctracer_INCLUDE_DIRS/s,\${ROCTRACER_PATH}/include,${EPREFIX}/usr/include/roctracer," \
			-e "/PYTORCH_HIP_HCC_LIBRARIES/s,\${HIP_PATH}/lib,${EPREFIX}/usr/lib/hip/lib," \
			-e "s,\${ROCTRACER_PATH}/lib,${EPREFIX}/usr/lib64/roctracer," \
			-e "/READ.*\.info\/version-dev/c\  set(ROCM_VERSION_DEV_RAW ${ROCM_VERSION})" \
			-i cmake/public/LoadHIP.cmake || die
		sed -r -e '/^if\(USE_ROCM/{:a;N;/\nendif/!ba; s,\{([^\{]*)_PATH\}(/include)?,\{\L\1_\UINCLUDE_DIRS\},g}' -i cmake/Dependencies.cmake || die
	fi

	# Disable submodule check
	sed -e '/check_submodules()$/d' -i setup.py || die

	# Set build dir for pytorch's setup
	sed -e "/BUILD_DIR/s,build,${BUILD_DIR}," -i tools/setup_helpers/env.py || die
}

src_configure() {
	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=$(get_libdir)
		-DBUILD_BINARY=$(usex tools ON OFF)
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_ASAN=$(usex asan ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DUSE_NCCL=$(usex cuda ON OFF)
		-DUSE_SYSTEM_NCCL=OFF
		-DUSE_ROCM=$(usex rocm ON OFF)
		-DUSE_FBGEMM=$(usex fbgemm ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_GFLAGS=$(usex gflags ON OFF)
		-DUSE_GLOG=$(usex glog ON OFF)
		-DUSE_LEVELDB=$(usex leveldb ON OFF)
		-DUSE_LITE_PROTO=OFF
		-DUSE_LMDB=$(usex lmdb ON OFF)
		-DUSE_MKLDNN=$(usex mkldnn ON OFF)
		-DUSE_MKLDNN_CBLAS=OFF
		-DUSE_NNPACK=$(usex nnpack ON OFF)
		-DUSE_NUMPY=$(usex python ON OFF)
		-DUSE_NUMA=$(usex numa ON OFF)
		-DUSE_OBSERVERS=$(usex observers ON OFF)
		-DUSE_OPENCL=$(usex opencl ON OFF)
		-DUSE_OPENCV=$(usex opencv ON OFF)
		-DUSE_OPENMP=$(usex openmp ON OFF)
		-DUSE_TBB=OFF
		-DUSE_PROF=OFF
		-DUSE_QNNPACK=$(usex qnnpack ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_ROCKSDB=OFF
		-DUSE_ZMQ=$(usex zeromq ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_GLOO=$(usex gloo ON OFF)
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DBLAS=$(usex blas Generic Eigen)
		-DTP_BUILD_LIBUV=OFF
		-Wno-dev
		-D__skip_rocmclang="ON" ## fix cmake-3.21 configuration issue caused by officialy support programming language "HIP"
	)

	HIP_PATH="${EPREFIX}/usr/lib/hip" cmake_src_configure

	if use python; then
		CMAKE_BUILD_DIR="${BUILD_DIR}" distutils-r1_src_configure
	fi

	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_compile() {
	cmake_src_compile

	if use python; then
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	local LIB=$(get_libdir)
	if [[ ${LIB} != lib ]]; then
		mv -fv "${ED}"/usr/lib/*.so "${ED}"/usr/${LIB}/ || die
	fi

	rm -rfv "${ED}/torch"
	rm -rfv "${ED}/var"
	rm -rfv "${ED}/usr/lib"

	rm -fv "${ED}/usr/include/*.{h,hpp}"
	rm -rfv "${ED}/usr/include/asmjit"
	rm -rfv "${ED}/usr/include/c10d"
	rm -rfv "${ED}/usr/include/fbgemm"
	rm -rfv "${ED}/usr/include/fp16"
	rm -rfv "${ED}/usr/include/gloo"
	rm -rfv "${ED}/usr/include/include"
	rm -rfv "${ED}/usr/include/var"

	rm -fv "${ED}/usr/${LIB}/libtbb.so"
	rm -rfv "${ED}/usr/${LIB}/cmake"

	if use python; then
		scanelf -r --fix "${BUILD_DIR}/caffe2/python"
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		python_foreach_impl python_optimize
	fi

	find "${ED}/usr/${LIB}" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}

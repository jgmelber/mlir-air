#!/usr/bin/env bash
#set -x

##===- utils/build-mlir-air.sh - Build mlir-air --*- Script -*-===##
# 
# Copyright (C) 2022, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

# 
##===----------------------------------------------------------------------===##
#
# This script build mlir-air given the <sysroot dir>, <llvm dir>, 
# <cmakeModules dir>, and <mlir-aie dir>. Assuming they are all in the same
# subfolder, it would look like:
#
# build-mlir-air.sh <sysroot dir> <llvm dir> <cmakeModules dir> <mlir-aie dir>
#     <mlir-air dir> <build dir> <install dir>
#
# e.g. build-mlir-air.sh /scratch/vck190_bare_prod_sysroot /scratch/llvm 
#          /scratch/mlir-aie
#          /scratch/cmakeModules/cmakeModulesXilinx
#
# <sysroot dir>      - sysroot, absolute directory
# <cmakeModules dir> - cmakeModules, absolute directory
# <mlir-aie dir>     - mlir-aie, absolute directory
#
# <mlir-air dir> - optional, mlir-air repo name, default is 'mlir-air'
# <build dir>    - optional, mlir-air/build dir name, default is 'build'
# <install dir>  - optional, mlir-air/install dir name, default is 'install'
#
##===----------------------------------------------------------------------===##

if [ "$#" -lt 4 ]; then
    echo "ERROR: Needs at least 4 arguments for <sysroot dir>, <llvm dir>,"
    echo "<cmakeModules dir> and <mlir-aie dir>."
    exit 1
fi
SYSROOT_DIR=$1
LLVM_DIR=$2
CMAKEMODULES_DIR=$3
MLIR_AIE_DIR=$4

MLIR_AIR_DIR=${5:-"mlir-air"}
BUILD_DIR=${6:-"build"}
INSTALL_DIR=${7:-"install"}

mkdir -p $MLIR_AIR_DIR/$BUILD_DIR
mkdir -p $MLIR_AIR_DIR/$INSTALL_DIR
cd $MLIR_AIR_DIR/$BUILD_DIR

PYTHON_ROOT=`pip3 show pybind11 | grep Location | awk '{print $2}'`

cmake .. \
	-GNinja \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_INSTALL_PREFIX="../${INSTALL_DIR}" \
	-DCMAKE_TOOLCHAIN_FILE_OPT=${CMAKEMODULES_DIR}/toolchain_clang_crosscomp_arm_petalinux.cmake \
	-DArch=arm64 \
	-DgccVer=10.2.0 \
	-DCMAKE_USE_TOOLCHAIN=FALSE \
	-DCMAKE_USE_TOOLCHAIN_AIRHOST=TRUE \
	-DLLVM_DIR=${LLVM_DIR}/build/lib/cmake/llvm \
	-DMLIR_DIR=${LLVM_DIR}/build/lib/cmake/mlir \
	-DAIE_DIR=${MLIR_AIE_DIR}/build/lib/cmake/aie \
	-Dpybind11_DIR=${PYTHON_ROOT}/pybind11/share/cmake/pybind11 \
	-DBUILD_SHARED_LIBS=OFF \
	-DLLVM_USE_LINKER=lld \
	-DCMAKE_MODULE_PATH=${CMAKEMODULES_DIR}/ \
	|& tee cmake.log

ninja |& tee ninja.log
ninja install |& tee ninja-install.log

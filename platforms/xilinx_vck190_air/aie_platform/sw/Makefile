# Copyright (C) 2020-2022, Xilinx Inc.
# Copyright (C) 2022, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

CXX = aarch64-linux-gnu-g++
#SDKTARGETSYSROOT = /proj/xbuilds/2020.1_daily_latest/internal_platforms/sw/versal/xilinx-versal-common-v2020.1/sysroots/aarch64-xilinx-linux/
SDKTARGETSYSROOT = ../../petalinux/sysroot/sysroots/cortexa72-cortexa53-xilinx-linux/

HOST_EXE     = ../host.exe
HOST_INC   = -I../ -I../aie
HOST_OBJ   = aie_control_xrt.o graph.o
#HOST_OBJ   = aie_control.o graph.o
AIE_CTRL_CPP = ../Work/ps/c_rts/aie_control_xrt.cpp
#AIE_CTRL_CPP = ../Work/ps/c_rts/aie_control.cpp
GRAPH_CPP = ../aie/graph.cpp

CXXFLAGS += -std=c++14 -I$(XILINX_VIVADO)/include/ -I${SDKTARGETSYSROOT}/usr/include/xrt/ -O0 -g -Wall -c -fmessage-length=0 --sysroot=${SDKTARGETSYSROOT} -I${XILINX_VITIS}/aietools/include ${HOST_INC}
#CXXFLAGS += -std=c++14 -I$(XILINX_VIVADO)/include/ -I${SDKTARGETSYSROOT}/usr/include/xrt/ -O0 -g -Wall -c -fmessage-length=0 --sysroot=${SDKTARGETSYSROOT} -I${XILINX_VITIS}/cardano/include ${HOST_INC}

LDFLAGS += -ladf_api_xrt -lgcc -lc -lxrt_coreutil -lxilinxopencl -lpthread -lrt -ldl -lcrypt -lstdc++ -L${SDKTARGETSYSROOT}/usr/lib/ --sysroot=${SDKTARGETSYSROOT} -L$(XILINX_VITIS)/aietools/lib/aarch64.o
#LDFLAGS += -lcardano_api_xrt -lgcc -lc -lxrt_coreutil -lxilinxopencl -lpthread -lrt -ldl -lcrypt -lstdc++ -L${SDKTARGETSYSROOT}/usr/lib/ --sysroot=${SDKTARGETSYSROOT} -L$(XILINX_VITIS)/cardano/lib/aarch64.o

${HOST_EXE}: ${HOST_OBJ}
	${CXX} -o $@ $^ ${LDFLAGS}

%.o: %.cpp
	${CXX} ${CXXFLAGS} -o $@ $<

aie_control_xrt.cpp: ${AIE_CTRL_CPP}
	cp -f ${AIE_CTRL_CPP} .
#aie_control.cpp: ${AIE_CTRL_CPP}
graph.cpp: ${GRAPH_CPP}
	cp -f ${GRAPH_CPP} .

clean:
#	rm -rf ${HOST_OBJ} .Xil ${HOST_EXE} aie_control.cpp
	rm -rf ${HOST_OBJ} .Xil ${HOST_EXE} aie_control_xrt.cpp

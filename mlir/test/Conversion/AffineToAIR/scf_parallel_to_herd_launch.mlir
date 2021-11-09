// (c) Copyright 2021 Xilinx Inc.

// RUN: air-opt -affine-to-air %s | FileCheck %s
// CHECK-LABEL: func @f0
// CHECK: %[[C0:.*]] = constant 2 : index
// CHECK air.launch_herd tile ({{.*}}, {{.*}}) in ({{.*}}=[[C0]], {{.*}}=[[C0]])
func @f0()  {
  %c0 = constant 0 : index
  %c1 = constant 1 : index
  %c2 = constant 2 : index
  scf.parallel (%x,%y) = (%c0,%c0) to (%c2, %c2) step (%c1,%c1) {
    %2 = addi %x, %y : index
    scf.yield
  }
  return
}

// CHECK-LABEL: func @f1
// CHECK: %[[C1:.*]] = constant 4 : index
// CHECK: %[[C2:.*]] = constant 1 : index
// CHECK air.launch_herd tile ({{.*}}, {{.*}}) in ({{.*}}=[[C1]], {{.*}}=[[C2]])
func @f1()  {
  %c0 = constant 0 : index
  %c32 = constant 32 : index
  %c128 = constant 128 : index
  scf.parallel (%x) = (%c0) to (%c128) step (%c32) {
    %2 = muli %x, %x : index
    scf.yield
  }
  return
}
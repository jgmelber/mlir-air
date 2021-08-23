//===- air_regularize_loop_pass.mlir ---------------------------*- MLIR -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// (c) Copyright 2021 Xilinx Inc.
//
//===----------------------------------------------------------------------===//

// RUN: aten-opt %s -air-regularize-loop="air-label=xten.binary_op" | FileCheck %s
// CHECK:   {{.*}}affine.for {{.*}} = 0 to 7 {\n          %7 = affine.apply #map0(%arg4, %arg3, %arg2){{.*}} {affine_opt_label = "affine_opt"}
// CHECK:   {{.*}}affine.for {{.*}} = 0 to 7 {\n          affine.for {{.*}} = 0 to 2 {{.*}}{affine_opt_label = "xten.binary_op"}

#map0 = affine_map<(d0, d1, d2) -> (d0 + d1 * 7 + d2 * 14)>
#map1 = affine_map<(d0, d1) -> (d0 + d1 * 5)>
module  {
  func @task(%arg0: tensor<28x10xf32>, %arg1: tensor<28x10xf32>) -> tensor<28x10xf32> {
    %0 = memref.alloc() : memref<28x10xf32>
    %1 = "aten.type_cast"(%arg0) : (tensor<28x10xf32>) -> memref<28x10xf32>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 7 {
          %7 = affine.apply #map0(%arg4, %arg3, %arg2)
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 5 {
              %8 = affine.apply #map1(%arg6, %arg5)
              %9 = affine.load %1[%7, %8] : memref<28x10xf32>
              %cst = constant 1.000000e+00 : f32
              %10 = addf %9, %cst : f32
              affine.store %10, %0[%7, %8] : memref<28x10xf32>
            }
          }
        }
      }
    } {affine_opt_label = "affine_opt"}
    %2 = "aten.type_cast"(%0) : (memref<28x10xf32>) -> tensor<28x10xf32>
    %3 = memref.alloc() : memref<28x10xf32>
    %4 = "aten.type_cast"(%2) : (tensor<28x10xf32>) -> memref<28x10xf32>
    %5 = "aten.type_cast"(%arg1) : (tensor<28x10xf32>) -> memref<28x10xf32>
    affine.for %arg2 = 0 to 2 {
      affine.for %arg3 = 0 to 2 {
        affine.for %arg4 = 0 to 7 {
          %7 = affine.apply #map0(%arg4, %arg3, %arg2)
          affine.for %arg5 = 0 to 2 {
            affine.for %arg6 = 0 to 5 {
              %8 = affine.apply #map1(%arg6, %arg5)
              %9 = affine.load %4[%7, %8] : memref<28x10xf32>
              %10 = affine.load %5[%7, %8] : memref<28x10xf32>
              %11 = mulf %9, %10 : f32
              affine.store %11, %3[%7, %8] : memref<28x10xf32>
            }
          }
        }
      }
    } {affine_opt_label = "xten.binary_op"}
    %6 = "aten.type_cast"(%3) : (memref<28x10xf32>) -> tensor<28x10xf32>
    return %6 : tensor<28x10xf32>
  }
}
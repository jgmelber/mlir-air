# Test 42_8x8

## Coverage

| Coverage | How |
| -------- | --- |
| Physical dialect | Pathfinder router used to broadcast data to an 8x8 herd |
| Physical dialect | Unique inputs "A" are brodcast to all cores in each row |
| Physical dialect | Unique inputs "B" are brodcast to all cores in each col |

NOTE: two versions are included:
    (1) `aie.inc` routes to/from shim DMAs from/to tile DMAs
    (2) `aie_stubs.inc` uses a stub as a waypoint to reguarize the broadcast structure

Use the visualizer in acdc/aie/tools/aie-routing-command-line for comparison:
		(1) mlir2json.sh aie.mlir output
    (2) python3 visualize.py -j output.json -o bcast

Below is an example of visualizing a flow from `aie_stubs.mlir`.

```

    ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₂ ┌─────┐ ₁ ┌─┴───┐ ₁ ┌─────┐ ₁ ┌─────┐ ₁ ┌─────┐ ₁ ┌─────┐                 
    │ 19,0├───┤ 19,1├───┤ 19,2├───┤ 19,3├───┤ 19,4├───┤ 19,5├───┤ 19,6├───┤ 19,7├───┤ 19,8│                 
    │  *  │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
     ¹│        ³│        ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌─┴───┐   ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 20,0│   │ 20,1├───┤ 20,2├───┤ 20,3├───┤ 20,4├───┤ 20,5├───┤ 20,6├───┤ 20,7├───┤ 20,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
     ¹│        ²│        ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌─┴───┐   ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 21,0│   │ 21,1├───┤ 21,2├───┤ 21,3├───┤ 21,4├───┤ 21,5├───┤ 21,6├───┤ 21,7├───┤ 21,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
     ¹│        ¹│        ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 22,0├───┤ 22,1├───┤ 22,2├───┤ 22,3├───┤ 22,4├───┤ 22,5├───┤ 22,6├───┤ 22,7├───┤ 22,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └─────┘   └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
               ¹│        ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌─────┐   ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 23,0│   │ 23,1├───┤ 23,2├───┤ 23,3├───┤ 23,4├───┤ 23,5├───┤ 23,6├───┤ 23,7├───┤ 23,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └─────┘   └─┬─┬─┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
               ¹│ │¹     ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌─────┐ ₂ ┌─┴─┴─┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 24,0├───┤ 24,1├───┤ 24,2├───┤ 24,3├───┤ 24,4├───┤ 24,5├───┤ 24,6├───┤ 24,7├───┤ 24,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └───┬─┘   └─┬───┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
        │²     ¹│        ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌───┴─┐   ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌─┴───┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐ ₁ ┌───┴─┐                 
    │ 25,0│   │ 25,1├───┤ 25,2├───┤ 25,3├───┤ 25,4├───┤ 25,5├───┤ 25,6├───┤ 25,7├───┤ 25,8│                 
    │     │   │  *  │   │  *  │   │  *  │   │  *  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └───┬─┘   └─┬─┬─┘   └─┬───┘   └─┬───┘   └─┬───┘   └───┬─┘   └───┬─┘   └───┬─┘   └───┬─┘                 
        │²     ¹│ │¹     ¹│        ¹│        ¹│           ↑¹        │¹        │¹        │¹                  
    ┌───┴─┐ ₂ ┌─┴─┴─┐ ₂ ┌─┴───┐ ₂ ┌─┴───┐ ₂ ┌─┴───┐ ₂ ┌───┴─┐ ₁ ┌───┴─┐ ₂ ┌───┴─┐ ₁ ┌───┴─┐                 
 →→→│ 26,0├→→→┤ 26,1├→→→┤ 26,2├→→→┤ 26,3├→→→┤ 26,4├→→→┤ 26,5├───┤ 26,6├───┤ 26,7├───┤ 26,8│                 
    │S #  │   │  #  │   │  #  │   │  #  │   │  #  │   │  # D│   │  *  │   │  *  │   │  *  │                 
    └───┬─┘   └───┬─┘   └─────┘   └─────┘   └─────┘   └─────┘   └───┬─┘   └─────┘   └───┬─┘                 


```

-----

<p align="center">Copyright&copy; 2019-2022 Advanced Micro Devices, Inc. All rights reserved.</p>
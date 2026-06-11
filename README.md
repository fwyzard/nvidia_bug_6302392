# CUDA 13.3 breaks building code that uses the abesil-cpp library, line ONNX

[NVIDIA bug 6302392](https://developer.nvidia.com/bugs/6302392)

## Description

Building a source file that uses Abseil's `"absl/container/flat_hash_map.h"` with NVCC from CUDA 13.3.0 fails with
```
abseil-cpp/absl/container/internal/raw_hash_map.h:126:169: error: using template type parameter 'absl::lts_20250814::container_internal::IfRRef::AddPtr' after 'typename'
126 | ABSL_INTERNAL_X(insert_or_assign, insert_or_assign_impl, const &, const &,
| ^
abseil-cpp/absl/container/internal/raw_hash_map.h:126:223: error: using template type parameter 'absl::lts_20250814::container_internal::IfRRef::AddPtr' after 'typename'
126 | ABSL_INTERNAL_X(insert_or_assign, insert_or_assign_impl, const &, const &,
| ^
abseil-cpp/absl/container/internal/raw_hash_map.h:126:234: error: template argument 5 is invalid
126 | ABSL_INTERNAL_X(insert_or_assign, insert_or_assign_impl, const &, const &,
| ^
abseil-cpp/absl/container/internal/raw_hash_map.h:126:234: error: template argument 6 is invalid
abseil-cpp/absl/container/internal/raw_hash_map.h:126:236: error: template argument 1 is invalid
126 | ABSL_INTERNAL_X(insert_or_assign, insert_or_assign_impl, const &, const &,
| ^
```
and so on.

The same test builds correctly with NVCC from CUDA 13.2.

## Instructions to reproduce

```bash
git clone git@github.com:fwyzard/nvidia_bug_6302392.git
cd nvidia_bug_6302392
make
```
will clone Abseil, build it (requires CMake), and try to compile the test program with CUDA 13.2 and CUDA 13.3.

## Details

Reproduced on Ubuntu 24.04 LTS with GCC 13.4 and on RHEL 8.10 with GCC 14.2.1.

#include <cuda_runtime.h>

#include <iostream>
#include <vector>

// Abseil headers (host-only)
#include "absl/container/flat_hash_map.h"
#include "absl/strings/str_cat.h"

// ---------------- CUDA kernel ----------------
__global__ void increment_kernel(int* data, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        data[idx] += 1;
    }
}

// ---------------- main ----------------
int main() {
    const int N = 16;
    const size_t bytes = N * sizeof(int);

    // Host data
    std::vector<int> h_data(N, 0);

    // Device data
    int* d_data = nullptr;
    cudaMalloc(&d_data, bytes);

    cudaMemcpy(d_data, h_data.data(), bytes, cudaMemcpyHostToDevice);

    // Launch kernel
    increment_kernel<<<1, N>>>(d_data, N);
    cudaDeviceSynchronize();

    // Copy back
    cudaMemcpy(h_data.data(), d_data, bytes, cudaMemcpyDeviceToHost);

    cudaFree(d_data);

    // ---------------- Abseil usage (host side) ----------------
    absl::flat_hash_map<int, std::string> results;

    for (int i = 0; i < N; ++i) {
        results[i] = absl::StrCat("value=", h_data[i]);
    }

    // Print results
    for (const auto& [k, v] : results) {
        std::cout << k << " -> " << v << "\n";
    }

    return 0;
}

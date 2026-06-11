.PHONY: all clean

all: test-cuda-13.2 test-cuda-13.3

clean:
	rm -f test-cuda-13.2 test-cuda-13.3

abseil-cpp/absl:
	git clone git@github.com:abseil/abseil-cpp.git -b 20250814.0

abseil-cpp/build: abseil-cpp/absl
	cmake -S abseil-cpp -B abseil-cpp/build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=20

abseil-cpp/build/absl/base/libabsl_base.a: abseil-cpp/build
	make -C abseil-cpp/build -j $(shell nproc) all

# hack to avoid the complications of dealing with inter-dependent abseil libraries
abseil-cpp/libabseil.a: abseil-cpp/build/absl/base/libabsl_base.a
	ar rcs abseil-cpp/libabseil.a $(shell find abseil-cpp/build -name '*.o')

test-cuda-13.2: test.cu abseil-cpp/libabseil.a
	/usr/local/cuda-13.2/bin/nvcc -std=c++20 -O2 -g -w -x cu $< -Iabseil-cpp -Labseil-cpp -labseil -o $@

test-cuda-13.3: test.cu abseil-cpp/libabseil.a
	/usr/local/cuda-13.3/bin/nvcc -std=c++20 -O2 -g -w -x cu $< -Iabseil-cpp -Labseil-cpp -labseil -o $@


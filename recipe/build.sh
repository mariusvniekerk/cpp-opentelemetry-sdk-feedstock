#!/bin/bash

set -ex

export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_STANDARD=11"

main() {
    # Release tarballs do not contain the required Protobuf definitions.
    cp -r $CONDA_PREFIX/share/opentelemetry/opentelemetry-proto/opentelemetry ./third_party/opentelemetry-proto/
    # Stop CMake from trying to git clone the Protobuf definitions.
    mkdir ./third_party/opentelemetry-proto/.git

    mkdir -p build-cpp
    pushd build-cpp

    local PROTOC_EXECUTABLE=$PREFIX/bin/protoc
    local CMAKE_FIND_ROOT_PATH=""
    if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
        PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc
    fi

    cmake ${CMAKE_ARGS} ..  \
          -GNinja \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
          -DCMAKE_PREFIX_PATH=$PREFIX \
          -DCMAKE_INSTALL_PREFIX=$PREFIX \
          -DBUILD_TESTING=OFF \
          -DWITH_API_ONLY=OFF \
          -DWITH_EXAMPLES=OFF \
          -DWITH_OTLP=ON \
          -DWITH_OTLP_GRPC=ON \
          -DWITH_OTLP_HTTP=ON \
          -DProtobuf_PROTOC_EXECUTABLE=$PROTOC_EXECUTABLE \
          -DWITH_ZIPKIN=ON

    ninja install
    popd
}

main

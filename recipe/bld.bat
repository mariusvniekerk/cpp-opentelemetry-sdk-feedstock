@echo on

mkdir build-cpp
if errorlevel 1 exit 1

REM Release tarballs do not contain the required Protobuf definitions.
robocopy /S /E %BUILD_PREFIX%\share\opentelemetry\opentelemetry-proto\opentelemetry .\third_party\opentelemetry-proto\opentelemetry
REM Stop CMake from trying to git clone the Protobuf definitions.
mkdir .\third_party\opentelemetry-proto\.git
REM fool build into believing it cloned the prometheus-cpp dep
mkdir .\third_party\prometheus-cpp/.git


cd build-cpp
cmake .. ^
      -GNinja ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH=%CONDA_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DBUILD_TESTING=OFF ^
      -DWITH_API_ONLY=OFF ^
      -DWITH_ETW=ON ^
      -DWITH_EXAMPLES=OFF ^
      -DWITH_OTLP=ON ^
      -DWITH_OTLP_GRPC=ON ^
      -DWITH_OTLP_HTTP=ON ^
      -DWITH_ZIPKIN=ON ^
      -DWITH_METRICS_PREVIEW=ON ^
      -DWITH_PROMETHEUS=ON

cmake --build . --config Release --target install
if errorlevel 1 exit 1

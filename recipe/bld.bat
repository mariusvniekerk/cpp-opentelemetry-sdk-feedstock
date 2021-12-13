@echo on

mkdir build-cpp
if errorlevel 1 exit 1

echo %CONDA_PREFIX%
echo %LIBRARY_PREFIX%
dir %CONDA_PREFIX%\Library\share
dir %LIBRARY_PREFIX%\share
dir %CONDA_PREFIX%\share
dir %PREFIX%\share

REM Release tarballs do not contain the required Protobuf definitions.
robocopy /S /E %CONDA_PREFIX%\Library\share\opentelemetry\opentelemetry-proto\opentelemetry .\third_party\opentelemetry-proto\opentelemetry
REM Stop CMake from trying to git clone the Protobuf definitions.
mkdir .\third_party\opentelemetry-proto\.git

cd build-cpp
cmake .. ^
      -GNinja ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH=%CONDA_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DBUILD_TESTING=OFF ^
      -DWITH_API_ONLY=OFF ^
      -DWITH_ETW=OFF ^
      -DWITH_EXAMPLES=OFF ^
      -DWITH_OTLP=ON ^
      -DWITH_OTLP_GRPC=ON

cmake --build . --config Release --target install
if errorlevel 1 exit 1

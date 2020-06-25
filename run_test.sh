#!/bin/sh

echo "\n\e[31;7mNinja + Gcov\e[0m"
mkdir build-ninja-gcov
cd build-ninja-gcov
cmake -Wno-dev -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug -G Ninja ..
ninja -v -j 1 
ninja -v -j 1 test
ninja -v -j 1 gcov
cd -

echo "\n\e[31;7mNinja + Lcov\e[0m"
mkdir build-ninja-lcov
cd build-ninja-lcov
cmake -Wno-dev -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug -G Ninja ..
ninja -v -j 1
ninja -v -j 1 test
ninja -v -j 1 lcov
cd -

echo "\n\e[31;7mMake + Gcov\e[0m"
mkdir build-make-gcov
cd build-make-gcov
cmake -Wno-dev -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug -G "Unix Makefiles" ..
make
make test
make gcov
cd -

echo "\n\e[31;7mMake + Lcov\e[0m"
mkdir build-make-lcov
cd build-make-lcov
cmake -Wno-dev -DENABLE_COVERAGE=ON -DCMAKE_BUILD_TYPE=Debug -G "Unix Makefiles" ..
make
make test
make lcov
cd -

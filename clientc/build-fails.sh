#!/bin/bash
set -e
pushd ../staticlib_crate
./build-unsuccessfully.sh # will fail, we won't even get to the line below
popd
cc -o broke main.c march=armv7-a -L../staticlib_crate/target/arm-linux-androideabi/debug -lstaticlib_crate

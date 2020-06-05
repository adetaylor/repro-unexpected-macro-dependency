#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rustc --crate-name staticlib_crate --edition=2018 src/lib.rs --crate-type staticlib -Cbitcode-in-rlib=no -C debuginfo=2 --out-dir $DIR/target/arm-linux-androideabi/debug/deps --target arm-linux-androideabi --extern rlib_crate=$DIR/../rlib_crate/target/arm-linux-androideabi/debug/librlib_crate.rlib

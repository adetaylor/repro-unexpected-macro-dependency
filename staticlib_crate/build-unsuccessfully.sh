#!/bin/bash
set -e

pushd ../rlib_crate
cargo build --target arm-linux-androideabi
popd

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm $DIR/target/arm-linux-androideabi/debug/libstaticlib_crate.a || true
rustc --crate-name staticlib_crate --edition=2018 src/lib.rs --crate-type staticlib -Cbitcode-in-rlib=no -C debuginfo=2 --out-dir $DIR/target/arm-linux-androideabi/debug --target arm-linux-androideabi --extern rlib_crate=$DIR/../rlib_crate/target/arm-linux-androideabi/debug/librlib_crate.rlib -Ldependency=$DIR/../rlib_crate/target/arm-linux-androideabi/debug/deps

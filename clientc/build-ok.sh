#!/bin/bash

set -e

pushd ../rlib_crate
cargo build --target arm-linux-androideabi
popd

RUSTC_LIBDIR="$(rustc --print target-libdir --target arm-linux-androideabi)"
MORE_RLIBS="$(ls $RUSTC_LIBDIR/*.rlib) $(ls ../rlib_crate/target/arm-linux-androideabi/debug/deps/*.rlib)"

CHROMIUM=~/chromium/src
CLANG=$CHROMIUM/third_party/llvm-build/Release+Asserts/bin/clang
CLANG_ARGS_FOR_ARM="-Wl,--fatal-warnings -Wl,--build-id=sha1 -fPIC -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,-z,defs -Wl,--as-needed -fuse-ld=lld -Wl,--icf=all -Wl,--color-diagnostics -Wl,--lto-O2 -Wl,-mllvm -Wl,-import-instr-limit=5 -march=armv7-a -Wl,--no-rosegment -Wl,--exclude-libs=libgcc.a -Wl,--exclude-libs=libvpx_assembly_arm.a --target=arm-linux-androideabi16 -Werror -Wl,--warn-shared-textrel -Wl,-O2 -Wl,--gc-sections -nostdlib++ --sysroot=$CHROMIUM/third_party/android_ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot -B$CHROMIUM/third_party/android_ndk/toolchains/llvm/prebuilt/linux-x86_64 -Wl,--warn-shared-textrel -pie -Bdynamic -Wl,-z,nocopyreloc -landroid_support -lunwind -ldl -lm -landroid -llog $CHROMIUM/base/android/library_loader/anchor_functions.lds"
$CLANG -o ok $CLANG_ARGS_FOR_ARM -DREPLICATE_RUSTC_CODEGEN main.c -fuse-ld=lld ../rlib_crate/target/arm-linux-androideabi/debug/librlib_crate.rlib $MORE_RLIBS

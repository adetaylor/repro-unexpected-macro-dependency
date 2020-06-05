#include <stdio.h>

int call_from_c();

int main(void) {
  int my_num = call_from_c();
  printf("Number returned from Rust: %d\n", my_num);
  return 0;
}

#ifdef REPLICATE_RUSTC_CODEGEN
#include <stddef.h>

// Rust's final linking stage invokes dynamic LLVM codegen to create symbols
// for the basic heap allocation operations. For cases where we're not using
// Rustc as the final linker, we'll do that ourselves here instead.
// They're weak symbols, because this file will sometimes end up in targets
// which are linked by rustc, and thus we would otherwise get duplicate
// definitions. The following definitions will therefore only end up being
// used in targets which are linked by our C++ toolchain.

void* __rdl_alloc(size_t, size_t);
void __rdl_dealloc(void*);
void* __rdl_realloc(void*, size_t, size_t, size_t);
void* __rdl_alloc_zeroed(size_t, size_t);

void* __attribute__((weak)) __rust_alloc(size_t a, size_t b) {
  return __rdl_alloc(a, b);
}

void __attribute__((weak)) __rust_dealloc(void* a) {
  __rdl_dealloc(a);
}

void* __attribute__((weak))
__rust_realloc(void* a, size_t b, size_t c, size_t d) {
  return __rdl_realloc(a, b, c, d);
}

void* __attribute__((weak)) __rust_alloc_zeroed(size_t a, size_t b) {
  return __rdl_alloc_zeroed(a, b);
}
#endif // REPLICATE_RUSTC_CODEGEN

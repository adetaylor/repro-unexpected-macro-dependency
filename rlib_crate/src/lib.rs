#[macro_crate::hello]
fn do_something() -> i32 {
    (42 * rand::random::<i8>()).into()
}

#[no_mangle]
pub extern fn call_from_c() -> i32 {
    do_something() / 3
}

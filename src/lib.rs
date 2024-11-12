#![allow(clippy::missing_safety_doc)]

use core::str;
use std::slice;

#[repr(C)]
pub struct MinifyResult {
    len: i32,
    ptr: *const u8,
}

#[no_mangle]
pub unsafe extern "C" fn to_html(ptr: *const u8, len: i32) -> MinifyResult {
    let result = markdown::to_html(
        str::from_utf8_unchecked(slice::from_raw_parts(ptr, len as usize))
    )
    .leak();
    MinifyResult {
        len: result.len() as i32,
        ptr: result.as_ptr(),
    }
}

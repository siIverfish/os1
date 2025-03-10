#![no_std]
#![no_main]

core::arch::global_asm!(include_str!("boot.asm"));

static HELLO: &[u8] = b"Hello, World!";

#[repr(align(4))]
#[repr(C)]
pub struct MultibootHeader {
    magic: u32,
    flags: u32,
    checksum: i32,
}

#[link_section = "multiboot_header"]
pub static MULTIBOOT_HEADER: MultibootHeader = MultibootHeader {
    magic: 0x1BADB002,
    flags: 0x00000000,
    checksum: -(0x1BADB002 + 0x00000000)
};

#[panic_handler]
fn panic_handler(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    print_message();

    loop {}
}

fn print_message() {
    let vga_buffer = 0xB8000 as *mut u8;
    static DEFAULT_COLOR: u8 = 0x0F;

    for (i, &byte) in HELLO.iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = DEFAULT_COLOR;
        }
    }
}
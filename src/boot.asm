.section .multiboot
    .align 4
    .long 0x1BADB002
    .long 0x00000000
    .long -(0x1BADB002 + 0x00000000)

.section .text
    .global start
    start:
        mov stack_top, esp
        call rust_main
        cli
        hlt

.section .bss
    .align 16
    stack_bottom:
        .skip 0x4000 # 16 KB
    stack_top:
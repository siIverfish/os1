#!/bin/bash

release=false
for arg in "$@"; do
    if [ "$arg" == "--release" ]; then
        release=true
    fi
done

if $release; then
    echo "release mode..."
    executable=./target/i686-os1/release/os1
    cargo build --release --target=i686-os1.json -Zbuild-std=core,compiler_builtins -Zbuild-std-features=compiler-builtins-mem 
else
    echo "debug mode..."
    executable=./target/i686-os1/debug/os1
    cargo build --target=i686-os1.json -Zbuild-std=core,compiler_builtins -Zbuild-std-features=compiler-builtins-mem 
fi

if [ $? -ne 0 ]; then
    echo "Build failed; exiting..."
    exit 1
fi

if grub-file --is-x86-multiboot $executable; then
    echo "SUCCESS: multiboot confirmed"
else
    echo "FAILURE: multiboot not present"
    exit 1
fi

cp $executable ./iso/boot/kernel.elf
grub-mkrescue -o os1.iso iso/

qemu-system-i386 -cdrom os1.iso
# KFS

A small 32-bit x86 kernel written in NASM assembly and loaded by GRUB.

At startup, the kernel:

- disables interrupts;
- clears the VGA text screen, including previous GRUB messages;
- prints `Hello World !`;
- halts the processor.

## Build and run

The required tools are `nasm`, `ld`, `grub-mkrescue`, and `qemu-system-i386`.

```sh
make
```

This command builds `kernel.bin` and `kernel.iso`, then starts the image in
QEMU. To remove the generated files:

```sh
make fclean
```

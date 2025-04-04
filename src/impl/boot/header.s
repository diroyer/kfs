%define MULTIBOOT2_HEADER_MAGIC 0xE85250D6
%define MULTIBOOT2_ARCHITECTURE 0x0

section .multiboot_header
header_start:
	; Multiboot header
	dd MULTIBOOT2_HEADER_MAGIC
	dd MULTIBOOT2_ARCHITECTURE
	dd header_end - header_start
	dd 0x100000000 - (MULTIBOOT2_HEADER_MAGIC + 0 + (header_end - header_start))
	;end 
	dw 0
	dw 0
	dd 8
header_end:

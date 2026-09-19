global start

section .text
bits 32
start:
	cli
	cld
	mov edi, 0xb8000
	mov ecx, 80 * 25
	mov ax, 0x0f20
	rep stosw

	mov esi, message
	mov edi, 0xb8000
	mov ah, 0x0f

.print:
	lodsb
	test al, al
	jz .stop
	stosw
	jmp .print

.stop:
	hlt

section .rodata
message db "Hello World !", 0

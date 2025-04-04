[bits 16]
[org 0x7c00]

CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start

KERNEL_LOAD_SEGMENT equ 0x1000
KERNEL_START_ADDRESS equ 0x100000

start:

	cli
	mov ax, 0x00
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00
	sti

	; init vga
	mov ah, 0x00
	mov al, 0x03 ; 80x25 text mode
	int 0x10 ; BIOS interrupt

	; load kernel
	mov bx, KERNEL_LOAD_SEGMENT
	mov ah, 0x02 ; read sectors
	mov ch, 0 ; cylinder
	mov cl, 2 ; sector	
	mov dh, 0 ; head
	mov dl, 0x80 ; first hard disk
	mov al, 8 ; read 8 sectors
	int 0x13 ; BIOS interrupt

	; check for error
	jc error


load_pm:
	cli
	lgdt [gdt_desc]
	mov eax, cr0
	or al, 1
	mov cr0, eax
	jmp CODE_SEGMENT:pmode_main

error:
	hlt

;	mov si, msg
;
;print:
;	lodsb
;	cmp al, 0
;	je done
;	mov ah, 0x0e ; teletype output
;	int 0x10 ; print character
;	jmp print
;
;done:
;	cli
;	hlt

; Acces Byte
; 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
; P | DPL	| S | E |DC |RW | A

; gdt impl
gdt_start:
	dd 0x0
	dd 0x0 

gdt_code:
	; code segment
	dw 0xFFFF ; limit
	dw 0x0000 ; base
	db 0x00 ; base
	db 10011010b ; access byte
	db 11001111b ; granularity 4kb
	db 0x00 ; base

gdt_data:
	; data segment
	dw 0xFFFF ; limit
	dw 0x0000 ; base
	db 0x00 ; base
	db 10010010b ; access byte
	db 11001111b ; granularity 4kb
	db 0x00 ; base
gdt_end:


; gdt descriptor
gdt_desc:
	dw gdt_end - gdt_start - 1 ; limit
	dd gdt_start ; base


[bits 32]

pmode_main:
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov gs, ax
	mov ebp, 0x9c00
	mov esp, ebp

	in al, 0x92
	or al, 0x2
	out 0x92, al

	
	call 0x1000 ; call kernel
	;jmp 8:10000h
	;jmp CODE_SEGMENT:KERNEL_START_ADDRESS ; jump to kernel

;msg: db 'Hello, World!', 0

times 510 - ($ - $$) db 0

dw 0xAA55 ; boot signature

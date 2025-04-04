name:= boot.bin

asms := $(wildcard *.s)

all: $(name)

$(name):
	nasm -f bin -o $(name) boot.s
	nasm -g -f elf32 -o kernel.o kernel.s
	ld -g -m elf_i386 -T linker.ld -o kernel.bin kernel.o

	#dd if=./boot.bin >> os.bin
	#dd if=./kernel.bin >> os.bin
	#dd if=/dev/zero bs=512 count=8 >> os.bin
	dd if=/dev/zero of=os.bin bs=512 count=2048
	dd if=boot.bin of=os.bin conv=notrunc
	dd if=kernel.bin of=os.bin conv=notrunc seek=2

clean:
	rm -f *.o

fclean: clean
	rm -f *.bin

re: fclean all

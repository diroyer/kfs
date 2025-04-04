name := kernel.bin

iso := kernel.iso

asms := $(shell find src/impl/ -name '*.s')

linker := src/targets/linker.ld

objs := $(asms:.s=.o)

all: $(name)

$(name): $(objs)
	ld -m elf_i386 -n -T $(linker) -o $@ $^
	@echo "Kernel image: $@"
	cp $@ src/targets/iso/boot/kernel.bin
	grub-mkrescue -o $(iso) src/targets/iso
	@echo "ISO image: kernel.iso"


src/impl/%.o: src/impl/%.s Makefile
	nasm -f elf32 -o $@ $<

clean:
	@rm -vf $(objs) $(iso)

fclean: clean
	@rm -vf $(name)

re: fclean all

.PHONY: all clean fclean re


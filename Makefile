CC=gcc
LD=ld
CFLAGS=-I./include -Wall -Wextra -nostdlib -nostartfiles -nodefaultlibs -m32 -w -g
LDFLAGS=-T link.ld
SOURCES=main.c scrn.c gdt.c idt.c isrs.c irq.c timer.c kb.c
OBJECTS=$(SOURCES:.c=.o) start.o
EXECUTABLE=kernel.bin

all: $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

.o:
	$(CC) $(CFLAGS) $< -o $@


start.o: start.asm
	nasm -f aout -o start.o start.asm

clean:
	rm -rf $(OBJECTS) $(EXECUTABLE)

qemu:
	mount /dev/loop1 image
	cp -f kernel.bin image/kernel.bin
	umount /dev/loop1
	qemu -fda /dev/loop1 -m 4

qemu-gdb:
	cp -f kernel.bin image/kernel.bin
	qemu -fda /dev/loop1 -S -gdb tcp::1234 -m 4

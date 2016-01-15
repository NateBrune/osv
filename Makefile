INCLUDE := src/include
C_SOURCES=$(wildcard src/*.c)
C_OBJECTS=$(C_SOURCES:.c=.o)
AS_SOURCES=$(wildcard src/*.s)
AS_OBJECTS=$(AS_SOURCES:.s=.o)
OBJECTS=$(C_OBJECTS) $(AS_OBJECTS)
WARNINGS := -Wall -Wextra
CFLAGS := -ffreestanding -O2 -I $(INCLUDE) $(WARNINGS)

.PHONY: all clean dist check testdrivers todolist

all: kernel.bin

kernel.bin: $(C_OBJECTS) $(AS_OBJECTS)
		echo $(OBJECTS)
		i686-elf-gcc -T linker.ld -o build/$@ -nostdlib $(CFLAGS) $(OBJECTS)

src/boot.o: src/boot.s	
	
	i686-elf-as $< -o $@

%.o: %.c
		i686-elf-gcc -c $< -o $@ $(CFLAGS)

clean:
		$(RM) src/*.o src/*.bin src/*~ build/*.bin build/*.iso build/grubfiles/*.bin

run: kernel.bin
		qemu-system-i386 -kernel build/$<

iso: kernel.bin
		 cp build/$< iso
		 grub-mkrescue -o build/kernel.iso build/grubfiles

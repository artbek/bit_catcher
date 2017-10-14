PATH := $(PATH):$(HOME)/opt/gcc-arm-none-eabi-6-2017-q2-update/bin

JLINK_EXE = JLinkExe
JLINK_GDB_SERVER = JLinkGDBServer
JLINK_OPTIONS = -device STM32L031K6 -If SWD -Speed 4000

all: flash
hex: main.bin
flash: main.bin
	$(JLINK_EXE) $(JLINK_OPTIONS) -commanderscript flash.jlink

main.o: main.S
	@echo '=================================================='
	arm-none-eabi-as --fatal-warnings -mthumb -g -o main.o main.S

main.elf: main.o
	arm-none-eabi-ld -Ttext 0x00000000 main.o -o main.elf

main.bin: main.elf
	arm-none-eabi-objcopy -S -O binary main.elf main.bin
	@echo '=================================================='
	arm-none-eabi-size main.elf
	@echo '=================================================='

clean:
	rm -f main.elf main.o main.bin

objdump:
	arm-none-eabi-objdump -d main.elf


jlinkInteractive:
	$(JLINK_EXE) $(JLINK_OPTIONS)

jlink_startGDBServer:
	$(JLINK_GDB_SERVER) $(JLINK_OPTIONS)

jlink_startGDB:
	arm-none-eabi-gdb --tui -- main.elf


PATH := $(PATH):$(HOME)/opt/gcc-arm-none-eabi-6-2017-q2-update/bin

JLINK_EXE = JLinkExe
JLINK_GDB_SERVER = JLinkGDBServer
JLINK_OPTIONS = -device STM32L031K6 -If SWD -Speed 4000


all: clean main.bin


# GCC

main.o: main.s
	@echo '=================================================='
	arm-none-eabi-as --fatal-warnings -mthumb -g -o main.o main.s

main.elf: main.o
	arm-none-eabi-ld -Ttext 0x00000000 main.o -o main.elf

main.bin: main.elf
	arm-none-eabi-objcopy -S -O binary main.elf main.bin
	@echo '=================================================='
	arm-none-eabi-size main.o
	@echo '=================================================='

eeprom:
	rm -f eeprom.o eeprom.bin
	arm-none-eabi-as -o eeprom.o eeprom.s
	arm-none-eabi-objcopy -S -O binary eeprom.o eeprom.bin
	$(JLINK_EXE) $(JLINK_OPTIONS) -commanderscript eeprom.jlink


flash:
	$(JLINK_EXE) $(JLINK_OPTIONS) -commanderscript flash.jlink

clean:
	rm -f main.elf main.o main.bin

objdump:
	arm-none-eabi-objdump -d main.o


# JLink

jlink_interactive:
	$(JLINK_EXE) $(JLINK_OPTIONS)

jlink_startGDBServer:
	$(JLINK_GDB_SERVER) $(JLINK_OPTIONS)

jlink_startGDB:
	arm-none-eabi-gdb --tui -ex "layout regs" -ex "file main.elf" -ex "target remote localhost:2331"


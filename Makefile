# set debug to 0 or 1
# adjust optimization flag accordingly below
debug = 0
# set fpu to soft, softfp or hard
# soft:   software fpu, soft abi
# softfp: hardware fpu, soft abi
# hard:   harwdare fpu, hard abi
fpu = soft

# specify an aarch32 bare-metal eabi toolchain
CC = arm-none-eabi-gcc
# specify STM32_Programmer_CLI with connect options
STM32PRG = STM32_Programmer_CLI --verbosity 1 -c port=swd mode=HOTPLUG speed=Reliable

# modify these to add/remove different code/object files
C_OBJECTS = main.o syscalls.o
S_OBJECTS = startup_stm32h563.o

# sets DEBUGFLAGS based on debug above
ifeq ($(debug), 1)
	DEBUGFLAGS = -g3 -O0
else
	# change optimization options to whatever suits you
	DEBUGFLAGS = -O2
endif

# sets FLOATFLAGS based on fpu above
ifeq ($(fpu), softfp)
	FLOATFLAGS = -mfloat-abi=softfp -mfpu=fpv5-sp-d16
else ifeq ($(fpu), hard)
	FLOATFLAGS = -mfloat-abi=hard -mfpu=fpv5-sp-d16
else
	FLOATFLAGS = -mfloat-abi=soft
endif

# cpu target and instruction set
CFLAGS = -mcpu=cortex-m33 -mthumb -std=gnu11
# floating point model
CFLAGS += $(FLOATFLAGS)
# includes
CFLAGS += -I. -Icmsis/CMSIS/Core/Include -Icmsis_device_h5/Include -DSTM32H563xx
# use newlib nano
CFLAGS += --specs=nano.specs
# put functions and data into individual sections
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wall
CFLAGS += $(DEBUGFLAGS)

ASFLAGS = -mcpu=cortex-m33 -mthumb
ASFLAGS += $(FLOATFLAGS)
ASFLAGS += --specs=nano.specs
# enable c preprocessor in assembly source files
ASFLAGS += -x assembler-with-cpp
ASFLAGS += $(DEBUGFLAGS)

LDFLAGS = -mcpu=cortex-m33 -mthumb
LDFLAGS += $(FLOATFLAGS)
# use the linker script
LDFLAGS += -T"linker.ld"
# use the system call stubs
LDFLAGS += --specs=nosys.specs 
# remove empty sections only if not for debug
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -static
LDFLAGS += --specs=nano.specs
LDFLAGS += -Wl,--start-group -lc -lm -Wl,--end-group

# run cmsis and cmsis_device_h5 only if the directories do not exist
all: clean program.elf | cmsis cmsis_device_h5

clean:
	rm -rf program.elf *.o

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.s Makefile
	$(CC) $(ASFLAGS) -c -o $@ $<

program.elf: $(C_OBJECTS) $(S_OBJECTS) Makefile linker.ld
	$(CC) -o $@ $(C_OBJECTS) $(S_OBJECTS) $(LDFLAGS)

flash: program.elf
	$(STM32PRG) --write $<
	$(STM32PRG) -hardRst

erase:
	$(STM32PRG) --erase all

reset:
	$(STM32PRG) -hardRst

cmsis:
	git clone --depth 1 -b 5.9.0 https://github.com/ARM-software/CMSIS_5 $@

cmsis_device_h5:
	git clone --depth 1 -b v1.1.0 https://github.com/STMicroelectronics/cmsis_device_h5 $@

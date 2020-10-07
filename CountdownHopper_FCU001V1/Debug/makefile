################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Middlewares/USB_Device_Library/subdir.mk
-include Middlewares/STM32_BlueNRG/Utils/subdir.mk
-include Middlewares/STM32_BlueNRG/Interface/subdir.mk
-include Middlewares/STM32_BlueNRG/HCI/Controller/subdir.mk
-include Middlewares/STM32_BlueNRG/HCI/subdir.mk
-include Drivers/STM32F4xx_HAL_Driver/subdir.mk
-include Drivers/Components/subdir.mk
-include Drivers/CMSIS/subdir.mk
-include Drivers/Board/subdir.mk
-include Application/User/subdir.mk
-include Application/SW4STM32/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: ToyDrone\ Configuration.elf

# Tool invocations
ToyDrone\ Configuration.elf: $(OBJS) $(USER_OBJS) ../STM32F401VCTx_FLASH.ld
	@echo 'Building target: $@'
	@echo 'Invoking: MCU GCC Linker'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -specs=nosys.specs -specs=nano.specs -u _printf_float -T"../STM32F401VCTx_FLASH.ld" -Wl,-Map=output.map -Wl,--gc-sections -o "ToyDrone Configuration.elf" @"objects.list" $(USER_OBJS) $(LIBS) -lm
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) *
	-@echo ' '

post-build:
	-@echo 'Generating binary and Printing size information:'
	arm-none-eabi-objcopy -O binary "ToyDrone Configuration.elf" "ToyDrone Configuration.bin"
	arm-none-eabi-size "ToyDrone Configuration.elf"
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets

################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
/Users/Alberic/Downloads/ST_Drone_FCU_F401-master\ 2/STM32\ FW\ Project/Official\ release\ with\ BLE\ Remocon\ -\ 170318/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f401xc.s 

OBJS += \
./Application/SW4STM32/startup_stm32f401xc.o 


# Each subdirectory must supply rules for building sources it contributes
Application/SW4STM32/startup_stm32f401xc.o: /Users/Alberic/Downloads/ST_Drone_FCU_F401-master\ 2/STM32\ FW\ Project/Official\ release\ with\ BLE\ Remocon\ -\ 170318/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f401xc.s
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Assembler'
	@echo $(PWD)
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '



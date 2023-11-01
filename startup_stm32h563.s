/* startup_stm32h563.s: startup code for STM32H563
 * Copyright (C) 2023 Mete Balci

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

  .syntax unified

/* this is only used when -mcpu is not given */
  .cpu cortex-m33
  /* this is only used when -mfpu is not given */
/* better to control it with -mfpu */
  .fpu softvfp
/* generate Thumb (actually Thumb-2) code */
/* Cortex-M33 supports only Thumb-2 (not Arm) */
  .thumb

/* allocate locations for start/end markers */
  .word _sidata
  .word _sdata
  .word _edata
  .word _sbss
  .word _ebss

/* Reset_Handler is called after processor resets */
/* called after MSP is loaded with the initial SP */
/* initial SP is the first entry of vector table */
  .section .text.Reset_Handler
  .global Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
/* set stack limit */
  ldr r0, =__StackLimit
  msr msplim, r0

/* initialize system core (power, clock etc.) */ 
  bl  system_init

/* copy data */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit

/* zero bss */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* init arrays */
  #bl __libc_init_array

/* main */
  bl main
/* loop forever if main exits */
  b .
  .size Reset_Handler, .-Reset_Handler

/* HardFault exception handler */
  .section .text.HardFault_Handler
  .type HardFault_Handler, %function
/* weak to be able to define a strong one somewhere else */
  .weak HardFault_Handler
HardFault_Handler:
  b .
  .size   HardFault_Handler, .-HardFault_Handler

/* a default handler for all exception handlers */
  .section .text.Default_Handler
  .type Default_Handler, %function
Default_Handler:
  b .
  .size Default_Handler, .-Default_Handler

/* vector table */
  .section .vectors,"a",%progbits
  .type Vectors, %object
Vectors:
	.word	__StackTop
	.word	Reset_Handler
	.word	NMI_Handler
	.word	HardFault_Handler
	.word	MemManage_Handler
	.word	BusFault_Handler
	.word	UsageFault_Handler
	.word	SecureFault_Handler
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	.word	DebugMon_Handler
	.word	0
	.word	PendSV_Handler
	.word	SysTick_Handler
/* external interrupt 0 starts from here */
	.word	WWDG_IRQHandler
	.word	PVD_AVD_IRQHandler
	.word	RTC_IRQHandler
	.word	RTC_S_IRQHandler
	.word	TAMP_IRQHandler
	.word	RAMCFG_IRQHandler
	.word	FLASH_IRQHandler
	.word	FLASH_S_IRQHandler
	.word	GTZC_IRQHandler
	.word	RCC_IRQHandler
	.word	RCC_S_IRQHandler
	.word	EXTI0_IRQHandler
	.word	EXTI1_IRQHandler
	.word	EXTI2_IRQHandler
	.word	EXTI3_IRQHandler
	.word	EXTI4_IRQHandler
	.word	EXTI5_IRQHandler
	.word	EXTI6_IRQHandler
	.word	EXTI7_IRQHandler
	.word	EXTI8_IRQHandler
	.word	EXTI9_IRQHandler
	.word	EXTI10_IRQHandler
	.word	EXTI11_IRQHandler
	.word	EXTI12_IRQHandler
	.word	EXTI13_IRQHandler
	.word	EXTI14_IRQHandler
	.word	EXTI15_IRQHandler
	.word	GPDMA1_Channel0_IRQHandler
	.word	GPDMA1_Channel1_IRQHandler
	.word	GPDMA1_Channel2_IRQHandler
	.word	GPDMA1_Channel3_IRQHandler
	.word	GPDMA1_Channel4_IRQHandler
	.word	GPDMA1_Channel5_IRQHandler
	.word	GPDMA1_Channel6_IRQHandler
	.word	GPDMA1_Channel7_IRQHandler
	.word	IWDG_IRQHandler
	.word	0
  .word	ADC1_IRQHandler
	.word	DAC1_IRQHandler
	.word	FDCAN1_IT0_IRQHandler
	.word	FDCAN1_IT1_IRQHandler
	.word	TIM1_BRK_IRQHandler
	.word	TIM1_UP_IRQHandler
	.word	TIM1_TRG_COM_IRQHandler
	.word	TIM1_CC_IRQHandler
	.word	TIM2_IRQHandler
	.word	TIM3_IRQHandler
	.word	TIM4_IRQHandler
	.word	TIM5_IRQHandler
	.word	TIM6_IRQHandler
	.word	TIM7_IRQHandler
	.word	I2C1_EV_IRQHandler
	.word	I2C1_ER_IRQHandler
	.word	I2C2_EV_IRQHandler
	.word	I2C2_ER_IRQHandler
	.word	SPI1_IRQHandler
	.word	SPI2_IRQHandler
	.word	SPI3_IRQHandler
	.word	USART1_IRQHandler
	.word	USART2_IRQHandler
	.word	USART3_IRQHandler
	.word	UART4_IRQHandler
	.word	UART5_IRQHandler
	.word	LPUART1_IRQHandler
	.word	LPTIM1_IRQHandler
  .word	TIM8_BRK_IRQHandler
  .word	TIM8_UP_IRQHandler
  .word	TIM8_TRG_COM_IRQHandler
  .word	TIM8_CC_IRQHandler
  .word	ADC2_IRQHandler
	.word	LPTIM2_IRQHandler
	.word	TIM15_IRQHandler
	.word	TIM16_IRQHandler
	.word	TIM17_IRQHandler
	.word	USB_DRD_FS_IRQHandler
	.word	CRS_IRQHandler
	.word	UCPD1_IRQHandler
	.word	FMC_IRQHandler
	.word	OCTOSPI1_IRQHandler
	.word	SDMMC1_IRQHandler
	.word	I2C3_EV_IRQHandler
	.word	I2C3_ER_IRQHandler
	.word	SPI4_IRQHandler
	.word	SPI5_IRQHandler
	.word	SPI6_IRQHandler
	.word	USART6_IRQHandler
	.word	USART10_IRQHandler
	.word	USART11_IRQHandler
	.word	SAI1_IRQHandler
	.word	SAI2_IRQHandler
	.word	GPDMA2_Channel0_IRQHandler
	.word	GPDMA2_Channel1_IRQHandler
	.word	GPDMA2_Channel2_IRQHandler
	.word	GPDMA2_Channel3_IRQHandler
	.word	GPDMA2_Channel4_IRQHandler
	.word	GPDMA2_Channel5_IRQHandler
	.word	GPDMA2_Channel6_IRQHandler
	.word	GPDMA2_Channel7_IRQHandler
	.word	UART7_IRQHandler
	.word	UART8_IRQHandler
	.word	UART9_IRQHandler
	.word	UART12_IRQHandler
	.word	SDMMC2_IRQHandler
	.word	FPU_IRQHandler
	.word	ICACHE_IRQHandler
	.word	DCACHE1_IRQHandler
	.word	ETH_IRQHandler
	.word	ETH_WKUP_IRQHandler
	.word	DCMI_PSSI_IRQHandler
	.word	FDCAN2_IT0_IRQHandler
	.word	FDCAN2_IT1_IRQHandler
	.word	CORDIC_IRQHandler
 	.word   FMAC_IRQHandler
	.word	DTS_IRQHandler
	.word	RNG_IRQHandler
	.word	0
	.word	0
	.word	HASH_IRQHandler
	.word	0
	.word	CEC_IRQHandler
	.word	TIM12_IRQHandler
	.word	TIM13_IRQHandler
	.word	TIM14_IRQHandler
	.word	I3C1_EV_IRQHandler
	.word	I3C1_ER_IRQHandler
	.word	I2C4_EV_IRQHandler
	.word	I2C4_ER_IRQHandler
	.word	LPTIM3_IRQHandler
	.word	LPTIM4_IRQHandler
	.word	LPTIM5_IRQHandler
	.word	LPTIM6_IRQHandler
/* STM32H563 has 131 external interrupts */
/* Cortex-M33 supports 480 */
/* allocate the remaining space */
  .space  ((480-131) * 4)
  .size Vectors, .-Vectors

/* helper for default exception handler definitions */
  .macro   Set_Default_Handler Handler_Name
  .weak    \Handler_Name
  .set     \Handler_Name, Default_Handler
  .endm

/* set a default exception handler for all but HardFault */
  Set_Default_Handler	NMI_Handler
	Set_Default_Handler	MemManage_Handler
	Set_Default_Handler	BusFault_Handler
	Set_Default_Handler	UsageFault_Handler
	Set_Default_Handler	SecureFault_Handler
	Set_Default_Handler	SVC_Handler
	Set_Default_Handler	DebugMon_Handler
	Set_Default_Handler	PendSV_Handler
	Set_Default_Handler	SysTick_Handler
	Set_Default_Handler	WWDG_IRQHandler
	Set_Default_Handler	PVD_AVD_IRQHandler
	Set_Default_Handler	RTC_IRQHandler
	Set_Default_Handler	RTC_S_IRQHandler
	Set_Default_Handler	TAMP_IRQHandler
	Set_Default_Handler	RAMCFG_IRQHandler
	Set_Default_Handler	FLASH_IRQHandler
	Set_Default_Handler	FLASH_S_IRQHandler
	Set_Default_Handler	GTZC_IRQHandler
	Set_Default_Handler	RCC_IRQHandler
	Set_Default_Handler	RCC_S_IRQHandler
	Set_Default_Handler	EXTI0_IRQHandler
	Set_Default_Handler	EXTI1_IRQHandler
	Set_Default_Handler	EXTI2_IRQHandler
	Set_Default_Handler	EXTI3_IRQHandler
	Set_Default_Handler	EXTI4_IRQHandler
	Set_Default_Handler	EXTI5_IRQHandler
	Set_Default_Handler	EXTI6_IRQHandler
	Set_Default_Handler	EXTI7_IRQHandler
	Set_Default_Handler	EXTI8_IRQHandler
	Set_Default_Handler	EXTI9_IRQHandler
	Set_Default_Handler	EXTI10_IRQHandler
	Set_Default_Handler	EXTI11_IRQHandler
	Set_Default_Handler	EXTI12_IRQHandler
	Set_Default_Handler	EXTI13_IRQHandler
	Set_Default_Handler	EXTI14_IRQHandler
	Set_Default_Handler	EXTI15_IRQHandler
	Set_Default_Handler	GPDMA1_Channel0_IRQHandler
	Set_Default_Handler	GPDMA1_Channel1_IRQHandler
	Set_Default_Handler	GPDMA1_Channel2_IRQHandler
	Set_Default_Handler	GPDMA1_Channel3_IRQHandler
	Set_Default_Handler	GPDMA1_Channel4_IRQHandler
	Set_Default_Handler	GPDMA1_Channel5_IRQHandler
	Set_Default_Handler	GPDMA1_Channel6_IRQHandler
	Set_Default_Handler	GPDMA1_Channel7_IRQHandler
	Set_Default_Handler	IWDG_IRQHandler
	Set_Default_Handler	ADC1_IRQHandler
	Set_Default_Handler	DAC1_IRQHandler
	Set_Default_Handler	FDCAN1_IT0_IRQHandler
	Set_Default_Handler	FDCAN1_IT1_IRQHandler
	Set_Default_Handler	TIM1_BRK_IRQHandler
	Set_Default_Handler	TIM1_UP_IRQHandler
	Set_Default_Handler	TIM1_TRG_COM_IRQHandler
	Set_Default_Handler	TIM1_CC_IRQHandler
	Set_Default_Handler	TIM2_IRQHandler
	Set_Default_Handler	TIM3_IRQHandler
	Set_Default_Handler	TIM4_IRQHandler
	Set_Default_Handler	TIM5_IRQHandler
	Set_Default_Handler	TIM6_IRQHandler
	Set_Default_Handler	TIM7_IRQHandler
	Set_Default_Handler	I2C1_EV_IRQHandler
	Set_Default_Handler	I2C1_ER_IRQHandler
	Set_Default_Handler	I2C2_EV_IRQHandler
	Set_Default_Handler	I2C2_ER_IRQHandler
	Set_Default_Handler	SPI1_IRQHandler
	Set_Default_Handler	SPI2_IRQHandler
	Set_Default_Handler	SPI3_IRQHandler
	Set_Default_Handler	USART1_IRQHandler
	Set_Default_Handler	USART2_IRQHandler
	Set_Default_Handler	USART3_IRQHandler
	Set_Default_Handler	UART4_IRQHandler
	Set_Default_Handler	UART5_IRQHandler
	Set_Default_Handler	LPUART1_IRQHandler
	Set_Default_Handler	LPTIM1_IRQHandler
	Set_Default_Handler	TIM8_BRK_IRQHandler
	Set_Default_Handler	TIM8_UP_IRQHandler
	Set_Default_Handler	TIM8_TRG_COM_IRQHandler
	Set_Default_Handler	TIM8_CC_IRQHandler
	Set_Default_Handler	ADC2_IRQHandler
	Set_Default_Handler	LPTIM2_IRQHandler
	Set_Default_Handler	TIM15_IRQHandler
	Set_Default_Handler	TIM16_IRQHandler
	Set_Default_Handler	TIM17_IRQHandler
	Set_Default_Handler	USB_DRD_FS_IRQHandler
	Set_Default_Handler	CRS_IRQHandler
	Set_Default_Handler	UCPD1_IRQHandler
	Set_Default_Handler	FMC_IRQHandler
	Set_Default_Handler	OCTOSPI1_IRQHandler
	Set_Default_Handler	SDMMC1_IRQHandler
	Set_Default_Handler	I2C3_EV_IRQHandler
	Set_Default_Handler	I2C3_ER_IRQHandler
	Set_Default_Handler	SPI4_IRQHandler
	Set_Default_Handler	SPI5_IRQHandler
	Set_Default_Handler	SPI6_IRQHandler
	Set_Default_Handler	USART6_IRQHandler
	Set_Default_Handler	USART10_IRQHandler
	Set_Default_Handler	USART11_IRQHandler
	Set_Default_Handler	SAI1_IRQHandler
	Set_Default_Handler	SAI2_IRQHandler
	Set_Default_Handler	GPDMA2_Channel0_IRQHandler
	Set_Default_Handler	GPDMA2_Channel1_IRQHandler
	Set_Default_Handler	GPDMA2_Channel2_IRQHandler
	Set_Default_Handler	GPDMA2_Channel3_IRQHandler
	Set_Default_Handler	GPDMA2_Channel4_IRQHandler
	Set_Default_Handler	GPDMA2_Channel5_IRQHandler
	Set_Default_Handler	GPDMA2_Channel6_IRQHandler
	Set_Default_Handler	GPDMA2_Channel7_IRQHandler
	Set_Default_Handler	UART7_IRQHandler
	Set_Default_Handler	UART8_IRQHandler
	Set_Default_Handler	UART9_IRQHandler
	Set_Default_Handler	UART12_IRQHandler
	Set_Default_Handler	SDMMC2_IRQHandler
	Set_Default_Handler	FPU_IRQHandler
	Set_Default_Handler	ICACHE_IRQHandler
	Set_Default_Handler	DCACHE1_IRQHandler
	Set_Default_Handler	ETH_IRQHandler
	Set_Default_Handler	ETH_WKUP_IRQHandler
	Set_Default_Handler	DCMI_PSSI_IRQHandler
	Set_Default_Handler	FDCAN2_IT0_IRQHandler
	Set_Default_Handler	FDCAN2_IT1_IRQHandler
	Set_Default_Handler	CORDIC_IRQHandler
	Set_Default_Handler	FMAC_IRQHandler
	Set_Default_Handler	DTS_IRQHandler
	Set_Default_Handler	RNG_IRQHandler
	Set_Default_Handler	HASH_IRQHandler
	Set_Default_Handler	CEC_IRQHandler
	Set_Default_Handler	TIM12_IRQHandler
	Set_Default_Handler	TIM13_IRQHandler
	Set_Default_Handler	TIM14_IRQHandler
	Set_Default_Handler	I3C1_EV_IRQHandler
	Set_Default_Handler	I3C1_ER_IRQHandler
	Set_Default_Handler	I2C4_EV_IRQHandler
	Set_Default_Handler	I2C4_ER_IRQHandler
	Set_Default_Handler	LPTIM3_IRQHandler
	Set_Default_Handler	LPTIM4_IRQHandler
	Set_Default_Handler	LPTIM5_IRQHandler
	Set_Default_Handler	LPTIM6_IRQHandler

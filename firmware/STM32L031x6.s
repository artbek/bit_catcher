@ STM32L031K6

.equ SRAM, 0x20000000
.equ EEPROM, 0x08080000

.equ FLASH, 0x40022000
.equ FLASH_PECR, FLASH + 0x04
.equ FLASH_PEKEYR, FLASH + 0x0C
.equ PEKEY1, 0x89ABCDEF
.equ PEKEY2, 0x02030405

@================================================@

.equ SCR, 0xE000ED10

@================================================@

.equ PWR, 0x40007000
.equ PWR_CR, PWR + 0x00
.equ PWR_CSR, PWR + 0x04

@================================================@

.equ RCC, 0x40021000

.equ RCC_CR, RCC + 0x00
.equ RCC_IOPENR, RCC + 0x2C
.equ RCC_CFGR, RCC + 0x0C
.equ RCC_AHBENR, RCC + 0x30
.equ RCC_APB1ENR, RCC + 0x38
.equ RCC_APB2ENR, RCC + 0x34
.equ RCC_ICSCR, RCC + 0x04

@================================================@

.equ GPIOA, 0x50000000
.equ GPIOB, 0x50000400

.equ MODER_OFFSET, 0x00
.equ OSPEEDR_OFFSET, 0x08
.equ PUPDR_OFFSET, 0x0C
.equ IDR_OFFSET, 0x10
.equ ODR_OFFSET, 0x14
.equ BSRR_OFFSET, 0x18

.equ GPIOA_MODER, GPIOA + MODER_OFFSET
.equ GPIOA_PUPDR, GPIOA + PUPDR_OFFSET
.equ GPIOA_IDR, GPIOA + IDR_OFFSET
.equ GPIOA_ODR, GPIOA + ODR_OFFSET
.equ GPIOA_OSPEEDR, GPIOA + OSPEEDR_OFFSET

.equ GPIOB_MODER, GPIOB + MODER_OFFSET
.equ GPIOB_PUPDR, GPIOB + PUPDR_OFFSET
.equ GPIOB_IDR, GPIOB + IDR_OFFSET
.equ GPIOB_ODR, GPIOB + ODR_OFFSET
.equ GPIOB_OSPEEDR, GPIOB + OSPEEDR_OFFSET

@================================================@

.equ STK_CSR, 0xE000E010
.equ STK_RVR, 0xE000E014 // initial value
.equ STK_CVR, 0xE000E018 // current value
.equ STK_CALIB, 0xE000E01C

.equ ICSR, 0xE000ED04 // Interrupt Control and State Register

.equ NVIC_ISER, 0xE000E100 // Interrupt Set-enable Register
.equ NVIC_ICPR, 0xE000E280 // Interrupt Clear-pending Register

@================================================@

.equ TIM21, 0X40010800
.equ TIM21_CR1, TIM21 + 0x00
.equ TIM21_DIER, TIM21 + 0x0C
.equ TIM21_SR, TIM21 + 0x10
.equ TIM21_EGR, TIM21 + 0x14
.equ TIM21_CNT, TIM21 + 0x24
.equ TIM21_PSC, TIM21 + 0x28
.equ TIM21_ARR, TIM21 + 0x2C

.equ TIM22, 0X40011400
.equ TIM22_CR1, TIM22 + 0x00
.equ TIM22_DIER, TIM22 + 0x0C
.equ TIM22_SR, TIM22 + 0x10
.equ TIM22_EGR, TIM22 + 0x14
.equ TIM22_CNT, TIM22 + 0x24
.equ TIM22_PSC, TIM22 + 0x28
.equ TIM22_ARR, TIM22 + 0x2C
.equ TIM22_CCR1, TIM22 + 0x34


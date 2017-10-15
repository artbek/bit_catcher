@ STM32L031K6

.equ SRAM, 0x20000000

@================================================@

.equ SCR, 0xE000ED10

@================================================@

.equ PWR, 0x40007000
.equ PWR_CR, PWR + 0x00
.equ PWR_CSR, PWR + 0x04

@================================================@

.equ RCC, 0x40021000

.equ RCC_IOPENR, RCC + 0x2C
.equ RCC_CFGR, RCC + 0x0C
.equ RCC_APB1ENR, RCC + 0x38
.equ RCC_ICSCR, RCC + 0x04

@================================================@

.equ GPIOA, 0x50000000
.equ GPIOB, 0x50000400

.equ MODER_OFFSET, 0x00
.equ PUPDR_OFFSET, 0x0C
.equ IDR_OFFSET, 0x10
.equ ODR_OFFSET, 0x14

.equ GPIOA_MODER, GPIOA + MODER_OFFSET
.equ GPIOA_PUPDR, GPIOA + PUPDR_OFFSET
.equ GPIOA_IDR, GPIOA + IDR_OFFSET
.equ GPIOA_ODR, GPIOA + ODR_OFFSET

.equ GPIOB_MODER, GPIOB + MODER_OFFSET
.equ GPIOB_PUPDR, GPIOB + PUPDR_OFFSET
.equ GPIOB_IDR, GPIOB + IDR_OFFSET
.equ GPIOB_ODR, GPIOB + ODR_OFFSET

@================================================@

.equ STK_CSR, 0xE000E010
.equ STK_RVR, 0xE000E014 // initial value
.equ STK_CVR, 0xE000E018 // current value
.equ STK_CALIB, 0xE000E01C

.equ ICSR, 0xE000ED04 // Interrupt Control and State Register


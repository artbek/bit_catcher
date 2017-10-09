.equ DELAY, 0x0000ffff
.equ MASK, 0x1fffff //1000000


@ STM32L031K6

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

.equ GPIOA_MODER, GPIOA + 0x00
.equ GPIOA_PUPDR, GPIOA + 0x0C
.equ GPIOA_IDR, GPIOA + 0x10
.equ GPIOA_ODR, GPIOA + 0x14

@================================================@

.equ STK_CSR, 0xE000E010
.equ STK_RVR, 0xE000E014 // initial value
.equ STK_CVR, 0xE000E018 // current value
.equ STK_CALIB, 0xE000E01C

.equ ICSR, 0xE000ED04 // Interrupt Control and State Register


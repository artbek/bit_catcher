.thumb
.syntax unified
.cpu cortex-m0plus

.word 0x20001000
.word _start + 1 /* Reset */
.word 0 /* NMI */
.word 0 /* HardFault */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* SVCall */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* PendSV */
.word _systick_handler + 1 /* SysTick */
.word 0 /* IRQ0 */


.global _start

_systick_handler:

	subs r6, #1
	beq _go_to_seep

	ldr r0, =GPIOA_ODR
	movs r1, #0

	@ create bitmask
	movs r3, #1
	lsls r3, r1

	@ set the bit
	ldr r2, [r0]
	eors r2, r3
	str r2, [r0]

	bx lr

_go_to_seep:
	sev
	wfe
	wfe
	bx lr


_start:

	@ enable clock for IPPORT
	ldr r0, =RCC_IOPENR
	movs r1, #0
	bl _set_bit

	@ set PA0 to output
	ldr r0, =GPIOA_MODER
	movs r1, #0
	bl _set_bit
	movs r1, #1
	bl _clear_bit

	@ set PA1 to output
	ldr r0, =GPIOA_MODER
	movs r1, #2
	bl _set_bit
	movs r1, #3
	bl _clear_bit


	@ sysclock speed
	ldr r0, =RCC_ICSCR
	movs r1, 15
	bl _set_bit
	movs r1, 14
	bl _clear_bit
	movs r1, 13
	bl _clear_bit

	@ set PA9 to MCO
	ldr r0, =GPIOA_MODER
	movs r1, #19
	bl _set_bit
	movs r1, #18
	bl _clear_bit

	@ enable MCO
	ldr r0, =RCC_CFGR
	movs r1, #24
	bl _set_bit



	ldr r0, =RCC_APB1ENR @ enable clock for PWR
	movs r1, #28
	bl _set_bit

	ldr r0, =SCR
	movs r1, #2 @ enable SLEEPDEEP
	bl _set_bit

	ldr r0, =PWR_CR
	movs r1, #1 @ standby (PDDS bit)
	bl _set_bit

	ldr r0, =PWR_CSR
	movs r1, #10
	bl _set_bit

	@@ set PA3 to input
	@ldr r0, =GPIOA_MODER
	@movs r1, #6
	@bl _clear_bit
	@movs r1, #5
	@bl _clear_bit

	@@ set PA3 to input (pull down)
	@ldr r0, =GPIOA_PUPDR
	@movs r1, #6
	@bl _set_bit
	@movs r1, #5
	@bl _clear_bit


	ldr r0, =STK_RVR
	ldr r1, =MASK // set initial value
	str r1, [r0]

	ldr r0, =STK_CVR
	ldr r1, =MASK // set initial value
	str r1, [r0]

	ldr r0, =STK_CSR
	movs r1, #2 // use processor clock
	bl _set_bit

	ldr r0, =STK_CSR
	movs r1, #1 // enable the SysTick interrupt
	bl _set_bit

	ldr r0, =STK_CSR
	movs r1, #0 // enable the SysTick counter
	bl _set_bit


	movs r6, #3


loop:

	@ ON
	ldr r0, =GPIOA_ODR
	movs r1, #1
	bl _set_bit

	ldr r0, =DELAY
	bl _delay

	@ OFF
	ldr r0, =GPIOA_ODR
	movs r1, #1
	bl _clear_bit

	ldr r0, =DELAY
	bl _delay

	ldr r0, =GPIOA_IDR
	ldr r2, [r0]
	movs r1, #0b0100
	ands r2, r1
	bne _sleep

	ldr r0, =PWR_CR
	movs r1, #2 @ CWUF
	bl _set_bit

	@ldr r0, =PWR_CR
	@movs r1, #3 @ CSBF
	@bl _set_bit

	b loop

_sleep:

	ldr r0, =PWR_CR
	movs r1, #2 @ CWUF
	bl _set_bit
	
	sev
	wfe
	wfe

	bx lr

libraries:

.include "constants.S"
.include "helpers.S"


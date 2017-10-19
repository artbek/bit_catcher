.thumb
.syntax unified
.cpu cortex-m0plus

.align 2
.global _start

.include "vector_table.s"
.include "mappings.s"
.include "STM32L031x6.s"
.include "constants.s"

.include "interrupt_handlers.s"
.include "macros.s"
.include "display.s"


_start:

	@ A small idle delay, just because...

	ldr r1, =0x0001ffff
	push {r1}; bl _helpers__delay


	@ Enable GPIO clocks...

	ldr   r0, =RCC_IOPENR
	movs  r1, #0 @ IOPAEN (PORT A)
	movs  r2, #1 @ set
	push {r0, r1, r2}
	bl    _helpers__sr_bit

	ldr   r0, =RCC_IOPENR
	movs  r1, #1 @ IOPBEN (PORT B)
	movs  r2, #1 @ set
	push {r0, r1, r2}
	bl    _helpers__sr_bit


	@ CORE STUFF...

	bl _helpers__select_clock_speed
	bl _helpers__enable_systic
	@ bl _helpers__mco_enable


	@ Init DISPLAY outputs...

	macros__init_pin COL_1
	macros__init_pin COL_2
	macros__init_pin COL_3
	macros__init_pin COL_4
	macros__init_pin COL_5

	macros__init_pin ROW_1
	macros__init_pin ROW_2
	macros__init_pin ROW_3
	macros__init_pin ROW_4
	macros__init_pin ROW_5
	macros__init_pin ROW_6
	macros__init_pin ROW_7

	@ldr r0, =COL_1; push {r0}; bl _helpers__set_pin_high
	@ldr r0, =COL_2; push {r0}; bl _helpers__set_pin_high
	@ldr r0, =COL_3; push {r0}; bl _helpers__set_pin_high
	@ldr r0, =COL_4; push {r0}; bl _helpers__set_pin_high
	@ldr r0, =COL_5; push {r0}; bl _helpers__set_pin_high

	bl _display__clear


	@ DISPLAY

	@bl _display__clear
	bl _display__init


	@ Init LEFT/RIGHT buttons...

	macros__init_pin BTN_L
	macros__init_pin BTN_R


	@ Init ON/OFF button...

	ldr r0, =RCC_APB1ENR
	movs r1, #28 @ Enable clock for PWR.
	movs  r2, #1 @ set
	push {r0, r1, r2}; bl _helpers__sr_bit

	ldr r0, =SCR
	movs r1, #2 @ Enable SLEEPDEEP.
	movs  r2, #1 @ set
	push {r0, r1, r2}; bl _helpers__sr_bit

	ldr r0, =PWR_CR
	movs r1, #1 @ Standby when DeepSleep (PDDS bit).
	movs  r2, #1 @ set
	push {r0, r1, r2}; bl _helpers__sr_bit

	ldr r0, =PWR_CSR
	movs r1, #8 @ WKUP pin 1 (PA0).
	movs  r2, #1 @ set
	push {r0, r1, r2}; bl _helpers__sr_bit


_loop:
	@ DISPLAY

	bl _display__flush


	@ LEFT/RIGHT pressed...

	ldr r0, =BTN_L
	push {r0}
	bl _helpers__read_pin
	bcc _action_off
	b _after_action_off

_action_off:
	ldr r0, =ROW_7
	push {r0}
	bl _helpers__set_pin_low
	bl _helpers__reset_auto_power_off
	b _after_action_off

_after_action_off:


	ldr r0, =BTN_R
	push {r0}
	bl _helpers__read_pin
	bcc _action_on
	b _after_action_on

_action_on:
	ldr r0, =ROW_7
	push {r0}
	bl _helpers__set_pin_high
	bl _helpers__reset_auto_power_off
	b _after_action_on

_after_action_on:


	@ ON/OFF pressed...

	ldr r0, =BTN_ONOFF
	push {r0}
	bl _helpers__read_pin
	bcc _moveon
	bl _helpers__go_to_sleep

_moveon:

	b   _loop


.include "helpers.s"

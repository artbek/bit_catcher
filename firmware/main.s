.thumb
.syntax unified
.cpu cortex-m0plus

.align 2
.global _start

.include "vector_table.s"
.include "STM32L031x6.s"
.include "mappings.s"
.include "constants.s"

.include "interrupt_handlers.s"

.pool @ Literal Pools have limited range and LDR may fail.

.include "macros.s"
.include "display.s"

.pool @ Literal Pools have limited range and LDR may fail.


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
	macros__init_pin COL_DECIMAL

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

	@ init scroll
	movs r0, 0
	mov r8, r0
	movs r7, 5
	movs r6, 1
	push {r6, r7}

	@ init game state
	ldr r0, =GAME_STATE
	movs r1, 1
	str r1, [r0]


	@ TIM21
	macros__register_bit_sr RCC_APB2ENR 2 1 @ Enable clock for TIM21.

	ldr r0, =TIM21_ARR
	ldr r1, =52 @ ARR
	str r1, [r0]

	ldr r0, =TIM21_PSC
	ldr r1, =0x8fff @ Prescaler.
	str r1, [r0]

	macros__register_bit_sr TIM21_CR1 6 1 @ Center-aligned mode.
	macros__register_bit_sr TIM21_CR1 5 1 @ Center-aligned mode.
	macros__register_bit_sr TIM21_CR1 0 1 @ CEN (Clock Enable).


_loop:
	@ DISPLAY

	bl _display__flush

	ldr r0, =GAME_STATE
	ldr r1, [r0]
	cmp r1, 0
	beq _game_state_0
	cmp r1, 1
	beq _game_state_1

	_game_state_0:
		pop {r6, r7}
		subs r7, 1
		bne _dont_move_cursor
			movs r7, 10
			add r8, r6
			movs r0, 27
			cmp r8, r0
			bge _direction_back
			movs r0, 0
			cmp r8, r0
			ble _direction_forward
			bgt _dont_move_cursor

			_direction_back:
				movs r6, 0
				subs r6, 1
				b _dont_move_cursor
			_direction_forward:
				movs r6, 1
				b _dont_move_cursor

		_dont_move_cursor:
		push {r6, r7}
		b _break

	_game_state_1:
		@ scroll down
		ldr r0, =TIM21_CNT
		ldr r0, [r0]
		lsrs r0, 1
		mov r8, r0
		adds r0, r0
		b _break

	_game_state_2:
		@ scroll down
		ldr r0, =TIM21_CNT
		ldr r0, [r0]
		adds r0, r0
		bne _dont_shift_yet
			bl _display__shift_down
			@ add new row

			@ Re-initialise the counter by setting the UG (Update Generation) bit
			macros__register_bit_sr TIM21_EGR 0 1

		_dont_shift_yet:

		b _break


	_break:



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

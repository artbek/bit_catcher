.thumb
.syntax unified
.cpu cortex-m0plus

.align 2
.global _start

.include "vector_table.s"
.include "STM32L031x6.s"
.include "mappings.s"
.include "constants.s"
.include "macros.s"

.include "interrupt_handlers.s"

.pool @ Literal Pools have limited range and LDR may fail.

.include "display.s"
.include "game.s"

.pool @ Literal Pools have limited range and LDR may fail.


_start:

	@ ON/OFF switch bounce.
	ldr r1, =0x0002ffff
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

	macros__register_value GPIOA_OSPEEDR 0xffffffff


	@ SYSCLK + SysTick...
	bl _helpers__sysclk
	bl _helpers__mco_enable
	bl _helpers__enable_systick


	@ TIM21 timer...
	macros__register_bit_sr RCC_APB2ENR 2 1 @ Enable clock for TIM21.
	macros__register_bit_sr TIM21_CR1 6 1 @ Center-aligned mode.
	macros__register_bit_sr TIM21_CR1 5 1 @ Center-aligned mode.
	macros__register_bit_sr TIM21_DIER 0 1 @ UIE (Update Interrupt Enable)
	macros__register_bit_sr NVIC_ISER 20 1 @ Interrupt Enable.
	macros__register_bit_sr TIM21_CR1 0 1 @ CEN (Clock Enable).


	@ Init DISPLAY outputs...

	macros__init_row_pin ROW_1
	macros__init_row_pin ROW_2
	macros__init_row_pin ROW_3
	macros__init_row_pin ROW_4
	macros__init_row_pin ROW_5
	macros__init_row_pin ROW_6
	macros__init_row_pin ROW_7

	macros__init_pin COL_1
	macros__init_pin COL_2
	macros__init_pin COL_3
	macros__init_pin COL_4
	macros__init_pin COL_5
	macros__init_pin COL_DECIMAL


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

	@ Init game ...
	bl _display__init_white
	bl _game__stage_0_init

	movs r0, 0
	mov r12, r0


b _loop
	.pool @ Literal Pools have limited range and LDR may fail.

_loop:

	bl _display__flush


	ldr r1, =GAME_STAGE
	ldr r1, [r1]
	cmp r1, 0; beq _game_stage_0
	cmp r1, 1; beq _game_stage_1
	cmp r1, 2; beq _game_stage_2
	b _break

	@ ============================= @

	_game_stage_0:

		@ Display:
		ldr r0, =TIM21_CNT
		ldr r0, [r0]
		ldr r2, =GAME__STAGE0_PSC2
		lsrs r0, r2
		ldr r1, =DISPLAY_BUFFER_CURSOR
		str r0, [r1]

		@ Inputs:
		ldr r0, =BTN_L
		push {r0}
		bl _helpers__read_pin
		bcs _break
			bl _helpers__reset_auto_power_off
			bl _game__stage_1_init

	b _break


	@ ============================= @

	_game_stage_1:

		@ Display:
		bl _game__add_tray_to_display_buffer

		@ Inputs:
		bl _game__process_lr_buttons

	b _break

	@ ============================= @

	_game_stage_2:

		@ Display:
		ldr r0, =TIM21_CNT
		ldr r0, [r0]
		ldr r2, =GAME__STAGE2_PSC2
		lsrs r0, r2
		ldr r1, =DISPLAY_BUFFER_CURSOR
		str r0, [r1]

		@ Inputs:
		ldr r0, =BTN_L
		push {r0}
		bl _helpers__read_pin
		bcs _break
			bl _helpers__reset_auto_power_off
			bl _game__stage_0_init

	b _break

	@ ============================= @


	_break:


	@ ON/OFF pressed...

	ldr r0, =BTN_ONOFF
	push {r0}
	bl _helpers__read_pin
	bcc _keep_running
		bl _helpers__go_to_sleep
	_keep_running:


b _loop


.include "helpers.s"

b _start


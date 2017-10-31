_nmi_handler:
	movs r6, #120
	bx lr


_hard_fault_handler:
	push {lr}
	bkpt
	pop {pc}


_svcall_handler:
	movs r6, #122
	bx lr


_pendsv_handler:
	movs r6, #123
	bx lr


_systick_handler:
	push {r0-r7, lr}

	ldr r0, =AUTO_POWER_OFF_TIME_REGISTER
	ldr r1, [r0]
	subs r1, #1
	bne _update_counter
	bl _helpers__go_to_sleep

	_update_counter:
		str r1, [r0]

	pop {r0-r7, pc}


_interrupt_handlers__TIM21:
	push {lr}

	ldr r1, =GAME_STAGE
	ldr r1, [r1]
	cmp r1, 0; beq _tim21_game_stage_0
	cmp r1, 1; beq _tim21_game_stage_1
	b _tim21_break

	_tim21_game_stage_0:
		b _tim21_break

	_tim21_game_stage_1:

		bl _display__shift_down

		ldr r0, =FALLING_BIT_COUNTER
		ldr r1, [r0]
		adds r2, r1, r1
		bne _dont_generate_new_row_yet
			ldr r1, =FALLING_BIT_COUNTER_RELOAD_VALUE
			str r1, [r0] @ Reset the counter.
			bl _game__generate_new_row_at_first_address
		_dont_generate_new_row_yet:
			subs r1, 1
			str r1, [r0]

		b _tim21_break

	_tim21_break:
	macros__register_bit_sr TIM21_SR 0 0 @ Clear UIF (Update Interrup Flag).

	pop {pc}


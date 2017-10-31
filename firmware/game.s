_game__stage_0_init:
	push {r0-r7, lr}

	macros__register_value GAME_STAGE 0

	macros__register_bit_sr TIM21_CR1 0 0 @ CEN (Clock Disable).
	macros__register_value TIM21_ARR 26 @ ARR.
	macros__register_value TIM21_PSC 0xffff @ Prescaler.
	macros__register_bit_sr TIM21_CR1 0 1 @ CEN (Clock Enable).

	bl _display__init

	pop {r0-r7, pc}


_game__stage_1_init:
	push {r0-r7, lr}

	macros__register_value GAME_STAGE 1

	macros__register_bit_sr TIM21_CR1 0 0 @ CEN (Clock Disable).
	macros__register_value TIM21_ARR 20 @ ARR.
	macros__register_value TIM21_PSC 10000 @ Prescaler.
	macros__register_bit_sr TIM21_CR1 0 1 @ CEN (Clock Enable).

	bl _display__init_blank

	movs r0, 0
	mov r10, r0
	mov r11, r0

	ldr r0, =FALLING_BIT_CURRENT_SHAPE_POINTER
	ldr r1, =FALLING_BIT_FIRST_SHAPE_ADDR
	str r1, [r0]

	macros__register_value FALLING_BIT_COUNTER 0
	macros__register_value TRAY_POSITION 0

	macros__register_value GAME_CURRENT_SCORE 0

	pop {r0-r7, pc}


_game__stage_2_init:
	push {r0-r7, lr}

	macros__register_value GAME_STAGE 2

	macros__register_bit_sr TIM21_CR1 0 0 @ CEN (Clock Disable).
	macros__register_value TIM21_ARR 26 @ ARR.
	macros__register_value TIM21_PSC 0xffff @ Prescaler.
	macros__register_bit_sr TIM21_CR1 0 1 @ CEN (Clock Enable).

	bl _display__init_score

	pop {r0-r7, pc}


_game__score_increase:
	push {r0-r7, lr}

	ldr r0, =GAME_CURRENT_SCORE
	ldr r1, [r0]

	adds r1, 1
	str r1, [r0]


	pop {r0-r7, pc}


_game__generate_new_row_at_first_address:
	push {r0-r7, lr}

	ldr r0, =FALLING_BIT_CURRENT_SHAPE_POINTER
	ldr r1, [r0] @ R1 is current shape address (EEPROM).
	ldr r2, [r1] @ ROM addr (acutal shape).

	ldr r3, =DISPLAY_BUFFER_FIRST_ADDR
	str r2, [r3] @ Send to display.

	adds r1, 4
	ldr r2, =FALLING_BIT_LAST_SHAPE_ADDR
	cmp r1, r2
	ble _store_new_shape_addr
		ldr r1, =FALLING_BIT_FIRST_SHAPE_ADDR
	_store_new_shape_addr:
	str r1, [r0]

	pop {r0-r7, pc}


_game__add_tray_to_display_buffer:
	push {r0-r7, lr}

	movs r2, 0b11
	lsls r2, 30

	ldr r0, =TRAY_POSITION
	ldr r1, [r0]
	lsrs r2, r1
	mov r10, r2 @ Save tray word in R10.

	ldr r3, =DISPLAY_BUFFER_LAST_ADDR
	ldr r4, [r3]
	mov r11, r4 @ Save display bottom row word in R11.

	orrs r2, r4 @ Combine tray and display bottom row.
	str r2, [r3]

	pop {r0-r7, pc}


_game__move_tray_left:
	push {r0-r7, lr}

	ldr r0, =TRAY_POSITION
	ldr r1, [r0]
	subs r1, 1
	bpl _store_new_tray_position_l
		movs r1, 0
	_store_new_tray_position_l:
	str r1, [r0]

	pop {r0-r7, pc}


_game__move_tray_right:
	push {r0-r7, lr}

	MAX_TRAY_POSITION .req r3
	movs MAX_TRAY_POSITION, 3

	ldr r0, =TRAY_POSITION
	ldr r1, [r0]
	adds r1, 1
	cmp r1, MAX_TRAY_POSITION
	ble _store_new_tray_position_r
		movs r1, MAX_TRAY_POSITION
	_store_new_tray_position_r:
	str r1, [r0]

	pop {r0-r7, pc}


_game__process_lr_buttons:
	push {r0-r7, lr}

	ldr r0, =BUTTON_PROCESSING_LOCKED
	ldr r1, [r0]
	adds r1, r1
	bne _button_processing_locked

		ldr r0, =BTN_L
		push {r0}
		bl _helpers__read_pin
		bcs _after_action_left
			macros__register_value BUTTON_PROCESSING_LOCKED 1
			bl _game__move_tray_left
			bl _helpers__reset_auto_power_off
			b _button_processing_locked
		_after_action_left:

		ldr r0, =BTN_R
		push {r0}
		bl _helpers__read_pin
		bcs _after_action_right
			macros__register_value BUTTON_PROCESSING_LOCKED 1
			bl _game__move_tray_right
			bl _helpers__reset_auto_power_off
			b _button_processing_locked
		_after_action_right:

	_button_processing_locked:

	ldr r0, =BTN_L
	push {r0}
	bl _helpers__read_pin
	bcc _one_of_buttons_still_pressed
		ldr r0, =BTN_R
		push {r0}
		bl _helpers__read_pin
		bcc _one_of_buttons_still_pressed
			macros__register_value BUTTON_PROCESSING_LOCKED 0
	_one_of_buttons_still_pressed:

	pop {r0-r7, pc}


_display__init_blank:
	push {r0-r7, lr}

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR
	movs r1, 0
	str r1, [r0, 0]
	str r1, [r0, 4]
	str r1, [r0, 8]
	str r1, [r0, 12]
	str r1, [r0, 16]
	str r1, [r0, 20]
	str r1, [r0, 24]

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	pop {r0-r7, pc}


_display__init_white:
	push {r0-r7, lr}

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR
	ldr r1, =0xffffffff
	str r1, [r0, 0]
	str r1, [r0, 4]
	str r1, [r0, 8]
	str r1, [r0, 12]
	str r1, [r0, 16]
	str r1, [r0, 20]
	str r1, [r0, 24]

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	pop {r0-r7, pc}


_display__init_poster:
	push {r0-r7, lr}

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR
	subs r0, 4

	adds r0, 4; ldr r1, =0b11111000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b11011000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01011000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00010000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00010000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01000000000000000000000000000000; str r1, [r0]
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];

	pop {r0-r7, pc}


_display__init_current_score:
	push {r0-r7, lr}

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR

	adds r0, 0; ldr r1, =0b00000000000000000000000000000000; str r1, [r0]
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00111000000000000000000000111000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00111000000000000000000000111000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];

	pop {r0-r7, pc}


_display__add_boom:
	push {r0-r7, lr}

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR

	adds r0, 0; ldr r1, =0b00100000000000000000000000000000; str r1, [r0]
	adds r0, 4; ldr r1, =0b10001000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01110000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b00000000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b11111000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b11111000000000000000000000000000; str r1, [r0];

	pop {r0-r7, pc}


_display__init_hi_score:
	push {r0-r7, lr}

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR

	adds r0, 0; ldr r1, =0b01001001000000000000000000000000; str r1, [r0]
	adds r0, 4; ldr r1, =0b01001000000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01001001001000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01111011001000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01001001000000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01001001001000000000000000000000; str r1, [r0];
	adds r0, 4; ldr r1, =0b01001011101000000000000000000000; str r1, [r0];

	pop {r0-r7, pc}


_display__flush:
	push {r0-r7, lr}

	ldr r2, =COL_1
	movs r3, 1 @ Column index.

	ldr r4, =DISPLAY_BUFFER_CURSOR
	ldr r4, [r4]
	adds r3, r4 @ Cursor-X.

	_col:
		ldr r0, =DISPLAY_BUFFER_FIRST_ADDR
		ldr r1, =ROW_1

		push {r0-r3} @ Save current row addr and current row data addr.
		push {r2}; bl _helpers__set_pin_high @ Column ON.
		pop {r0-r3} @ Load current row addr and current row data addr.

		_row:
			push {r0-r3} @ Save current row addr and current row data addr.

			ldr r4, [r0] @ R0: current row address.
			lsls r4, r3 @ Get the first bit.
			bcs _row_on @ If set (1) row on.
				push {r1}; bl _helpers__set_pin_high
				b _after_row_on
			_row_on:
				push {r1}; bl _helpers__set_pin_low

		_after_row_on:
			pop {r0-r3} @ Load current row addr and current row data addr.

			push {r0-r3} @ Save current row addr and current row data addr.
			mov r2, r12
			ldr r1, =DISPLAY__FADE_DARKNESS_MAX
			subs r1, r2
			push {r1}; bl _helpers__delay
			pop {r0-r3} @ Load current row addr and current row data addr.

			push {r0-r3} @ Save current row addr and current row data addr.
			push {r1}; bl _helpers__set_pin_high
			pop {r0-r3} @ Load current row addr and current row data addr.

			push {r0-r3} @ Save current row addr and current row data addr.
			mov r1, r12
			push {r1}; bl _helpers__delay
			pop {r0-r3} @ Load current row addr and current row data addr.

			adds r0, 4
			adds r1, 24 @ 6 words.

			ldr r4, =DISPLAY_BUFFER_LAST_ADDR
			cmp r0, r4
		ble _row

		push {r0-r3} @ Save current row addr and current row data addr.
		push {r2}; bl _helpers__set_pin_low @ Column OFF.
		pop {r0-r3} @ Load current row addr and current row data addr.

		adds r2, 24 @ Next colum data address. 6 words.
		adds r3, 1 @ Next column index.
		ldr r4, =COL_5
		cmp r2, r4
	ble _col

	pop {r0-r7, pc}


_display__shift_down:
	push {r0-r7, lr}

	ldr r3, =DISPLAY_BUFFER_FIRST_ADDR
	ldr r0, =DISPLAY_BUFFER_LAST_ADDR

	_keep_shifing:
		mov r1, r0
		subs r0, 4
		ldr r5, [r0]
		str r5, [r1]
		cmp r0, r3
	bgt	_keep_shifing

	movs r0, 0
	str r0, [r3] @ Clear the first row.

	pop {r0-r7, pc}


_display__print_digit_on_position:
	@ R1 - digit
	@ R6 - position
	pop {r1, r6}

	push {r0-r7, lr}

	mov r2, r1

	@ Find digit's first address (save in R0)
	ldr r0, =DIGITS_FONT_FIRST_ADDR
	movs r5, (7 * 4) @ Each digist is 7 words.
	muls r2, r5
	adds r0, r2

	ldr r2, =DISPLAY_BUFFER_FIRST_ADDR
	movs r7, 7 @ Number of rows.

	@ R0: digit font (first address).
	@ R2: display (first address).
	@ R7: number or rows.
	_digit_next_row:
		ldr r1, [r0]
		ldr r3, [r2]
		lsls r1, 27
		lsrs r1, r6
		orrs r3, r1
		str r3, [r2]

		adds r0, 4
		adds r2, 4
		subs r7, 1
	bne _digit_next_row

	pop {r0-r7, pc}


_display__fade_in:
	push {r0-r7, lr}

	ldr r0, =DISPLAY__FADE_DARKNESS_MIN
	ldr r1, =DISPLAY__FADE_DARKNESS_MAX
	ldr r2, =DISPLAY__FADE_OUT_STEP
	_fade_in_more:
		mov r12, r1
		push {r0,r1}
		bl _display__flush
		pop {r0,r1}
		subs r1, r2
		cmp r1, r0
	bge _fade_in_more

	pop {r0-r7, pc}


_display__fade_out:
	push {r0-r7, lr}

	ldr r0, =DISPLAY__FADE_DARKNESS_MAX
	ldr r1, =DISPLAY__FADE_DARKNESS_MIN
	ldr r2, =DISPLAY__FADE_OUT_STEP
	_fade_out_more:
		mov r12, r1
		push {r0,r1}
		bl _display__flush
		pop {r0,r1}
		adds r1, r2
		cmp r1, r0
	blt _fade_out_more

	pop {r0-r7, pc}


_display__pause:
	push {r0-r7, lr}

	ldr r0, =DISPLAY__PAUSE
	ldr r2, =DISPLAY__PAUSE_STEP
	movs r1, 0
	_pause_more:
		push {r0,r1}
		bl _display__flush
		pop {r0,r1}
		adds r1, r2
		cmp r1, r0
	blt _pause_more

	pop {r0-r7, pc}


_display__pause_short:
	push {r0-r7, lr}

	ldr r0, =DISPLAY__PAUSE_SHORT
	ldr r2, =DISPLAY__PAUSE_SHORT_STEP
	movs r1, 0
	_pause_short_more:
		push {r0,r1}
		bl _display__flush
		pop {r0,r1}
		adds r1, r2
		cmp r1, r0
	blt _pause_short_more

	pop {r0-r7, pc}


_display__print_number:
	@ R0: number to print.
	@ R7: position index.
	pop {r0, r7} @ R0: number to print.

	push {r0-r7, lr}

	movs r4, 2 @ Digit display index (3 digits to display).

	_display_with_score_next_digit:
		movs r2, 0 @ Start with digit 0.
		movs r1, r0

		_keep_dividing:
			adds r2, 1
			subs r1, 10
			cmp r1, 0
		bge _keep_dividing

		subs r2, 1 @ We started at digit 1. R2: updated score.

		movs r5, 10
		movs r3, r2
		muls r3, r5
		movs r1, r0
		subs r1, r3 @ R1: first digit.

		push {r0-r7}

		movs r5, 6
		movs r6, r4
		muls r6, r5
		adds r6, r7 @ R7: x-offset.
		push {r1, r6}; bl _display__print_digit_on_position

		pop {r0-r7}

		movs r0, r2 @ Updated score: result of intiger division by 10.

		subs r4, 1
	bge _display_with_score_next_digit

	pop {r0-r7, pc}

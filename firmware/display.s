_display__init:
	push {lr}

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR
	ldr r1, =0b10101010100000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b01010101010000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b10101010100000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b01010101000000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b10101010100000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b01010101010000000000000000000000
	str r1, [r0]

	adds r0, 4
	ldr r1, =0b10101010101000000000000000000000
	str r1, [r0]

	pop {pc}


	// ldr r0, =ROW_1; push {r0}; bl _helpers__set_pin_low
_display__flush:
	push {lr}

	ldr r2, =COL_1
	movs r3, 1 @ Column index.

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

			push {r0-r3} @ Save current row addr and current row data addr.
			ldr r1, =0x0000000f
			push {r1}; bl _helpers__delay
			pop {r0-r3} @ Load current row addr and current row data addr.

			pop {r0-r3} @ Load current row addr and current row data addr.
			adds r0, 4
			adds r1, 24 @ 6 words.

			ldr r4, =DISPLAY_BUFFER_LAST_ADDR
			cmp r0, r4
		ble _row

		push {r0-r3} @ Save current row addr and current row data addr.
		push {r2}; bl _helpers__set_pin_low @ Column OFF.
		bl _display__clear
		pop {r0-r3} @ Load current row addr and current row data addr.

		adds r2, 24 @ Next colum data address. 6 words.
		adds r3, 1 @ Next column index.
		ldr r4, =COL_5
		cmp r2, r4
	ble _col

	pop {pc}


_display__clear:
	push {lr}

	ldr r0, =ROW_1; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_2; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_3; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_4; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_5; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_6; push {r0}; bl _helpers__set_pin_high
	ldr r0, =ROW_7; push {r0}; bl _helpers__set_pin_high

	pop {pc}



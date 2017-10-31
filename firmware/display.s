_display__init_blank:
	push {r0-r7, lr}

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR

	.equ DISPLAY_BUFFER_ROW_1, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_2, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_3, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_4, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_5, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_6, 0b00000000000000000000000000000000
	.equ DISPLAY_BUFFER_ROW_7, 0b00000000000000000000000000000000

	adds r0, 0
	ldr r1, =DISPLAY_BUFFER_ROW_1
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_2
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_3
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_4
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_5
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_6
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_7
	str r1, [r0]

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	pop {r0-r7, pc}


_display__init:
	push {r0-r7, lr}

	macros__register_value DISPLAY_BUFFER_CURSOR 0

	ldr r0, =DISPLAY_BUFFER_FIRST_ADDR

	.equ DISPLAY_BUFFER_ROW_1, 0b01110000000000001001111100111000
	.equ DISPLAY_BUFFER_ROW_2, 0b10001000000000011000000101000100
	.equ DISPLAY_BUFFER_ROW_3, 0b00001000010000101000001001001100
	.equ DISPLAY_BUFFER_ROW_4, 0b00010001110001001000010001010100
	.equ DISPLAY_BUFFER_ROW_5, 0b00100000010001111100100001100100
	.equ DISPLAY_BUFFER_ROW_6, 0b01000000000000001000100001000100
	.equ DISPLAY_BUFFER_ROW_7, 0b11111000000000001000100000111000

	adds r0, 0
	ldr r1, =DISPLAY_BUFFER_ROW_1
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_2
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_3
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_4
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_5
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_6
	str r1, [r0]

	adds r0, 4
	ldr r1, =DISPLAY_BUFFER_ROW_7
	str r1, [r0]

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
			ldr r1, =0x0000000f
			push {r1}; bl _helpers__delay
			pop {r0-r3} @ Load current row addr and current row data addr.

			push {r0-r3} @ Save current row addr and current row data addr.
			push {r1}; bl _helpers__set_pin_high
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


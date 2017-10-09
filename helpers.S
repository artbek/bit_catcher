_set_bit:
	@ R0 - memory address
	@ R1 - bit number

	@ create bitmask
	movs r3, #1
	lsls r3, r1

	@ set the bit
	ldr r2, [r0]
	orrs r2, r3
	str r2, [r0]
	bx lr


_clear_bit:
	@ R0 - memory address
	@ R1 - bit number

	@ create bitmask
	movs r3, #1
	lsls r3, r1

	@ clear the bit
	ldr r2, [r0]
	bics r2, r3
	str r2, [r0]
	bx lr


_delay:
	@ R0 - delay value

	subs r0, #1
	bne _delay
	bx lr

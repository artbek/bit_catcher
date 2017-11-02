.macro macros__register_bit_sr REGISTER_CONST BIT_NUMBER SET_RESET

	push {r0-r7}

	ldr r0, =\REGISTER_CONST
	movs r1, \BIT_NUMBER
	movs r2, \SET_RESET
	push {r0, r1, r2}; bl _helpers__sr_bit

	pop {r0-r7}

.endm


.macro macros__register_value REGISTER_CONST REGISER_VALUE

	ldr r0, =\REGISTER_CONST
	ldr r1, =\REGISER_VALUE
	str r1, [r0]

.endm


.macro macros__init_pin PIN_LABEL

	ldr r0, =\PIN_LABEL
	push {r0}
	bl _helpers__init_pin

	ldr r0, =\PIN_LABEL
	push {r0}
	bl _helpers__set_pin_low

.endm


.macro macros__init_row_pin PIN_LABEL

	ldr r0, =\PIN_LABEL
	push {r0}
	bl _helpers__init_pin

	ldr r0, =\PIN_LABEL
	push {r0}
	bl _helpers__set_pin_high

.endm


.macro macros__update_2_bit_register M_OFFSET HIGH_BIT_REG LOW_BIT_REG

	push {r0-r5}

	pop {r0-r5}
	push {r0-r5} @ save original values

	@ register address
	ldr r7, =\M_OFFSET
	adds r0, r7

	@ bit number (high)
	movs r6, #2
	muls r1, r6
	adds r1, #1

	push {r0, r1, \HIGH_BIT_REG}
	bl _helpers__sr_bit


	pop {r0-r5}
	push {r0-r5} @ save original values

	@ register address
	ldr r7, =\M_OFFSET
	adds r0, r7

	@ bit number (low)
	movs r6, #2
	muls r1, r6

	push {r0, r1, \LOW_BIT_REG}
	bl _helpers__sr_bit

	pop {r0-r5}

.endm

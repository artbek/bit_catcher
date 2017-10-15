_nmi_handler:
	movs r6, #120
	bx lr

_hard_fault_handler:
	movs r6, #121
	bx lr

_svcall_handler:
	movs r6, #122
	bx lr

_pendsv_handler:
	movs r6, #123
	bx lr

_systick_handler:
	push {lr}

	ldr r0, =AUTO_POWER_OFF_TIME_REGISTER
	ldr r1, [r0]
	subs r1, #1
	bne _update_counter
	bl _helpers__go_to_sleep

	_update_counter:
		str r1, [r0]

	pop {pc}


.equ AUTO_POWER_OFF_TIME_REGISTER, SRAM


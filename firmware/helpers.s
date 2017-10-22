_helpers__init_pin:
	pop {r0}

	push {lr}

	ldm r0, {r0-r5}

	macros__update_2_bit_register MODER_OFFSET r2 r3
	macros__update_2_bit_register PUPDR_OFFSET r4 r5

	pop {pc}


_helpers__read_pin:
	pop {r0}

	push {lr}

	ldm r0, {r0-r5}

	ldr r7, =IDR_OFFSET
	adds r0, r7

	ldr r5, [r0]
	adds r1, #1
	lsrs r5, r1

	pop {pc}


_helpers__set_pin_high:
	@ start address of pin data block.
	pop {r0}

	push {lr}

	ldm r0, {r0-r1}
	ldr r2, =ODR_OFFSET
	adds r0, r2
	movs r2, #1 @ set

	push {r0, r1, r2}
	bl _helpers__sr_bit

	pop {pc}


_helpers__set_pin_low:
	@ start address of pin data block.
	pop {r0}

	push {lr}

	ldm r0, {r0-r1}
	ldr r2, =ODR_OFFSET
	adds r0, r2
	movs r2, #0 @ clear

	push {r0, r1, r2}
	bl _helpers__sr_bit

	pop {pc}


_helpers__sr_bit:
	@ memory address
	@ bit number
	@ bit value
	pop {r0, r1, r2}

	push {lr}

	@ create bitmask
	movs r3, #1
	lsls r3, r1

	ldr r5, [r0]

	@ update the bit
	adds r2, r2
	beq _clear_bit
	bne _set_bit

	_clear_bit:
		bics r5, r3
		str r5, [r0]
		pop {pc}

	_set_bit:
		orrs r5, r3
		str r5, [r0]
		pop {pc}


_helpers__delay:
	@ R0 - delay value

	pop {r0}
	push {lr}

	_local_delay:
		subs r0, #1
		bne _local_delay

	pop {pc}


_helpers__go_to_sleep:
	ldr r0, =PWR_CR
	movs r1, #2 @ CWUF: Clear WUF (Wakeup flag)
	movs r2, #1 @ set
	push {r0, r1, r2}
	bl _helpers__sr_bit

	sev; wfe @ Reset the event flag.
	wfe @ Go to sleep.

	bx lr


_helpers__select_clock_speed:
	push {lr}

	@ 000: range 0 around 65.536 kHz
	@ 001: range 1 around 131.072 kHz
	@ 010: range 2 around 262.144 kHz
	@ 011: range 3 around 524.288 kHz
	@ 100: range 4 around 1.048 MHz
	@ 101: range 5 around 2.097 MHz (reset value)
	@ 110: range 6 around 4.194 MHz

  ldr r0, =RCC_ICSCR
  movs r1, #15
  movs r2, #1
	push {r0, r1, r2}
  bl _helpers__sr_bit

  movs r1, #14
  movs r2, #0
	push {r0, r1, r2}
  bl _helpers__sr_bit

  movs r1, #13
  movs r2, #0
	push {r0, r1, r2}
  bl _helpers__sr_bit

	pop {pc}


_helpers__mco_enable:
	push {lr}

  @ Set PA9 to MCO (alternate function)...

  ldr r0, =GPIOA_MODER
  movs r1, #19
  movs r2, #1
	push {r0, r1, r2}
  bl _helpers__sr_bit

  movs r1, #18
  movs r2, #0
	push {r0, r1, r2}
  bl _helpers__sr_bit

  @ Enable MCO...

  ldr r0, =RCC_CFGR
  movs r1, #24
  movs r2, #1
	push {r0, r1, r2}
  bl _helpers__sr_bit

	pop {pc}

_helpers__reset_auto_power_off:
	push {lr}

	ldr r0, =AUTO_POWER_OFF_TIME_REGISTER
	ldr r1, =AUTO_POWER_OFF_TIME_SECONDS
	str r1, [r0]

	pop {pc}


_helpers__enable_systic:
	push {lr}

	bl _helpers__reset_auto_power_off

	ldr r0, =STK_RVR
	ldr r1, =1000000 // Set reload value.
	str r1, [r0]

	ldr r0, =STK_CVR
	ldr r1, =1000000 // Set counter value.
	str r1, [r0]

	ldr r0, =STK_CSR
	movs r1, #2 // Use processor clock.
	movs r2, #1
	push {r0, r1, r2}
	bl _helpers__sr_bit

	ldr r0, =STK_CSR
	movs r1, #1 // Enable the SysTick interrupt.
	movs r2, #1
	push {r0, r1, r2}
	bl _helpers__sr_bit

	ldr r0, =STK_CSR
	movs r1, #0 // Enable the SysTick counter.
	movs r2, #1
	push {r0, r1, r2}
	bl _helpers__sr_bit

	pop {pc}


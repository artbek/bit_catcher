_helpers__init_pin:
	pop {r0}

	push {r0-r7, lr}

	ldm r0, {r0-r5}

	macros__update_2_bit_register MODER_OFFSET r2 r3
	macros__update_2_bit_register PUPDR_OFFSET r4 r5

	pop {r0-r7, pc}


_helpers__read_pin:
	pop {r0}

	push {r0-r7, lr}

	ldm r0, {r0-r5}

	ldr r7, =IDR_OFFSET
	adds r0, r7

	ldr r5, [r0]
	adds r1, #1
	lsrs r5, r1

	pop {r0-r7, pc}


_helpers__set_pin_high:
	@ start address of pin data block.
	pop {r0}

	push {r2-r3, lr}

	ldm r0, {r0-r1}
	movs r2, 0x18 @ BSRR_OFFSET
	adds r0, r2

	@ R0: memory address.
	@ R1: bit index number.

	movs r3, #1
	lsls r3, r1 @ Create bitmask.
	ldr r2, [r0] @ Load current value.
	orrs r2, r3 @ Update current value.
	str r2, [r0] @ Store new value.

	pop {r2-r3, pc}


_helpers__set_pin_low:
	@ start address of pin data block.
	pop {r0}

	push {r2-r3, lr}

	ldm r0, {r0-r1}
	movs r2, 0x28 @ BRR_OFFSET
	adds r0, r2

	@ R0: memory address.
	@ R1: bit index number.

	movs r3, #1
	lsls r3, r1 @ Create bitmask.
	ldr r2, [r0] @ Load current value.
	orrs r2, r3 @ Update current value.
	str r2, [r0] @ Store new value.

	pop {r2-r3, pc}


_helpers__sr_bit:
	@ memory address
	@ bit number
	@ bit value
	pop {r0, r1, r2}

	push {r0-r4, lr}

	@ create bitmask
	movs r3, #1
	lsls r3, r1

	ldr r4, [r0]

	@ update the bit
	adds r2, r2
	beq _clear_bit
	bne _set_bit

	_clear_bit:
		bics r4, r3
		str r4, [r0]
		pop {r0-r4, pc}

	_set_bit:
		orrs r4, r3
		str r4, [r0]
		pop {r0-r4, pc}


_helpers__delay:
	@ R0 - delay value

	pop {r0}
	push {lr}

	_local_delay:
		subs r0, #1
		bgt _local_delay

	pop {pc}


_helpers__go_to_sleep:
	push {r0-r7, lr}

	ldr r0, =PWR_CR
	movs r1, #2 @ CWUF: Clear WUF (Wakeup flag)
	movs r2, #1 @ set
	push {r0, r1, r2}
	bl _helpers__sr_bit

	sev; wfe @ Reset the event flag.
	wfe @ Go to sleep.

	pop {r0-r7, pc}


_helpers__sysclk:
	push {r0-r7, lr}

	macros__register_bit_sr RCC_CR 0 1 @ Enable HSI16ON.

	@ Select SYSCLK source (HSI16)
	macros__register_bit_sr RCC_CFGR 1 0
	macros__register_bit_sr RCC_CFGR 0 1

	@ HPRE (Prescaler)
	@ 0xxx: SYSCLK not divided
	@ 1000: SYSCLK divided by 2
	@ 1001: SYSCLK divided by 4
	@ 1010: SYSCLK divided by 8
	@ 1011: SYSCLK divided by 16
	@ 1100: SYSCLK divided by 64
	@ 1101: SYSCLK divided by 128
	@ 1110: SYSCLK divided by 256
	@ 1111: SYSCLK divided by 512
	macros__register_bit_sr RCC_CFGR 7 1
	macros__register_bit_sr RCC_CFGR 6 0
	macros__register_bit_sr RCC_CFGR 5 0
	macros__register_bit_sr RCC_CFGR 4 0

	pop {r0-r7, pc}


_helpers__select_clock_speed:
	push {r0-r7, lr}

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
  movs r2, #1
	push {r0, r1, r2}
  bl _helpers__sr_bit

	pop {r0-r7, pc}


_helpers__mco_enable:
	push {lr}
	push {r0-r7, lr}

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
	@ 0000: MCO output disabled, no clock on MCO
	@ 0001: SYSCLK clock selected
	@ 0010: HSI16 oscillator clock selected
	@ 0011: MSI oscillator clock selected
	macros__register_bit_sr RCC_CFGR 25 0
	macros__register_bit_sr RCC_CFGR 24 1

	pop {r0-r7, pc}


_helpers__reset_auto_power_off:
	push {r0-r7, lr}

	ldr r0, =AUTO_POWER_OFF_TIME_REGISTER
	ldr r1, =AUTO_POWER_OFF_TIME_SECONDS
	str r1, [r0]

	pop {r0-r7, pc}


_helpers__enable_systick:
	push {r0-r7, lr}

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

	pop {r0-r7, pc}


_helpers__eeprom:
	push {r0-r7, lr}

	@ Unlock EEPROM:
	ldr r0, =FLASH_PEKEYR
	ldr r1, =PEKEY1
	str r1, [r0]
	ldr r1, =PEKEY2
	str r1, [r0]

	@ Lock EEPROM:
	macros__register_bit_sr FLASH_PECR 0 1

	pop {r0-r7, pc}


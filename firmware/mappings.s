@ DISPLAY COLUMNS (Outputs) @

COL_1: @ PA8 [18]
.word GPIOA @ Mode register.
.word 8 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

COL_2: @ PA15 [25]
.word GPIOA @ Mode register.
.word 15 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

COL_3: @ PA5 [11]
.word GPIOA @ Mode register.
.word 5 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

COL_4: @ PA12 [22]
.word GPIOA @ Mode register.
.word 12 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

COL_5: @ PA1 [7]
.word GPIOA @ Mode register.
.word 1 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

COL_DECIMAL: @ PA4 [10]
.word GPIOA @ Mode register.
.word 4 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.


@ DISPLAY ROWS (Outputs) @

ROW_1: @ PA11 [21]
.word GPIOA @ Mode register.
.word 11 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_2: @ PA2 [8]
.word GPIOA @ Mode register.
.word 2 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_3: @ PA10 [20]
.word GPIOA @ Mode register.
.word 10 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_4: @ PA9 [19]
.word GPIOA @ Mode register.
.word 9 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_5: @ PA3 [9]
.word GPIOA @ Mode register.
.word 3 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_6: @ PA7 [13]
.word GPIOA @ Mode register.
.word 7 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

ROW_7: @ PA6 [12]
.word GPIOA @ Mode register.
.word 6 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b1 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.



@ LEFT/RIGHT BUTTONS (Inputs) @

BTN_L: @ PB7 [30]
.word GPIOB @ Mode register.
.word 7 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b0 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.

BTN_R: @ PB4 [27]
.word GPIOB @ Mode register.
.word 4 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b0 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b1 @ PUPD value (low bit). 0 or 1.


@ ON/OFF (Input) @

BTN_ONOFF: @ PA0 [6]
.word GPIOA @ Mode register.
.word 0 @ Bit number (1-bit regs).
.word 0b0 @ Mode value (high bit). 0 or 1.
.word 0b0 @ Mode value (low bit). 0 or 1.
.word 0b0 @ PUPD value (high bit). 0 or 1.
.word 0b0 @ PUPD value (low bit). 0 or 1.


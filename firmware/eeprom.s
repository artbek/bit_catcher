.global _start

_start:

.org 0x010

@ Possible shapes:
@  1 | 00001
@  2 | 00010
@  4 | 00100
@  8 | 01000
@ 16 | 10000
.word 16,  4,  8,  1,  8,  4, 16,  1,  4,  1
.word  8,  2,  1,  4,  8,  4,  2,  4, 16,  1
.word  8, 16,  1,  4,  8,  1,  2,  4,  2,  1
.word 16,  4,  8,  1, 16,  1, 16,  4,  2,  8
.word 16,  4,  8,  1, 16,  8,  4,  8,  2,  8
.word  1,  8,  2, 16,  2,  1,  4,  8, 16,  2
.word  4,  1,  8, 16,  8,  2, 16,  1,  8,  1
.word  2, 16,  8,  1,  8,  4,  8,  4, 16,  4
.word  1,  4,  1,  4,  8,  2,  1,  4,  1, 16
.word  2,  1,  8,  2,  4, 16,  1,  8, 16,  1

.org 0x200

@ Digit 0:
.word 0b01110
.word 0b10001
.word 0b10011
.word 0b10101
.word 0b11001
.word 0b10001
.word 0b01110

@ Digit 1:
.word 0b00100
.word 0b01100
.word 0b00100
.word 0b00100
.word 0b00100
.word 0b00100
.word 0b01110

@ Digit 2:
.word 0b01110
.word 0b10001
.word 0b00001
.word 0b00010
.word 0b00100
.word 0b01000
.word 0b11111

@ Digit 3:
.word 0b11111
.word 0b00010
.word 0b00100
.word 0b00010
.word 0b00001
.word 0b10001
.word 0b01110

@ Digit 4:
.word 0b00010
.word 0b00110
.word 0b01010
.word 0b10010
.word 0b11111
.word 0b00010
.word 0b00010

@ Digit 5:
.word 0b11111
.word 0b10000
.word 0b11110
.word 0b00001
.word 0b00001
.word 0b10001
.word 0b01110

@ Digit 6:
.word 0b00010
.word 0b00100
.word 0b01000
.word 0b11110
.word 0b10001
.word 0b10001
.word 0b01110

@ Digit 7:
.word 0b11111
.word 0b00001
.word 0b00010
.word 0b00100
.word 0b01000
.word 0b01000
.word 0b01000

@ Digit 8:
.word 0b01110
.word 0b10001
.word 0b10001
.word 0b01110
.word 0b10001
.word 0b10001
.word 0b01110

@ Digit 9:
.word 0b01110
.word 0b10001
.word 0b10001
.word 0b01111
.word 0b00010
.word 0b00100
.word 0b01000


@=== RAM ===@

@ SRAM + 0x00 (1 word)
.equ AUTO_POWER_OFF_TIME_REGISTER, SRAM

@ SRAM + 0x04 -- SRAM + 0x1C (7 words)
.equ DISPLAY_BUFFER_FIRST_ADDR, SRAM + 0x04
.equ DISPLAY_BUFFER_LAST_ADDR, DISPLAY_BUFFER_FIRST_ADDR + (DISPLAY_BUFFER_ROWS_COUNT - 1) * 4

@ SRAM + 0x20 (1 word): 0 - 27
.equ DISPLAY_BUFFER_CURSOR, SRAM + 0x20

@ SRAM + 0x24 (1 word):
@ 0 - hi score
@ 1 - title (Race)
@ 2 - car scroll down + starting line
@ 3 - game
@ 4 - outro
@ 5 - score
.equ GAME_STATE, SRAM + 0x24


@=== VALUES ===@

.equ AUTO_POWER_OFF_TIME_SECONDS, 60
.equ DISPLAY_BUFFER_ROWS_COUNT, 7

.word 0x20001000
.word _start + 1 /* Reset */
.word _nmi_handler + 1 /* NMI */
.word _hard_fault_handler + 1 /* HardFault */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word _svcall_handler + 1 /* SVCall */
.word 0 /* Reserved */
.word 0 /* Reserved */
.word _pendsv_handler + 1 /* PendSV */
.word _systick_handler + 1 /* SysTick */
.word 0 /* IRQ0 */


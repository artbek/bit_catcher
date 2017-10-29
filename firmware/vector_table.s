.word 0x20001000
.word _start + 1 /* Reset */ // 0x0000_0004
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
.word _systick_handler + 1 /* SysTick */ // 0x0000_003C

.word 0 /* IRQ 0 */
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0 /* IRQ 10 */
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0 /* IRQ 19 */
.word _interrupt_handlers__TIM21 + 1 /* TIM21 */
.word 0
.word 0 /* TIM22 */
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0 /* TIM29 */


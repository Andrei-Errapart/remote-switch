.syntax unified
.cpu cortex-m3
.thumb

.section .isr_vector, "a"
.align 2
.globl __isr_vector
__isr_vector:
    .long   _stack_top          /* Initial Stack Pointer */
    .long   Reset_Handler       /* Reset Handler */
    .long   NMI_Handler         /* NMI Handler */
    .long   HardFault_Handler   /* Hard Fault Handler */
    .long   MemManage_Handler   /* MPU Fault Handler */
    .long   BusFault_Handler    /* Bus Fault Handler */
    .long   UsageFault_Handler  /* Usage Fault Handler */
    .long   0                   /* Reserved */
    .long   0                   /* Reserved */
    .long   0                   /* Reserved */
    .long   0                   /* Reserved */
    .long   SVC_Handler         /* SVCall Handler */
    .long   DebugMon_Handler    /* Debug Monitor Handler */
    .long   0                   /* Reserved */
    .long   PendSV_Handler      /* PendSV Handler */
    .long   SysTick_Handler     /* SysTick Handler */
    
    /* External Interrupts - EFM32TG specific */
    .rept 16
    .long   Default_Handler
    .endr

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function
.global _start
_start:
Reset_Handler:
    /* Initialize data section */
    ldr r0, =_sdata
    ldr r1, =_edata
    ldr r2, =_sidata
    movs r3, #0
    b LoopCopyDataInit

CopyDataInit:
    ldr r4, [r2, r3]
    str r4, [r0, r3]
    adds r3, r3, #4

LoopCopyDataInit:
    adds r4, r0, r3
    cmp r4, r1
    bcc CopyDataInit

    /* Zero fill BSS section */
    ldr r0, =_sbss
    ldr r1, =_ebss
    movs r2, #0
    b LoopFillZerobss

FillZerobss:
    str r2, [r0]
    adds r0, r0, #4

LoopFillZerobss:
    cmp r0, r1
    bcc FillZerobss

    /* Call main */
    bl main
    
    /* Infinite loop if main returns */
    b .

.size Reset_Handler, .-Reset_Handler

/* Default interrupt handlers */
.section .text.Default_Handler, "ax", %progbits
Default_Handler:
    b .

.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler, Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler, Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler, Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler

.weak DebugMon_Handler
.thumb_set DebugMon_Handler, Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler
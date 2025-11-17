/* EFM32TG210F16 Memory Layout */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 16K
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 4K
}

/* Stack size */
_stack_size = 0x400; /* 1KB stack */

ENTRY(Reset_Handler)

SECTIONS
{
    /* Interrupt vectors */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* Code and read-only data */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    /* Data section - initialized data */
    .data : 
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT> FLASH

    /* Load address of data section */
    _sidata = LOADADDR(.data);

    /* BSS section - uninitialized data */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM

    /* Stack section */
    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _stack_bottom = .;
        . = . + _stack_size;
        _stack_top = .;
    } > RAM

    /* Check for overflow */
    ASSERT(_stack_top <= ORIGIN(RAM) + LENGTH(RAM), "RAM overflow!")
}
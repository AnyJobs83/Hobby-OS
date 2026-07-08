ENTRY(_start)

SECTIONS {
    . = 0x10000;

    .setup : {
        kernel_setup_asm.o(.setup)
    }
    
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }

    . = ALIGN(16);
    _kernel_stack = .;
    . += 0x4000;
    _kernel_stack_top = .;
}


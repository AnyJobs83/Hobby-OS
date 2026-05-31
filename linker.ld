ENTRY(_start)

SECTIONS {
    . = 0x7E00;

    .setup : {
        kernel_setup.o(.setup)
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


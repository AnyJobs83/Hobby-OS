ENTRY(_start)

kernel_stack_top = 0x7000;
kernel_start = 0x40000;
VGA_START = 0xB8000;

SECTIONS {
    . = kernel_start;
    
    . = ALIGN(0x1000);
    .text : { *(.text) }
    
    . = ALIGN(0x1000);
    .rodata : { *(.rodata) }
    
    . = ALIGN(0x1000);
    .data : { *(.data) }
    
    . = ALIGN(0x1000);
    .bss : { *(.bss) }
}


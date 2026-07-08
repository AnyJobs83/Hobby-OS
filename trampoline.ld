ENTRY(_start)

e820_buffer = 0x1000;    /* Doesnt get used, have to hard code in asm file */
kmain = 0x40000;
kernel_stack_top = 0x7000;
temp_kstack = 0x7C00;
tramp_start = 0x8000;

SECTIONS {
    . = tramp_start;
    
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}


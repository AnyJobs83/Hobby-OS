#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "helpers/vga_printer.h"


#define not_present             0b00000000
#define present                 0b00000001
#define read_only               0b00000000
#define read_and_write          0b00000010
#define kernel_page             0b00000000
#define user_page               0b00000100
#define write_back_caching      0b00000000  // Default - doesn't write to ram straight away
#define write_through_caching   0b00001000
#define enable_caching          0b00000000  // Defualt
#define disable_caching         0b00010000

typedef uint32_t PDE_t;
typedef uint32_t PTE_t;

PDE_t page_directory [1024];
PTE_t page_table [1024];

void init_page(PDE_t PDE, int table_index) {

}




extern void _get_memory_map(struct E820_entry E820_array[]);

struct E820_entry {
    uint64_t base_address;
    uint64_t length;
    uint32_t type;
    uint32_t attributes;
}__attribute__((packed));

struct E820_entry E820_buffer[128];

uint32_t frame_bitmap[32768];

void init_frame_bitmap() {

}

/*
    TODO
    Fix up all addresses, create a second stage bootloader

    Frame manager
        - Ask the bro BIOS what ram is taken
        - Make bitmap of taken pages (128 KiB)
        - Allocate frame
            - Return the physical address
            - store as uint32_t and AND it to find if those byte have a free page
            - store the address of the last free page
        - Free frame
        - Mark frame as taken (kernel only)
            - only do this when loading the kernel and with MMIO

    Virtual memory manager
        - Handle creating and edit page tables / directories
        
        - page fault handler
            - handle loading stuff from memory
            - killing illegeals
            - stack growing w/ guard page

    need to fix up linker.ld
        put the bios_memory_mappings into its own section (in real mode memory)
        put kernel_trampoline in its own section
        put the rest of the kernel at the 3.5 MiB mark
        map the vga text buffer in the kernel space
        chuck the kernel stack top right at 4 MiB
        chuck the kernel heap at the top of the kernel
        need a kernel top and kernel bottom for getting the size

    identity map the lower kernel
    map the higher half kernel image + heap + stack
    jump to higher half kernel

    kmalloc + heap manager
        - Dynamically request frames and pages

    Userspace things:
        malloc, calloc, realloc
            - mmap, mumap, brk, sbrk

        create new processes
            - fork / execute
            - create new page table
            - change cr3
*/

#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "../helpers/vga_printer.h"

struct e820_entry {
    uint32_t base_addr_low;
    uint32_t base_addr_high;
    uint32_t length_low;
    uint32_t length_high;
    uint32_t type;
    uint32_t attributes;
}__attribute__((packed));

extern struct e820_entry e820_buffer[];
extern uint32_t frame_bitmap[];

void init_frame_bitmap() {
    int count = 0;
    for (int i = 0; i < 128; i++) {
        struct e820_entry current_entry = e820_buffer[i];
        if (current_entry.length_low == 0 && current_entry.length_high == 0) continue;

        count++;

        printf("Base address: %08x , %08x \n", current_entry.base_addr_high, current_entry.base_addr_low);
        printf("Length: %08x %08x B \n", current_entry.length_high, current_entry.length_low);

        if (current_entry.type == 1) {
            printf("Type: useable \n");
        } else if (current_entry.type == 2) {
            printf("Type: not useable \n");
        } else {
            printf("Type: smth else \n");
        }

    }
    
    printf("Count: %u \n", count);
}

/*

Functions to implement

    - Init frame bitmap
        - Read e820 and mark those frames as free
        - Map all frames taken by the kernel
            - kernel stack
            - kernel image
            - page bitmap
            - important page bitmap

    - Get frame
        - Find frame
        - Mark allocated
        - Return address
    - Free frame

*/
// #include <stdint.h>
// #include <stdbool.h>
// #include <stdarg.h>
// #include "vga_printer.h"

// extern void _idt_stub_default(void);
// extern void _lidt(uint32_t);
// extern void _sti(void);
// extern void _remap_pic(void);
// extern uint32_t _isr_table[256];

// #define IDT_ENTRIES 256
// #define IDT_INTERUPT_GATE   0b00001110
// #define IDT_TRAP_GATE       0b00001111
// #define IDT_DPL_RING_0      0b00000000
// #define IDT_DPL_RING_3      0b01100000
// #define IDT_PRESENT         0b10000000
// #define IDT_NOT_PRESENT     0x00000000

// struct IDT_handler_registers {
//     uint32_t int_vector;
//     uint32_t GS;
//     uint32_t FS;
//     uint32_t ES;
//     uint32_t DS;
//     uint32_t EDI;
//     uint32_t ESI;
//     uint32_t EBP;
//     uint32_t ESP;
//     uint32_t EBX;
//     uint32_t EDX;
//     uint32_t ECX;
//     uint32_t EAX;
//     uint32_t EIP;
//     uint32_t CS;
//     uint32_t E_flags;
// }__attribute__((packed));

// struct IDTEntry {
//    uint16_t offset_1;           // offset bits 0..15
//    uint16_t selector;           // a code segment selector in GDT or LDT
//    uint8_t  reserved;           // unused, set to 0
//    uint8_t  type_attributes;    // gate type, dpl, and p fields
//    uint16_t offset_2;           // offset bits 16..31
// }__attribute__((packed));

// struct IDTR {
//     uint16_t limit;             // one less than the size of the idt (in bytes)
//     uint32_t offset;            // the address of the idt, need to be changed once paging is setup
// }__attribute__((packed));

// struct IDTEntry IDT[IDT_ENTRIES];       // The idt table
// struct IDTR idtr;                       // The descriptor struct of the idt

// void set_idt_entry(struct IDTEntry *e,
//                     uint32_t offset,
//                     uint16_t gdt_selector,
//                     uint8_t present_bit,
//                     uint8_t dpl,
//                     uint8_t gate_type) {
//     e -> offset_1 = offset & 0xFFFF;
//     e -> selector = gdt_selector;
//     e -> reserved = 0;
//     e -> type_attributes = present_bit | dpl | gate_type;
//     e -> offset_2 = offset >> 16;
// }

// void init_idt() {
//     // Init idt entries to the default handler
//     for (int i = 0; i < IDT_ENTRIES; i++) {
//         set_idt_entry(&IDT[i], _isr_table[i], 0x0008, IDT_PRESENT, IDT_DPL_RING_0, IDT_INTERUPT_GATE);
//     }
// }

// void isr_handler(struct IDT_handler_registers stack) {
//     printf("hello interrupt #%u", stack.int_vector);
// }

// void patch_idt() {
//     // Patch all of the interupt requests with the handlers that I've made

//     // CPU exceptions
//     // Divide by 0
//     // General Protection fault
//     // Double fault
//     // Page error

//     // IRQs
//     // Timer
//     // Keyboard
// }

// void patch_idtr(struct IDTR *idtr) {
//     idtr -> limit = (uint16_t)(sizeof(IDT) - 1);
//     idtr -> offset = (uint32_t)IDT;
// }

// void setup_interrupts() {
//     // Remap PIC
//     _remap_pic();

//     // Initialise the idt
//     init_idt();

//     // Patch all interupts that I have created handlers for, all others point to a generic
//     patch_idt();

//     // Patch idtr
//     patch_idtr(&idtr);

//     // call lidt
//     _lidt((uint32_t)&idtr);

//     // Enable interupts
//     _sti();
// }
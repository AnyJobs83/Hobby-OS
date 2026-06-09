GLOBAL _idt_default_stub
GLOBAL _lidt
GLOBAL _sti
GLOBAL _remap_pic

_idt_default_stub:
    mov dword [0xB8000], 0x0F41
    iret

_lidt:
    mov eax, [esp + 4]
    lidt [eax]
    ret

_sti:
    sti
    ret

_remap_pic:
    ; save masks
    in al, 0x21
    mov bh, al
    in al, 0xA1
    mov bl, al

    ; ICW1
    ; Tell the pic in the command ports that it is about to get bitched around by ME
    mov al, 0b00010001
    out 0x20, al
    out 0xA0, al

    ; ICW2
    ; Give the PICs, through their data ports, the new addresses of their vectors
    mov al, 0x20        ; master vector
    out 0x21, al
    mov al, 0x28        ; slave vector
    out 0xA1, al

    ; ICW3
    ; Give the master a bitmask of it's ports to tell it port 2 has a slave
    ; Also tell the slave that its master is the 2nd port
    mov al, 0b00000100
    out 0x21, al
    mov al, 0x02
    out 0xA1, al

    ; ICW4
    ; Tell the PICs that they are in 8086 mode, and some other things
    mov al, 0x00000001
    out 0x21, al
    out 0xA1, al

    ; Set the masks to what they were before
    mov al, bh
    out 0x21, al
    mov al, bl
    out 0xA1, al

    ret
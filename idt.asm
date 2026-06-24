section .text

GLOBAL _lidt
GLOBAL _sti
GLOBAL _remap_pic
GLOBAL _read_scancode
GLOBAL _read_ps2_status
GLOBAL _send_eoi_to_master
GLOBAL _send_eoi_to_slave
GLOBAL _isr_table

EXTERN isr_handler

_lidt:
    mov eax, [esp + 4]
    lidt [eax]
    ret

_sti:
    sti
    ret

_read_scancode:
    xor eax, eax
    in al, 0x60
    ret

_read_ps2_status:
    xor eax, eax
    in al, 0x64
    ret

_send_eoi_to_master:
    mov al, 0x20
    out 0x20, al

_send_eoi_to_slave:
    mov al, 0x20
    out 0xA0, al

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

%macro create_stub_and_dummy_error_code 1
_idt_stub_%1:
    push dword 0     ; Dummy error code
    pusha
    push ds
    push es
    push fs
    push gs
    push dword %1         ; Vector number

    call isr_handler

    add esp, 4      ; Pop the interrupt vector
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 4      ; Pop the error code
    iret
%endmacro

%macro create_stub_without_dummy_error_code 1
_idt_stub_%1:
    pusha
    push ds
    push es
    push fs
    push gs
    push dword %1       ; Vector number

    call isr_handler

    add esp, 4          ; Pop the interrupt vector
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
%endmacro

; Naming stuff is hard
create_stub_and_dummy_error_code 0
create_stub_and_dummy_error_code 1
create_stub_and_dummy_error_code 2
create_stub_and_dummy_error_code 3
create_stub_and_dummy_error_code 4
create_stub_and_dummy_error_code 5
create_stub_and_dummy_error_code 6
create_stub_and_dummy_error_code 7
create_stub_without_dummy_error_code 8
create_stub_and_dummy_error_code 9
create_stub_without_dummy_error_code 10
create_stub_without_dummy_error_code 11
create_stub_without_dummy_error_code 12
create_stub_without_dummy_error_code 13
create_stub_without_dummy_error_code 14
create_stub_and_dummy_error_code 15
create_stub_and_dummy_error_code 16
create_stub_without_dummy_error_code 17
create_stub_and_dummy_error_code 18
create_stub_and_dummy_error_code 19
create_stub_and_dummy_error_code 20
create_stub_and_dummy_error_code 21
create_stub_and_dummy_error_code 22
create_stub_and_dummy_error_code 23
create_stub_and_dummy_error_code 24
create_stub_and_dummy_error_code 25
create_stub_and_dummy_error_code 26
create_stub_and_dummy_error_code 27
create_stub_and_dummy_error_code 28
create_stub_and_dummy_error_code 29
create_stub_and_dummy_error_code 30
create_stub_and_dummy_error_code 31
create_stub_and_dummy_error_code 32
create_stub_and_dummy_error_code 33
create_stub_and_dummy_error_code 34
create_stub_and_dummy_error_code 35
create_stub_and_dummy_error_code 36
create_stub_and_dummy_error_code 37
create_stub_and_dummy_error_code 38
create_stub_and_dummy_error_code 39
create_stub_and_dummy_error_code 40
create_stub_and_dummy_error_code 41
create_stub_and_dummy_error_code 42
create_stub_and_dummy_error_code 43
create_stub_and_dummy_error_code 44
create_stub_and_dummy_error_code 45
create_stub_and_dummy_error_code 46
create_stub_and_dummy_error_code 47
create_stub_and_dummy_error_code 48
create_stub_and_dummy_error_code 49
create_stub_and_dummy_error_code 50
create_stub_and_dummy_error_code 51
create_stub_and_dummy_error_code 52
create_stub_and_dummy_error_code 53
create_stub_and_dummy_error_code 54
create_stub_and_dummy_error_code 55
create_stub_and_dummy_error_code 56
create_stub_and_dummy_error_code 57
create_stub_and_dummy_error_code 58
create_stub_and_dummy_error_code 59
create_stub_and_dummy_error_code 60
create_stub_and_dummy_error_code 61
create_stub_and_dummy_error_code 62
create_stub_and_dummy_error_code 63
create_stub_and_dummy_error_code 64
create_stub_and_dummy_error_code 65
create_stub_and_dummy_error_code 66
create_stub_and_dummy_error_code 67
create_stub_and_dummy_error_code 68
create_stub_and_dummy_error_code 69
create_stub_and_dummy_error_code 70
create_stub_and_dummy_error_code 71
create_stub_and_dummy_error_code 72
create_stub_and_dummy_error_code 73
create_stub_and_dummy_error_code 74
create_stub_and_dummy_error_code 75
create_stub_and_dummy_error_code 76
create_stub_and_dummy_error_code 77
create_stub_and_dummy_error_code 78
create_stub_and_dummy_error_code 79
create_stub_and_dummy_error_code 80
create_stub_and_dummy_error_code 81
create_stub_and_dummy_error_code 82
create_stub_and_dummy_error_code 83
create_stub_and_dummy_error_code 84
create_stub_and_dummy_error_code 85
create_stub_and_dummy_error_code 86
create_stub_and_dummy_error_code 87
create_stub_and_dummy_error_code 88
create_stub_and_dummy_error_code 89
create_stub_and_dummy_error_code 90
create_stub_and_dummy_error_code 91
create_stub_and_dummy_error_code 92
create_stub_and_dummy_error_code 93
create_stub_and_dummy_error_code 94
create_stub_and_dummy_error_code 95
create_stub_and_dummy_error_code 96
create_stub_and_dummy_error_code 97
create_stub_and_dummy_error_code 98
create_stub_and_dummy_error_code 99
create_stub_and_dummy_error_code 100
create_stub_and_dummy_error_code 101
create_stub_and_dummy_error_code 102
create_stub_and_dummy_error_code 103
create_stub_and_dummy_error_code 104
create_stub_and_dummy_error_code 105
create_stub_and_dummy_error_code 106
create_stub_and_dummy_error_code 107
create_stub_and_dummy_error_code 108
create_stub_and_dummy_error_code 109
create_stub_and_dummy_error_code 110
create_stub_and_dummy_error_code 111
create_stub_and_dummy_error_code 112
create_stub_and_dummy_error_code 113
create_stub_and_dummy_error_code 114
create_stub_and_dummy_error_code 115
create_stub_and_dummy_error_code 116
create_stub_and_dummy_error_code 117
create_stub_and_dummy_error_code 118
create_stub_and_dummy_error_code 119
create_stub_and_dummy_error_code 120
create_stub_and_dummy_error_code 121
create_stub_and_dummy_error_code 122
create_stub_and_dummy_error_code 123
create_stub_and_dummy_error_code 124
create_stub_and_dummy_error_code 125
create_stub_and_dummy_error_code 126
create_stub_and_dummy_error_code 127
create_stub_and_dummy_error_code 128
create_stub_and_dummy_error_code 129
create_stub_and_dummy_error_code 130
create_stub_and_dummy_error_code 131
create_stub_and_dummy_error_code 132
create_stub_and_dummy_error_code 133
create_stub_and_dummy_error_code 134
create_stub_and_dummy_error_code 135
create_stub_and_dummy_error_code 136
create_stub_and_dummy_error_code 137
create_stub_and_dummy_error_code 138
create_stub_and_dummy_error_code 139
create_stub_and_dummy_error_code 140
create_stub_and_dummy_error_code 141
create_stub_and_dummy_error_code 142
create_stub_and_dummy_error_code 143
create_stub_and_dummy_error_code 144
create_stub_and_dummy_error_code 145
create_stub_and_dummy_error_code 146
create_stub_and_dummy_error_code 147
create_stub_and_dummy_error_code 148
create_stub_and_dummy_error_code 149
create_stub_and_dummy_error_code 150
create_stub_and_dummy_error_code 151
create_stub_and_dummy_error_code 152
create_stub_and_dummy_error_code 153
create_stub_and_dummy_error_code 154
create_stub_and_dummy_error_code 155
create_stub_and_dummy_error_code 156
create_stub_and_dummy_error_code 157
create_stub_and_dummy_error_code 158
create_stub_and_dummy_error_code 159
create_stub_and_dummy_error_code 160
create_stub_and_dummy_error_code 161
create_stub_and_dummy_error_code 162
create_stub_and_dummy_error_code 163
create_stub_and_dummy_error_code 164
create_stub_and_dummy_error_code 165
create_stub_and_dummy_error_code 166
create_stub_and_dummy_error_code 167
create_stub_and_dummy_error_code 168
create_stub_and_dummy_error_code 169
create_stub_and_dummy_error_code 170
create_stub_and_dummy_error_code 171
create_stub_and_dummy_error_code 172
create_stub_and_dummy_error_code 173
create_stub_and_dummy_error_code 174
create_stub_and_dummy_error_code 175
create_stub_and_dummy_error_code 176
create_stub_and_dummy_error_code 177
create_stub_and_dummy_error_code 178
create_stub_and_dummy_error_code 179
create_stub_and_dummy_error_code 180
create_stub_and_dummy_error_code 181
create_stub_and_dummy_error_code 182
create_stub_and_dummy_error_code 183
create_stub_and_dummy_error_code 184
create_stub_and_dummy_error_code 185
create_stub_and_dummy_error_code 186
create_stub_and_dummy_error_code 187
create_stub_and_dummy_error_code 188
create_stub_and_dummy_error_code 189
create_stub_and_dummy_error_code 190
create_stub_and_dummy_error_code 191
create_stub_and_dummy_error_code 192
create_stub_and_dummy_error_code 193
create_stub_and_dummy_error_code 194
create_stub_and_dummy_error_code 195
create_stub_and_dummy_error_code 196
create_stub_and_dummy_error_code 197
create_stub_and_dummy_error_code 198
create_stub_and_dummy_error_code 199
create_stub_and_dummy_error_code 200
create_stub_and_dummy_error_code 201
create_stub_and_dummy_error_code 202
create_stub_and_dummy_error_code 203
create_stub_and_dummy_error_code 204
create_stub_and_dummy_error_code 205
create_stub_and_dummy_error_code 206
create_stub_and_dummy_error_code 207
create_stub_and_dummy_error_code 208
create_stub_and_dummy_error_code 209
create_stub_and_dummy_error_code 210
create_stub_and_dummy_error_code 211
create_stub_and_dummy_error_code 212
create_stub_and_dummy_error_code 213
create_stub_and_dummy_error_code 214
create_stub_and_dummy_error_code 215
create_stub_and_dummy_error_code 216
create_stub_and_dummy_error_code 217
create_stub_and_dummy_error_code 218
create_stub_and_dummy_error_code 219
create_stub_and_dummy_error_code 220
create_stub_and_dummy_error_code 221
create_stub_and_dummy_error_code 222
create_stub_and_dummy_error_code 223
create_stub_and_dummy_error_code 224
create_stub_and_dummy_error_code 225
create_stub_and_dummy_error_code 226
create_stub_and_dummy_error_code 227
create_stub_and_dummy_error_code 228
create_stub_and_dummy_error_code 229
create_stub_and_dummy_error_code 230
create_stub_and_dummy_error_code 231
create_stub_and_dummy_error_code 232
create_stub_and_dummy_error_code 233
create_stub_and_dummy_error_code 234
create_stub_and_dummy_error_code 235
create_stub_and_dummy_error_code 236
create_stub_and_dummy_error_code 237
create_stub_and_dummy_error_code 238
create_stub_and_dummy_error_code 239
create_stub_and_dummy_error_code 240
create_stub_and_dummy_error_code 241
create_stub_and_dummy_error_code 242
create_stub_and_dummy_error_code 243
create_stub_and_dummy_error_code 244
create_stub_and_dummy_error_code 245
create_stub_and_dummy_error_code 246
create_stub_and_dummy_error_code 247
create_stub_and_dummy_error_code 248
create_stub_and_dummy_error_code 249
create_stub_and_dummy_error_code 250
create_stub_and_dummy_error_code 251
create_stub_and_dummy_error_code 252
create_stub_and_dummy_error_code 253
create_stub_and_dummy_error_code 254
create_stub_and_dummy_error_code 255

section .data

_isr_table:
    dd _idt_stub_0
    dd _idt_stub_1
    dd _idt_stub_2
    dd _idt_stub_3
    dd _idt_stub_4
    dd _idt_stub_5
    dd _idt_stub_6
    dd _idt_stub_7
    dd _idt_stub_8
    dd _idt_stub_9
    dd _idt_stub_10
    dd _idt_stub_11
    dd _idt_stub_12
    dd _idt_stub_13
    dd _idt_stub_14
    dd _idt_stub_15
    dd _idt_stub_16
    dd _idt_stub_17
    dd _idt_stub_18
    dd _idt_stub_19
    dd _idt_stub_20
    dd _idt_stub_21
    dd _idt_stub_22
    dd _idt_stub_23
    dd _idt_stub_24
    dd _idt_stub_25
    dd _idt_stub_26
    dd _idt_stub_27
    dd _idt_stub_28
    dd _idt_stub_29
    dd _idt_stub_30
    dd _idt_stub_31
    dd _idt_stub_32
    dd _idt_stub_33
    dd _idt_stub_34
    dd _idt_stub_35
    dd _idt_stub_36
    dd _idt_stub_37
    dd _idt_stub_38
    dd _idt_stub_39
    dd _idt_stub_40
    dd _idt_stub_41
    dd _idt_stub_42
    dd _idt_stub_43
    dd _idt_stub_44
    dd _idt_stub_45
    dd _idt_stub_46
    dd _idt_stub_47
    dd _idt_stub_48
    dd _idt_stub_49
    dd _idt_stub_50
    dd _idt_stub_51
    dd _idt_stub_52
    dd _idt_stub_53
    dd _idt_stub_54
    dd _idt_stub_55
    dd _idt_stub_56
    dd _idt_stub_57
    dd _idt_stub_58
    dd _idt_stub_59
    dd _idt_stub_60
    dd _idt_stub_61
    dd _idt_stub_62
    dd _idt_stub_63
    dd _idt_stub_64
    dd _idt_stub_65
    dd _idt_stub_66
    dd _idt_stub_67
    dd _idt_stub_68
    dd _idt_stub_69
    dd _idt_stub_70
    dd _idt_stub_71
    dd _idt_stub_72
    dd _idt_stub_73
    dd _idt_stub_74
    dd _idt_stub_75
    dd _idt_stub_76
    dd _idt_stub_77
    dd _idt_stub_78
    dd _idt_stub_79
    dd _idt_stub_80
    dd _idt_stub_81
    dd _idt_stub_82
    dd _idt_stub_83
    dd _idt_stub_84
    dd _idt_stub_85
    dd _idt_stub_86
    dd _idt_stub_87
    dd _idt_stub_88
    dd _idt_stub_89
    dd _idt_stub_90
    dd _idt_stub_91
    dd _idt_stub_92
    dd _idt_stub_93
    dd _idt_stub_94
    dd _idt_stub_95
    dd _idt_stub_96
    dd _idt_stub_97
    dd _idt_stub_98
    dd _idt_stub_99
    dd _idt_stub_100
    dd _idt_stub_101
    dd _idt_stub_102
    dd _idt_stub_103
    dd _idt_stub_104
    dd _idt_stub_105
    dd _idt_stub_106
    dd _idt_stub_107
    dd _idt_stub_108
    dd _idt_stub_109
    dd _idt_stub_110
    dd _idt_stub_111
    dd _idt_stub_112
    dd _idt_stub_113
    dd _idt_stub_114
    dd _idt_stub_115
    dd _idt_stub_116
    dd _idt_stub_117
    dd _idt_stub_118
    dd _idt_stub_119
    dd _idt_stub_120
    dd _idt_stub_121
    dd _idt_stub_122
    dd _idt_stub_123
    dd _idt_stub_124
    dd _idt_stub_125
    dd _idt_stub_126
    dd _idt_stub_127
    dd _idt_stub_128
    dd _idt_stub_129
    dd _idt_stub_130
    dd _idt_stub_131
    dd _idt_stub_132
    dd _idt_stub_133
    dd _idt_stub_134
    dd _idt_stub_135
    dd _idt_stub_136
    dd _idt_stub_137
    dd _idt_stub_138
    dd _idt_stub_139
    dd _idt_stub_140
    dd _idt_stub_141
    dd _idt_stub_142
    dd _idt_stub_143
    dd _idt_stub_144
    dd _idt_stub_145
    dd _idt_stub_146
    dd _idt_stub_147
    dd _idt_stub_148
    dd _idt_stub_149
    dd _idt_stub_150
    dd _idt_stub_151
    dd _idt_stub_152
    dd _idt_stub_153
    dd _idt_stub_154
    dd _idt_stub_155
    dd _idt_stub_156
    dd _idt_stub_157
    dd _idt_stub_158
    dd _idt_stub_159
    dd _idt_stub_160
    dd _idt_stub_161
    dd _idt_stub_162
    dd _idt_stub_163
    dd _idt_stub_164
    dd _idt_stub_165
    dd _idt_stub_166
    dd _idt_stub_167
    dd _idt_stub_168
    dd _idt_stub_169
    dd _idt_stub_170
    dd _idt_stub_171
    dd _idt_stub_172
    dd _idt_stub_173
    dd _idt_stub_174
    dd _idt_stub_175
    dd _idt_stub_176
    dd _idt_stub_177
    dd _idt_stub_178
    dd _idt_stub_179
    dd _idt_stub_180
    dd _idt_stub_181
    dd _idt_stub_182
    dd _idt_stub_183
    dd _idt_stub_184
    dd _idt_stub_185
    dd _idt_stub_186
    dd _idt_stub_187
    dd _idt_stub_188
    dd _idt_stub_189
    dd _idt_stub_190
    dd _idt_stub_191
    dd _idt_stub_192
    dd _idt_stub_193
    dd _idt_stub_194
    dd _idt_stub_195
    dd _idt_stub_196
    dd _idt_stub_197
    dd _idt_stub_198
    dd _idt_stub_199
    dd _idt_stub_200
    dd _idt_stub_201
    dd _idt_stub_202
    dd _idt_stub_203
    dd _idt_stub_204
    dd _idt_stub_205
    dd _idt_stub_206
    dd _idt_stub_207
    dd _idt_stub_208
    dd _idt_stub_209
    dd _idt_stub_210
    dd _idt_stub_211
    dd _idt_stub_212
    dd _idt_stub_213
    dd _idt_stub_214
    dd _idt_stub_215
    dd _idt_stub_216
    dd _idt_stub_217
    dd _idt_stub_218
    dd _idt_stub_219
    dd _idt_stub_220
    dd _idt_stub_221
    dd _idt_stub_222
    dd _idt_stub_223
    dd _idt_stub_224
    dd _idt_stub_225
    dd _idt_stub_226
    dd _idt_stub_227
    dd _idt_stub_228
    dd _idt_stub_229
    dd _idt_stub_230
    dd _idt_stub_231
    dd _idt_stub_232
    dd _idt_stub_233
    dd _idt_stub_234
    dd _idt_stub_235
    dd _idt_stub_236
    dd _idt_stub_237
    dd _idt_stub_238
    dd _idt_stub_239
    dd _idt_stub_240
    dd _idt_stub_241
    dd _idt_stub_242
    dd _idt_stub_243
    dd _idt_stub_244
    dd _idt_stub_245
    dd _idt_stub_246
    dd _idt_stub_247
    dd _idt_stub_248
    dd _idt_stub_249
    dd _idt_stub_250
    dd _idt_stub_251
    dd _idt_stub_252
    dd _idt_stub_253
    dd _idt_stub_254
    dd _idt_stub_255
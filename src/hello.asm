ORG 0x00    ;No need, bcoz we are explictly initializing the segment registers
BITS 16

_start:     ;For BIOS Paremeter Block, so that real device can boot
    jmp short cs_start  ;Short to jump in same module
    nop

times 33 db 0   ;For BPB

cs_start:
    jmp 0x7c0:start ;Manually change the code segment address

interrupt_zero:
    mov ah, 0eh 
    mov al, 'A' 
    int 10h
    iret

start:
    cli     ;Clear Interrupts
    mov ax, 0x7c0
    mov ds, ax  ;It is good to initialize the segment register ourselves
    mov es, ax  ;because some bios will set segment register differntly if we don't initialize them
    mov ax, 0x00   
    mov ss, ax 
    mov sp, 0x7c00
    sti     ;Set Interrupts
    

    mov si, message
    ; call print
    mov word[ss:0x00], interrupt_zero
    mov word[ss:0x02], 0x7c0

    mov ax, 0x00
    div ax

    jmp $

print:
    lodsb   ;Copy byte to AL using SI register and increment/decrement
            ;SI based on the DF flag
    cmp al, 0
    je .done
    call print_char
    jmp print    

.done:
    ret

print_char:
    mov ah, 0eh
    int 10h
    ret

message: 
    db 'Hello Rahul', 0

times 510-($-$$) db 0

dw 0xaa55
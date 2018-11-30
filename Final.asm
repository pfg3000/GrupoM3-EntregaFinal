include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    MAXTEXTSIZE equ 50
    __flags dw ? 
    __descar dd ? 
    oldcw dw ? 
    __auxConc db MAXTEXTSIZE dup (?), '$'
    __resultConc db MAXTEXTSIZE dup (?), '$'
    msgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'
    _newLine db 0Dh, 0Ah,'$'
vtext db 100 dup('$')
 
;Declaracion de variables de usuario
    @d  dd  ?
    @_12p1  dd  12.100
    @auxR0  DD 0.0
    @auxR1  DD 0.0
    @auxR2  DD 0.0
    @auxR3  DD 0.0
    @auxR4  DD 0.0
    @auxR5  DD 0.0
    @auxR6  DD 0.0
    @auxR7  DD 0.0
    @auxR8  DD 0.0
    @auxR9  DD 0.0
    @auxR10     DD 0.0
    @auxR11     DD 0.0
    @auxR12     DD 0.0
    @auxR13     DD 0.0
    @auxR14     DD 0.0
    @auxR15     DD 0.0
    @auxR16     DD 0.0
    @auxR17     DD 0.0
    @auxR18     DD 0.0
    @auxR19     DD 0.0
    @auxR20     DD 0.0
    @auxR21     DD 0.0
    @auxR22     DD 0.0
    @auxR23     DD 0.0
    @auxR24     DD 0.0
    @auxR25     DD 0.0
    @auxR26     DD 0.0
    @auxR27     DD 0.0
    @auxR28     DD 0.0
    @auxR29     DD 0.0
    @auxR30     DD 0.0
    @auxR31     DD 0.0
    @auxR32     DD 0.0
    @auxR33     DD 0.0
    @auxR34     DD 0.0
    @auxR35     DD 0.0
    @auxR36     DD 0.0
    @auxR37     DD 0.0
    @auxR38     DD 0.0
    @auxR39     DD 0.0
    @auxR40     DD 0.0
    @auxR41     DD 0.0
    @auxR42     DD 0.0
    @auxR43     DD 0.0
    @auxR44     DD 0.0
    @auxR45     DD 0.0
    @auxR46     DD 0.0
    @auxR47     DD 0.0
    @auxR48     DD 0.0
    @auxR49     DD 0.0
    @auxR50     DD 0.0
    @auxR51     DD 0.0
    @auxR52     DD 0.0
    @auxR53     DD 0.0
    @auxR54     DD 0.0
    @auxR55     DD 0.0
    @auxR56     DD 0.0
    @auxR57     DD 0.0
    @auxR58     DD 0.0
    @auxR59     DD 0.0
    @auxR60     DD 0.0
    @auxR61     DD 0.0
    @auxR62     DD 0.0
    @auxR63     DD 0.0
    @auxR64     DD 0.0
    @auxR65     DD 0.0
    @auxR66     DD 0.0
    @auxR67     DD 0.0
    @auxR68     DD 0.0
    @auxR69     DD 0.0
    @auxR70     DD 0.0
    @auxR71     DD 0.0
    @auxR72     DD 0.0
    @auxR73     DD 0.0
    @auxR74     DD 0.0
    @auxR75     DD 0.0
    @auxR76     DD 0.0
    @auxR77     DD 0.0
    @auxR78     DD 0.0
    @auxR79     DD 0.0
    @auxR80     DD 0.0
    @auxR81     DD 0.0
    @auxR82     DD 0.0
    @auxR83     DD 0.0
    @auxR84     DD 0.0
    @auxR85     DD 0.0
    @auxR86     DD 0.0
    @auxR87     DD 0.0
    @auxR88     DD 0.0
    @auxR89     DD 0.0
    @auxR90     DD 0.0
    @auxR91     DD 0.0
    @auxR92     DD 0.0
    @auxR93     DD 0.0
    @auxR94     DD 0.0
    @auxR95     DD 0.0
    @auxR96     DD 0.0
    @auxR97     DD 0.0
    @auxR98     DD 0.0
    @auxR99     DD 0.0

.CODE
START:

    MOV AX, @DATA

    MOV DS, AX

    MOV ES, AX


;Comienzo codigo de usuario

    fstp @d
    displayFloat @d, 2
    newline

;finaliza el asm
    mov ah,4ch
    mov al,0
    int 21h

STRLEN PROC NEAR
    mov BX,0

STRL01:
    cmp BYTE PTR [SI+BX],'$'
    je STREND
    inc BX
    jmp STRL01

STREND:
    ret

STRLEN ENDP

COPIAR PROC NEAR
    call STRLEN
    cmp BX,MAXTEXTSIZE
    jle COPIARSIZEOK
    mov BX,MAXTEXTSIZE

COPIARSIZEOK:
    mov CX,BX
    cld
    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al
    ret

COPIAR ENDP

CONCAT PROC NEAR
    push ds
    push si
    call STRLEN
    mov dx,bx
    mov si,di
    push es
    pop ds
    call STRLEN
    add di,bx
    add bx,dx
    cmp bx,MAXTEXTSIZE
    jg CONCATSIZEMAL

CONCATSIZEOK:
    mov cx,dx
    jmp CONCATSIGO

CONCATSIZEMAL:
    sub bx,MAXTEXTSIZE
    sub dx,bx
    mov cx,dx

CONCATSIGO:
    push ds
    pop es
    pop si
    pop ds
    cld
    rep movsb
    mov al,'$'
    mov BYTE PTR [DI],al
    ret

CONCAT ENDP
END START; final del archivo. 

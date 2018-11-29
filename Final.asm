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
	@a	dd	?
	@_auxR0 	DD 0.0
	@_auxE0 	DW 0
	@_auxR1 	DD 0.0
	@_auxE1 	DW 0
	@_auxR2 	DD 0.0
	@_auxE2 	DW 0
	@_auxR3 	DD 0.0
	@_auxE3 	DW 0
	@_auxR4 	DD 0.0
	@_auxE4 	DW 0
	@_auxR5 	DD 0.0
	@_auxE5 	DW 0
	@_auxR6 	DD 0.0
	@_auxE6 	DW 0
	@_auxR7 	DD 0.0
	@_auxE7 	DW 0
	@_auxR8 	DD 0.0
	@_auxE8 	DW 0
	@_auxR9 	DD 0.0
	@_auxE9 	DW 0
	@_auxR10 	DD 0.0
	@_auxE10 	DW 0
	@_auxR11 	DD 0.0
	@_auxE11 	DW 0
	@_auxR12 	DD 0.0
	@_auxE12 	DW 0
	@_auxR13 	DD 0.0
	@_auxE13 	DW 0
	@_auxR14 	DD 0.0
	@_auxE14 	DW 0
	@_auxR15 	DD 0.0
	@_auxE15 	DW 0
	@_auxR16 	DD 0.0
	@_auxE16 	DW 0
	@_auxR17 	DD 0.0
	@_auxE17 	DW 0
	@_auxR18 	DD 0.0
	@_auxE18 	DW 0
	@_auxR19 	DD 0.0
	@_auxE19 	DW 0
	@_auxR20 	DD 0.0
	@_auxE20 	DW 0
	@_auxR21 	DD 0.0
	@_auxE21 	DW 0
	@_auxR22 	DD 0.0
	@_auxE22 	DW 0
	@_auxR23 	DD 0.0
	@_auxE23 	DW 0
	@_auxR24 	DD 0.0
	@_auxE24 	DW 0
	@_auxR25 	DD 0.0
	@_auxE25 	DW 0
	@_auxR26 	DD 0.0
	@_auxE26 	DW 0
	@_auxR27 	DD 0.0
	@_auxE27 	DW 0
	@_auxR28 	DD 0.0
	@_auxE28 	DW 0
	@_auxR29 	DD 0.0
	@_auxE29 	DW 0
	@_auxR30 	DD 0.0
	@_auxE30 	DW 0
	@_auxR31 	DD 0.0
	@_auxE31 	DW 0
	@_auxR32 	DD 0.0
	@_auxE32 	DW 0
	@_auxR33 	DD 0.0
	@_auxE33 	DW 0
	@_auxR34 	DD 0.0
	@_auxE34 	DW 0
	@_auxR35 	DD 0.0
	@_auxE35 	DW 0
	@_auxR36 	DD 0.0
	@_auxE36 	DW 0
	@_auxR37 	DD 0.0
	@_auxE37 	DW 0
	@_auxR38 	DD 0.0
	@_auxE38 	DW 0
	@_auxR39 	DD 0.0
	@_auxE39 	DW 0
	@_auxR40 	DD 0.0
	@_auxE40 	DW 0
	@_auxR41 	DD 0.0
	@_auxE41 	DW 0
	@_auxR42 	DD 0.0
	@_auxE42 	DW 0
	@_auxR43 	DD 0.0
	@_auxE43 	DW 0
	@_auxR44 	DD 0.0
	@_auxE44 	DW 0
	@_auxR45 	DD 0.0
	@_auxE45 	DW 0
	@_auxR46 	DD 0.0
	@_auxE46 	DW 0
	@_auxR47 	DD 0.0
	@_auxE47 	DW 0
	@_auxR48 	DD 0.0
	@_auxE48 	DW 0
	@_auxR49 	DD 0.0
	@_auxE49 	DW 0
	@_auxR50 	DD 0.0
	@_auxE50 	DW 0
	@_auxR51 	DD 0.0
	@_auxE51 	DW 0
	@_auxR52 	DD 0.0
	@_auxE52 	DW 0
	@_auxR53 	DD 0.0
	@_auxE53 	DW 0
	@_auxR54 	DD 0.0
	@_auxE54 	DW 0
	@_auxR55 	DD 0.0
	@_auxE55 	DW 0
	@_auxR56 	DD 0.0
	@_auxE56 	DW 0
	@_auxR57 	DD 0.0
	@_auxE57 	DW 0
	@_auxR58 	DD 0.0
	@_auxE58 	DW 0
	@_auxR59 	DD 0.0
	@_auxE59 	DW 0
	@_auxR60 	DD 0.0
	@_auxE60 	DW 0
	@_auxR61 	DD 0.0
	@_auxE61 	DW 0
	@_auxR62 	DD 0.0
	@_auxE62 	DW 0
	@_auxR63 	DD 0.0
	@_auxE63 	DW 0
	@_auxR64 	DD 0.0
	@_auxE64 	DW 0
	@_auxR65 	DD 0.0
	@_auxE65 	DW 0
	@_auxR66 	DD 0.0
	@_auxE66 	DW 0
	@_auxR67 	DD 0.0
	@_auxE67 	DW 0
	@_auxR68 	DD 0.0
	@_auxE68 	DW 0
	@_auxR69 	DD 0.0
	@_auxE69 	DW 0
	@_auxR70 	DD 0.0
	@_auxE70 	DW 0
	@_auxR71 	DD 0.0
	@_auxE71 	DW 0
	@_auxR72 	DD 0.0
	@_auxE72 	DW 0
	@_auxR73 	DD 0.0
	@_auxE73 	DW 0
	@_auxR74 	DD 0.0
	@_auxE74 	DW 0
	@_auxR75 	DD 0.0
	@_auxE75 	DW 0
	@_auxR76 	DD 0.0
	@_auxE76 	DW 0
	@_auxR77 	DD 0.0
	@_auxE77 	DW 0
	@_auxR78 	DD 0.0
	@_auxE78 	DW 0
	@_auxR79 	DD 0.0
	@_auxE79 	DW 0
	@_auxR80 	DD 0.0
	@_auxE80 	DW 0
	@_auxR81 	DD 0.0
	@_auxE81 	DW 0
	@_auxR82 	DD 0.0
	@_auxE82 	DW 0
	@_auxR83 	DD 0.0
	@_auxE83 	DW 0
	@_auxR84 	DD 0.0
	@_auxE84 	DW 0
	@_auxR85 	DD 0.0
	@_auxE85 	DW 0
	@_auxR86 	DD 0.0
	@_auxE86 	DW 0
	@_auxR87 	DD 0.0
	@_auxE87 	DW 0
	@_auxR88 	DD 0.0
	@_auxE88 	DW 0
	@_auxR89 	DD 0.0
	@_auxE89 	DW 0
	@_auxR90 	DD 0.0
	@_auxE90 	DW 0
	@_auxR91 	DD 0.0
	@_auxE91 	DW 0
	@_auxR92 	DD 0.0
	@_auxE92 	DW 0
	@_auxR93 	DD 0.0
	@_auxE93 	DW 0
	@_auxR94 	DD 0.0
	@_auxE94 	DW 0
	@_auxR95 	DD 0.0
	@_auxE95 	DW 0
	@_auxR96 	DD 0.0
	@_auxE96 	DW 0
	@_auxR97 	DD 0.0
	@_auxE97 	DW 0
	@_auxR98 	DD 0.0
	@_auxE98 	DW 0
	@_auxR99 	DD 0.0
	@_auxE99 	DW 0

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX

	MOV ES, AX


;Comienzo codigo de usuario

	fld _0
	fstp @a
	fld _1
	fstp @b
	fld _12.1
	fstp @d

	LEA DX, ! 
	MOV AH, 9
	INT 21H
	newline
	MOV SI, OFFSET _hola
	MOV DI, OFFSET @pri
	call COPIAR
@@etiq1:
	fld _10
	fcomp @a
	fstsw AX
	sahf
	JNA @@etiq2
	fld _0
	fcomp @b
	fstsw AX
	sahf
	JNB @@etiq3
	displayFloat @a, 2
	newline
@@etiq3:
	fld _1
	fld @a
	fadd St(0),St(1)
	fstp @a
	jmp @@etiq1
@@etiq2:
	fld _0
	fstp @aux0
	fld _2
	fld @aux1
	fadd St(0),St(1)
	fld @a
	fstp @aux2
	fld @b
	fld @a
	fadd St(0),St(1)
	fld @aux3
	fadd St(0),St(1)
	fstp @aux4
	fld @b
	fld @a
	fadd St(0),St(1)
	fld @c
	fld @aux5
	fmul St(0),St(1)
	fadd St(0),St(1)
	fstp @aux6
	fld _48
	fld @aux7
	fadd St(0),St(1)
	fstp @aux8
	fld _5
	fld _25
	fdiv St(0),St(1)
	fld @aux9
	fadd St(0),St(1)
	fstp @aux10
	fld _5
	fld @aux11
	fdiv St(0),St(1)
	fstp @aux12
	fadd St(0),St(1)
	fstp @aux13
	fld _0
	fstp @aux14
	fld _1
	fld @aux15
	fadd St(0),St(1)
	fld @b
	fstp @aux16
	fld _2
	fld @aux17
	fadd St(0),St(1)
	fstp @aux18
	fld _3
	fld @aux19
	fadd St(0),St(1)
	fstp @aux20
	fld @aux21
	fdiv St(0),St(1)
	fstp @aux22
	fmul St(0),St(1)
	fstp @aux23
	fld @aux24
	fstp @0
	fld @b
	fld @a
	fadd St(0),St(1)
	fld @a
	fstsw AX
	sahf
	JNZ @@etiq4
	fld @aux25
	fstp @1
@@etiq4:
	fld @b
	fld @a
	fadd St(0),St(1)
	fld @a
	fld @a
	fmul St(0),St(1)
	fstsw AX
	sahf
	JNZ @@etiq5
	fld @aux26
	fstp @1
@@etiq5:
	fld _48
	fcomp @a
	fstsw AX
	sahf
	JNZ @@etiq6
	fld @aux27
	fstp @1
@@etiq6:
	fld _5
	fld _25
	fdiv St(0),St(1)
	fld @a
	fstsw AX
	sahf
	JNZ @@etiq7
	fld @aux28
	fstp @1
@@etiq7:
	fld _32.3
	fcomp @a
	fstsw AX
	sahf
	JNZ @@etiq8
	fld @aux29
	fstp @1
@@etiq8:
	fld _1
	fcomp @aux30
	fstsw AX
	sahf
	JNZ @@etiq9
	displayFloat @a, 2
	newline
@@etiq9:
@@etiq10:
	fld @aux31
	fstp @0
	fld _5
	fcomp @a
	fstsw AX
	sahf
	JNZ @@etiq11
	fld @aux32
	fstp @1
@@etiq11:
	fld @b
	fld @a
	fdiv St(0),St(1)
	fld @a
	fstsw AX
	sahf
	JNZ @@etiq12
	fld @aux33
	fstp @1
@@etiq12:
	fld _99
	fcomp @a
	fstsw AX
	sahf
	JNZ @@etiq13
	fld @aux34
	fstp @1
@@etiq13:
	fld _1
	fcomp @aux35
	fstsw AX
	sahf
	JNZ @@etiq14
	fld _2
	fcomp @a
	fstsw AX
	sahf
	JNB @@etiq15
	fld _99
	fstp @c
	jmp @@etiq16
@@etiq15:
	fld _77
	fstp @b
@@etiq16:
	jmp @@etiq10
@@etiq14:

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

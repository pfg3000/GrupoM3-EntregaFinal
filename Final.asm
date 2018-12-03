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
	@d	dd	?
	@b	dd	?
	@c	dd	?
	@pri	db	MAXTEXTSIZE dup (?),'$'
	@_se_declararon_variables	db	'Se declararon variables','$',26 dup (?)
	@_constantes_numericas	db	'Constantes numericas','$',29 dup (?)
	@_0p12	dd	0.120
	@_12p1	dd	12.100
	@_1	dd	1.000
	@_5	dd	5.000
	@_asignacion_con_expresion	db	'Asignacion con expresion','$',25 dup (?)
	@_constantes_string	db	'Constantes string','$',32 dup (?)
	@_hola	db	'Hola','$',45 dup (?)
	@_while_comun	db	'WHILE comun','$',38 dup (?)
	@_3	dd	3.000
	@___entre_al_while	db	'**entre al WHILE','$',33 dup (?)
	@_while_con_not	db	'WHILE con NOT','$',36 dup (?)
	@___entre_al_while_con_not	db	'**entre al WHILE con NOT','$',25 dup (?)
	@_if_comun__entra_	db	'IF comun (entra)','$',33 dup (?)
	@___ingresa_al_if	db	'**ingresa al IF','$',34 dup (?)
	@_if_comun__no_entra_	db	'IF comun (no entra)','$',30 dup (?)
	@_if_con_else__entra_if_	db	'IF con ELSE (entra if)','$',27 dup (?)
	@___ingresa_al_else	db	'**ingresa al ELSE','$',32 dup (?)
	@_if_con_else__entra_else_	db	'IF con ELSE (entra else)','$',25 dup (?)
	@_if_con_and	db	'IF con AND','$',39 dup (?)
	@_0	dd	0.000
	@_if_con_and_y_else	db	'IF con AND y ELSE','$',32 dup (?)
	@_if_con_not	db	'IF con NOT','$',39 dup (?)
	@___entre_al_if_con_not	db	'**entre al IF con NOT','$',28 dup (?)
	@_if_con_expresiones	db	'IF con EXPRESIONES','$',31 dup (?)
	@_6	dd	6.000
	@_2	dd	2.000
	@_asignaciones_simples	db	'Asignaciones simples','$',29 dup (?)
	@_3p33	dd	3.330
	@_entradas_y_salidas	db	'Entradas y salidas','$',31 dup (?)
	@_ingrese_valor_de_a___	db	'Ingrese valor de a : ','$',28 dup (?)
	@_temas_especiales	db	'Temas Especiales','$',33 dup (?)
	@_inlist	db	'INLIST','$',43 dup (?)
	@_4	dd	4.000
	@___encontrado	db	'**encontrado','$',37 dup (?)
	@___no_encontrado	db	'**no encontrado','$',34 dup (?)
	@_inlist_con_expresiones	db	'INLIST con EXPRESIONES','$',27 dup (?)
	@_7p0	dd	7.000
	@_avg_comun	db	'AVG comun','$',40 dup (?)
	@_avg_con_expresiones	db	'AVG con EXPRESIONES','$',30 dup (?)
	@_while_anidado	db	'WHILE anidado','$',36 dup (?)
	@___entre_al_while_1	db	'**entre al WHILE 1','$',31 dup (?)
	@___entre_al_while_2	db	'**entre al WHILE 2','$',31 dup (?)
	@aux	DD 0.0
	@___aux0 	DD 0.0
	@___aux1 	DD 1.0
	@___aux2 	DD 1.0
	@___aux3 	DD 1.0
	@___aux4 	DD 1.0
	@___aux5 	DD 1.0
	@___aux6 	DD 1.0
	@___aux7 	DD 0.0
	@___aux8 	DD 1.0
	@___aux9 	DD 1.0
	@___aux10 	DD 1.0
	@___aux11 	DD 1.0
	@___aux12 	DD 1.0
	@___aux13 	DD 1.0
	@___aux14 	DD 0.0
	@___aux15 	DD 3.0
	@___aux16 	DD 0.0
	@___aux17 	DD 5.0

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX

	MOV ES, AX


;Comienzo codigo de usuario


	LEA DX, @_se_declararon_variables 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_constantes_numericas 
	MOV AH, 9
	INT 21H
	newline
	fld @_0p12
	fstp @a
	fld @_12p1
	fstp @d
	fld @_1
	fstp @b
	fld @_5
	fstp @c

	LEA DX, @_asignacion_con_expresion 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fld @a
	fadd St(0),St(1)
	fstp @c
	displayFloat @c, 2
	newline
	displayFloat @a, 2
	newline
	displayFloat @b, 2
	newline

	LEA DX, @_constantes_string 
	MOV AH, 9
	INT 21H
	newline
	MOV SI, OFFSET @_hola
	MOV DI, OFFSET @pri
	call COPIAR

	LEA DX, @pri 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_while_comun 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
@@etiq1:
	fld @_3
	fcomp @b
	fstsw AX
	sahf
	JNA @@etiq2
	fld @_1
	fld @b
	fadd St(0),St(1)
	fstp @b

	LEA DX, @___entre_al_while 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq1
@@etiq2:

	LEA DX, @_while_con_not 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
@@etiq3:
	fld @_3
	fcomp @b
	fstsw AX
	sahf
	JNAE @@etiq4
	fld @_1
	fld @b
	fadd St(0),St(1)
	fstp @b

	LEA DX, @___entre_al_while_con_not 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq3
@@etiq4:

	LEA DX, @_if_comun__entra_ 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq5

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
@@etiq5:

	LEA DX, @_if_comun__no_entra_ 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JE @@etiq6

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
@@etiq6:

	LEA DX, @_if_con_else__entra_if_ 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq7

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq8
@@etiq7:

	LEA DX, @___ingresa_al_else 
	MOV AH, 9
	INT 21H
	newline
@@etiq8:

	LEA DX, @_if_con_else__entra_else_ 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JE @@etiq9

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq10
@@etiq9:

	LEA DX, @___ingresa_al_else 
	MOV AH, 9
	INT 21H
	newline
@@etiq10:

	LEA DX, @_if_con_and 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_3
	fstp @a
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq11
	fld @_0
	fcomp @a
	fstsw AX
	sahf
	JNB @@etiq12

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
@@etiq12:
@@etiq11:

	LEA DX, @_if_con_and_y_else 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_3
	fstp @a
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq13
	fld @_0
	fcomp @a
	fstsw AX
	sahf
	JNB @@etiq14

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq15
@@etiq14:
@@etiq13:

	LEA DX, @___ingresa_al_else 
	MOV AH, 9
	INT 21H
	newline
@@etiq15:

	LEA DX, @_if_con_not 
	MOV AH, 9
	INT 21H
	newline
	fld @_0
	fstp @b
	fld @_0
	fcomp @b
	fstsw AX
	sahf
	JNAE @@etiq16

	LEA DX, @___entre_al_if_con_not 
	MOV AH, 9
	INT 21H
	newline
@@etiq16:

	LEA DX, @_if_con_expresiones 
	MOV AH, 9
	INT 21H
	newline
	fld @_6
	fstp @b
	fld @_2
	fld @b
	fadd St(0),St(1)
	fcomp @b
	fstsw AX
	sahf
	JNA @@etiq17

	LEA DX, @___ingresa_al_if 
	MOV AH, 9
	INT 21H
	newline
@@etiq17:

	LEA DX, @_asignaciones_simples 
	MOV AH, 9
	INT 21H
	newline
	fld @_3p33
	fstp @a
	fld @a
	fstp @d
	displayFloat @d, 2
	newline

	LEA DX, @_entradas_y_salidas 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_ingrese_valor_de_a___ 
	MOV AH, 9
	INT 21H
	newline
	getFloat @a, 2
	newline
	displayFloat @a, 2
	newline

	LEA DX, @_temas_especiales 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_inlist 
	MOV AH, 9
	INT 21H
	newline
	fld @_5
	fstp @b
	fld @___aux0
	fstp @aux
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq18
	fld @___aux1
	fstp @aux
@@etiq18:
	fld @_2
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq19
	fld @___aux2
	fstp @aux
@@etiq19:
	fld @_3
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq20
	fld @___aux3
	fstp @aux
@@etiq20:
	fld @_4
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq21
	fld @___aux4
	fstp @aux
@@etiq21:
	fld @_5
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq22
	fld @___aux5
	fstp @aux
@@etiq22:
	fld @aux
	fcomp @___aux6
	fstsw AX
	sahf
	JNZ @@etiq23

	LEA DX, @___encontrado 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq24
@@etiq23:

	LEA DX, @___no_encontrado 
	MOV AH, 9
	INT 21H
	newline
@@etiq24:

	LEA DX, @_inlist_con_expresiones 
	MOV AH, 9
	INT 21H
	newline
	fld @_7p0
	fstp @b
	fld @_7p0
	fstp @c
	fld @___aux7
	fstp @aux
	fld @_1
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq25
	fld @___aux8
	fstp @aux
@@etiq25:
	fld @_2
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq26
	fld @___aux9
	fstp @aux
@@etiq26:
	fld @_1
	fld @c
	fadd St(0),St(1)
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq27
	fld @___aux10
	fstp @aux
@@etiq27:
	fld @_4
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq28
	fld @___aux11
	fstp @aux
@@etiq28:
	fld @_5
	fcomp @b
	fstsw AX
	sahf
	JNZ @@etiq29
	fld @___aux12
	fstp @aux
@@etiq29:
	fld @aux
	fcomp @___aux13
	fstsw AX
	sahf
	JNZ @@etiq30

	LEA DX, @___encontrado 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq31
@@etiq30:

	LEA DX, @___no_encontrado 
	MOV AH, 9
	INT 21H
	newline
@@etiq31:

	LEA DX, @_avg_comun 
	MOV AH, 9
	INT 21H
	newline
	fld @___aux14
	fstp @aux
	fld @_2
	fld @aux
	fadd St(0),St(1)
	fstp @aux
	fld @_4
	fld @aux
	fadd St(0),St(1)
	fstp @aux
	fld @_6
	fld @aux
	fadd St(0),St(1)
	fstp @aux
	fld @___aux15
	fld @aux
	fdiv St(0),St(1)
	fstp @aux
	fld @aux
	fstp @a
	displayFloat @a, 2
	newline

	LEA DX, @_avg_con_expresiones 
	MOV AH, 9
	INT 21H
	newline
	fld @_5
	fstp @b
	fld @___aux16
	fstp @aux
	fld @_2
	fld @aux
	fadd St(0),St(1)
	fstp @aux
	fld @b
	fld @b
	fadd St(0),St(1)
	fld @_2
	fld @aux
	fdiv St(0),St(1)
	fadd St(0),St(1)
	fstp @aux
	fld @_6
	fld @aux
	fadd St(0),St(1)
	fstp @aux
	fld @___aux17
	fld @aux
	fdiv St(0),St(1)
	fstp @aux
	fld @aux
	fstp @a
	displayFloat @a, 2
	newline

	LEA DX, @_while_anidado 
	MOV AH, 9
	INT 21H
	newline
	fld @_1
	fstp @b
	fld @_1
	fstp @c
@@etiq32:
	fld @_3
	fcomp @b
	fstsw AX
	sahf
	JNA @@etiq33
	fld @_1
	fld @b
	fadd St(0),St(1)
	fstp @b

	LEA DX, @___entre_al_while_1 
	MOV AH, 9
	INT 21H
	newline
@@etiq34:
	fld @_3
	fcomp @c
	fstsw AX
	sahf
	JNA @@etiq35
	fld @_1
	fld @c
	fadd St(0),St(1)
	fstp @c

	LEA DX, @___entre_al_while_2 
	MOV AH, 9
	INT 21H
	newline
	jmp @@etiq34
@@etiq30:
	jmp @@etiq32
@@etiq33:

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

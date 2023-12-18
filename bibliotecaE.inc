;------------------------------------
;Biblioteca de registradores
;------------------------------------
segment .data
    LF          equ 0xA  ; Line feed (pula linha)
    NULL        equ 0xD  ; Final da String
    SYS_CALL    equ 0x80 ; Envia informacao ao SO
    ; EAX ou RAX (32 ou 64 bits)
    SYS_EXIT    equ 0x1  ; codigo de chamada para finalizar
    SYS_READ    equ 0x3; ; Operacao de leitura
    SYS_WRITE   equ 0x4  ; Operacao de escrita
    ; EBX ou RBX
    RET_EXIT    equ 0x0  ; Operacao realizada com sucesso
    STD_IN      equ 0x0  ; Entrada padrao
    STD_OUT     equ 0x1  ; Saida padrao

    TAM_BUFFER equ 0xA

segment .bss
    BUFFER resb 0x1

segment .text

;------------------------------------
;String para inteiro
;------------------------------------
;Entrada: ESI (valor conv) ECX (tam)
;Saida : EAX
;------------------------------------
string_to_int:
    xor ebx, ebx            ; o mesmo que mov ebx, RET_EXIT (equ 0x0), zerar o controlador
.prox_digito:
    movzx eax, byte[esi]
    inc esi
    sub al, '0'
    imul ebx, 0xA
    add ebx, eax            ; ebx = ebx*10 + eax
    loop .prox_digito       ; while (--exc)
    mov eax, ebx
    ret

;------------------------------------
;Inteiro para string
;------------------------------------
;Entrada: inteiro para EAX 
;Saida : BUFFER (valor ECX) TAM_BUFFER (EDX)
;------------------------------------ 

int_to_string:
    lea esi, [BUFFER]
    add esi, 0x9
    mov byte[esi], 0xA
    mov ebx, 0xA
.prox_digito:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .prox_digito ; while (--ecx)
    ret


;------------------------------------
;Saida do resultado no terminal
;------------------------------------
;Entrada: Valor String em BUFFER
;Saida : Valor no terminal
;------------------------------------ 
saidaResultado:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, BUFFER
    mov edx, TAM_BUFFER
    int SYS_CALL
    ret
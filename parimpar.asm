%include 'bibliotecaE.inc'  ; Inclui a biblioteca


section .data                                           ; variaveis de alocacao dinamica com atribuicao previa
    msg db 'Entre com o valor de 3 digitos:', LF, NULL  ; Carrega em 'msg' o valor da string + LF + NULL
    tamMsg equ $ - msg                                  ; Carrega em 'tamMsg' o tamanho equivalente (equ) de 'msg'
    parMsg db 'Numero par!', LF, NULL                   ; Assim sucessivamente para parMsg
    tamPar equ $ - parMsg
    imparMsg db 'Numero impar!', LF, NULL               ; E para imparMsg
    tamImpar equ $ - imparMsg

section .bss            ; variaveis de alocacao estatica sem atribuicao previa
    num resb 1          ; 1 variavel nao inicializada (resb)

section .text

global _start

_start:
    mov eax, SYS_WRITE  ; eax contera o valor de escrita
    mov ebx, STD_OUT    ; ebx contera o valor de saida
    mov ecx, msg        ; ecx contera o valor de msg em .data
    mov edx, tamMsg     ; edx contera o tamanho da string em tamMsg em .data
    int SYS_CALL        ; Envia informacoes para o SO

entrada_valor:
    mov eax, SYS_READ   ; eax contera o valor de leitura
    mov ebx, STD_IN     ; ebx contera o endereco de STD_IN (entrada padrao)
    mov ecx, num        ; Variavel onde o que for digitado ficara armazenada
    mov edx, 0x4        ; Para ter um numero de 3 digitos
    int SYS_CALL        ; Envia informacoes para o SO

    lea esi, [num]      ; (load effective address) Armazena o endereco de 'num' em esi
    mov ecx, 0x3        ; Tamanho 3 para ecx
    call string_to_int  ; entrada esi e ecx, o valor convertido ficara em eax

verificar:
    mov edx, 0x0        ; Zerar edx
    mov ebx, 0x2        ; Move o numero 2 para ebx
    div ebx             ; Divide eax com ebx, o resto vai para edx
    cmp edx, 0x0        ; Compara edx com 0 '0x0' 
    jz mostra_par       ; (jump if zero) se resultado da subtracao for 0 (edx-0), vai para mostra_par

mostra_impar:           ; Processo de impressao para numero impar
    mov eax, SYS_WRITE  
    mov ebx, STD_OUT
    mov ecx, imparMsg
    mov edx, tamImpar
    int SYS_CALL        ; Envia informacoes para o SO
    jmp saida           ; (jump) pula para saida.

mostra_par:             ; Processo de impressao para numero par (caso de jz verdadeiro em 'verificar')
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, parMsg
    mov edx, tamPar     ; Envia informacoes para o SO
    int SYS_CALL        ; (jump) pula para saida.

saida:
    mov eax, SYS_EXIT
    mov ebx, RET_EXIT
    int SYS_CALL
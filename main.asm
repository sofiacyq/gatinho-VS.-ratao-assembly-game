jmp main

FlagColuna: var #40 ;inicializa no zero == flag desligada
FlagCaindo: var #10
posMenina: var #1
posAntMenina: var #1

IncRandGato: var #10
    static IncRandGato + #0, #0 ;inicializa no 0
    static IncRandGato + #1, #0 ;inicializa no 0
    static IncRandGato + #2, #0 ;inicializa no 0
    static IncRandGato + #3, #0 ;inicializa no 0
    static IncRandGato + #4, #0 ;inicializa no 0
    static IncRandGato + #5, #0 ;inicializa no 0
    static IncRandGato + #6, #0 ;inicializa no 0
    static IncRandGato + #7, #0 ;inicializa no 0
    static IncRandGato + #8, #0 ;inicializa no 0
    static IncRandGato + #9, #0 ;inicializa no 0
    
    
main:
	loadn r1, #tela1Linha0	    ;Endereco onde comeca a primeira linha do cenario
	loadn r2, #0  	   ;cor branca
	call ImprimeTela
	
	Loopmenu:
		inchar r4
		loadn r1, #13           ;tecla enter
		
		inc r2                  ;faz a soma aleatória para dar o rand

		cmp r4, r1
		jne Loopmenu

		loadn r5, #40           ;limita o valor para ficar entre 0 e 39
		mod r3, r2, r5

		loadn r0, #IncRandGato
		storei r0, r3           ;guardo esse valor aleatório no IncRandGato[0]
		
		
	Restart:
        call Inicializacao

        call ApagaTela
        loadn R1, #tela2Linha0	    ;Endereco onde comeca a primeira linha do cenario!!
        loadn R2, #512  			;cor verde -> grama
        call ImprimeTela2   		;Rotina de Impresao de Cenario na Tela Inteira
        
        loadn R1, #tela3Linha0	    ;Endereco onde comeca a primeira linha do cenario!!
        loadn R2, #256              ;cor marrom         
        call ImprimeTela2   	    ;Rotina de Impresao de Cenario na Tela Inteira
        
        loadn r0, #874
        store posMenina, r0         ;Personagem começa na linha 27, coluna 39
        call DesenhaMenina

        loadn r0, #0	
        loadn r2, #0	
		
halt

;--------------------------------------------
;               Inicialização
;--------------------------------------------
Inicializacao:
    ;Zera as flags
    push r0
    push r1
    push r2
    push r3

    loadn r0, #FlagCaindo       ;sempre é endereço, não flag
    loadn r2, #10               ;número de flags (como são de 0 - 4, se o r3 == 5, passou do número de flags existentes)
    loadn r1, #0                ;vai ser o 0 que zera as flags
    store posAntMenina, r1
    loadn r3, #0                ;contador para não passar o número de flags -> qual flag que é
    LoopFlagCaindo0:
        storei r0, r1           ;endereço da flag recebe 0

        inc r0      ;vai para o próximo endereço da flag
        inc r3      ;vai para a próxima flag 

        cmp r3, r2
        jne LoopFlagCaindo0
        
    loadn r3, #0                ;contador para não passar o número de flags -> qual flag que é
    loadn r0, #FlagColuna
    loadn r2, #40               ;número de flags (como são de 0 - 5, se o r3 == 6, passou do número de flags existentes)
    LoopFlagColuna0:
        storei r0, r1           ;endereço da flag recebe 0

        inc r0      ;vai para o próximo endereço da flag
        inc r3      ;vai para a próxima flag 

        cmp r3, r2
        jne LoopFlagColuna0

    pop r3
    pop r2
    pop r1
    pop r0
    rts
    

;--------------------------------------------
;            Desenha e Apaga Simoes 
;--------------------------------------------
DesenhaMenina:
    push r0
    push r1
    push r2

    load r0, posMenina
    loadn r2, #3328             ;cor rosa
    loadn r1, ':'               
    add r1, r1, r2             

    outchar r1, r0

    store posAntMenina, r0
    
    pop r2
    pop r1
    pop r0
    rts
    
   
;--------------------------------------------
;             Imprime Tela
;--------------------------------------------
ImprimeTela:
	;r1 = endereco onde comeca a primeira linha do Cenario
	;r2 = cor do Cenario para ser impresso

	push r0	
	push r1	
	push r2	
	push r3	
	push r4
	push r5

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;--------------------------------------------
;               Imprime Tela 2
;--------------------------------------------
ImprimeTela2:
	;r1 = endereco onde comeca a primeira linha do Cenario
	;r2 = cor do Cenario para ser impresso

	push r0	
	push r1	
	push r2	
	push r3	
	push r4
	push r5	
	push r6	

	loadn r0, #0  	        ;posicao inicial tem que ser o comeco da tela
	loadn r3, #40  	        ;incremento da posicao da tela
	loadn r4, #41  	        ;incremento do ponteiro das linhas da tela
	loadn r5, #1200         ;limite da tela
	loadn r6, #tela0Linha0	;endereco onde comeca a primeira linha do cenario
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	;incrementa posicao para a segunda linha na tela (r0 = r0 + 40)
		add r1, r1, r4  	;incrementa o ponteiro para o comeco da proxima linha na memoria (40 + '/0') (r1 = r1 + 41)
		add r6, r6, r4  	;incrementa o ponteiro para o comeco da proxima linha na memoria (40 + '/0') (r1 = r1 + 41)
		cmp r0, r5			;compara r0 com 1200
		jne ImprimeTela2_Loop	

	pop r6	
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;--------------------------------------------
;                 Apaga Tela
;--------------------------------------------
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	
	
	
;--------------------------------------------
;             Imprime String 
;--------------------------------------------
ImprimeStr:	 
    ;r0 = Posicao da tela que o primeiro caractere da mensagem será impresso 
    ;r1 = endereco onde comeca a mensagem
    ;r2 = cor da mensagem

	push r0	
	push r1	
	push r2	
	push r3	
	push r4
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	
;--------------------------------------------
;             Imprime String 2
;--------------------------------------------
ImprimeStr2: 
    ;r0 = Posicao da tela que o primeiro caractere da mensagem será impresso  
    ;r1 = endereco onde comeca a mensagem
    ;r2 = cor da mensagem. 
	
    push r0	
	push r1	
	push r2	
	push r3	
	push r4
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
   		storei r6, r4
        
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	

;--------------------------------------------
;                   TELAS
;--------------------------------------------
;Endereço das telas desenhadas (STR2 - 1+2)
tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	

;Tela 01: 100 gatinhos vs. ratão
tela1Linha0  : string "            ___   ___ ___               "
tela1Linha1  : string "           |_  | |   |   |              "
tela1Linha2  : string "             | | | | | | |              "
tela1Linha3  : string "            _| | | | | | |              "
tela1Linha4  : string "           |_____|___|___|              "
tela1Linha5  : string "             _   _     _                "
tela1Linha6  : string "     ___ ___| |_|_|___| |_ ___ ___      "
tela1Linha7  : string "    | a | a'|  _| |   |   | a |_ -|     "
tela1Linha8  : string "    |_  |__,|_| |_|_|_|_|_|___|___|     "
tela1Linha9  : string "    |___|                               "
tela1Linha10 : string "             _____ _____                "
tela1Linha11 : string "            |  |  |   __|               "
tela1Linha12 : string "            |  |  |__   |_              "
tela1Linha13 : string "             '___'|_____|_|             "
tela1Linha14 : string "                        ___             "
tela1Linha15 : string "     _____ _____ _____ _____ _____      "
tela1Linha16 : string "    | __  |  a  |_   _|  a  |     |     "
tela1Linha17 : string "    |    -|     | | | |     |  |  |     "
tela1Linha18 : string "    |__|__|__|__| |_| |__|__|_____|     "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "         
tela1Linha26 : string "                                        "
tela1Linha27 : string "       Aperte enter para iniciar        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "----------------------------------------"

;Tela 02: chão
tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "@@@@@@                                  "
tela2Linha10 : string "@@@@@@@@@                               "
tela2Linha11 : string "@@@@@@@@@@                              "
tela2Linha12 : string "@@@@@@@@@@@@                            "
tela2Linha13 : string "@@@@@@@@@@@@@                           "
tela2Linha14 : string "@@@@ @@@@@@@@                           "
tela2Linha15 : string "          @@                            "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "___________,M_______M__,______________,M"
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "


;Tela 03: Tronco da árvore
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "          _                             "
tela3Linha14 : string "   v   _/ _                             "
tela3Linha15 : string "       __/                              "
tela3Linha16 : string "      /                                 "
tela3Linha17 : string "     |                                  "
tela3Linha18 : string "     |                                  "
tela3Linha19 : string "     |                                  "
tela3Linha20 : string "     |                                  "
tela3Linha21 : string " /   \\                                 "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "
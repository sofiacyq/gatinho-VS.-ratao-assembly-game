jmp main

posMenina: var #1

Gatos: var #1
    static Gatos, #0

fase: var #1
    static fase, #1

posGato: var #1
    static posGato, #840   ; Gato 0 começa na coluna 0 (Amarelo manteiga)

corGato: var #1
    static corGato + #0, #512   ; Amarelo manteiga

contadorGatos: var #1
    static contadorGatos, #0

vidasGato: var#1
    static vidasGato, #7
 
    
main:
    call Delay
    call Delay

	loadn r1, #tela1Linha0	    ;Endereco onde comeca a primeira linha do cenario
	loadn r2, #0  	   ;cor branca
	call ImprimeTela

	Loopmenu:
        inchar r4                   ; Fica esperando uma tecla ser pressionada
    
        loadn r5, #255              ; Máscara 0x00FF (pega apenas os 8 bits do ASCII)
        and r4, r4, r5              ; r4 = r4 AND 255
    
        loadn r1, #13               ; Código ASCII da tecla Enter
        cmp r4, r1
        jne Loopmenu
    
    Manual:
        call Delay
        call Delay
        
        call ApagaTela

        loadn r1, #telaManualLinha0	    ;Endereco onde comeca a primeira linha do cenario
	    loadn r2, #0  	   ;cor branca
	    call ImprimeTela2

        loadn r1, #telaManual2Linha0
        loadn r2, #0
        call ImprimeTela2
        
        LoopManual:
            inchar r4

            loadn r5, #255              ; Máscara 0x00FF (pega apenas os 8 bits do ASCII)
            and r4, r4, r5              ; r4 = r4 AND 255
    
            loadn r1, #13               ; Código ASCII da tecla Enter
            cmp r4, r1
            jne LoopManual
		
		
	Restart:
        loadn r3, #840
        store posGato, r3
        loadn r4, #7
        store vidasGato, r4 
        
        call ApagaTela
        loadn R1, #tela2Linha0	    ;Endereco onde comeca a primeira linha do cenario!!
        loadn R2, #58112  			;cor verde -> grama
        call ImprimeTela2   		;Rotina de Impressão de Cenario na Tela Inteira
        
        loadn R1, #tela3Linha0	    ;Endereco onde comeca a primeira linha do cenario!!
        loadn R2, #30464            ;cor marrom -> tronco da árvore        
        call ImprimeTela2   	    ;Rotina de Impressão de Cenario na Tela Inteira
        
        loadn r0, #874
        store posMenina, r0         ;Personagem começa na linha 27, coluna 39
        call DesenhaMenina


		LoopGatos:

        inchar r7                    ;cria registrador 
        
        loadn r1, #'a'               ;r1 recebe tecla m, para subir
        cmp r7,r1                    ;compara r1 com r7
        jeq Sobe                     ;se igual vai pra SObe

        loadn r1, #' '               ;r1 recebe tecla space
        cmp r7, r1                   ;compara r1 com r7
        jeq Desce                    ;se igual vai pra Desce

        ContinuaLoop:
        call MoveGato
        call DesenhaMenina
        call Delay
        jmp LoopGatos


        loadn r0, #0	
        loadn r2, #0	
		
halt

;--------------------------------------------
    ;          SOBE
;-------------------------------------------

Sobe:
    load r2, posGato      ; carrega a posição atual do gato
    
    loadn r3,  #840
    sub r3, r2, r3

    ;busca o caractere
    loadn r6, #tela2Linha21
    add r6, r6, r3
    loadi r6, r6
    
    loadn r3, #58112
    add r6, r6, r3
    outchar r6, r2
         ; apaga gato da posicao
    loadn r3, #40
    sub r2, r2, r3        ; sobe uma linha (posição - 40)
    store posGato, r2     ; salva a nova posição
    jmp ContinuaLoop

;-------------------------------------------
;                    DESCE
;-------------------------------------------
Desce:
    load r2, posGato      ; carrega a posição atual do gato
    loadn r3, #' '
    outchar r3, r2        ; apaga gato da posicao
    loadn r3, #40
    add r2, r2, r3        ; desce uma linha (posição + 40)
    store posGato, r2     ; salva a nova posição
    jmp ContinuaLoop
;----------------------------------------------
;                   COLETOU GATO
;----------------------------------------------
ColetouGato:

    load r5, contadorGatos
    inc r5
    store contadorGatos, r5

    ;volta gato pro inicio
    loadn r2, #840
    storei r1, r2

    jmp SalvaNovaPos

;--------------------------------------------
;            Desenha e Apaga Menina
;--------------------------------------------
DesenhaMenina:
    push r1
    push r2

    loadn r1, #telaMeninaLinha0	    ;Endereco onde comeca a primeira linha do cenario!!
    loadn r2, #3328             ;cor marrom -> tronco da árvore        
    call ImprimeTela2   	    ;Rotina de Impressão de Cenario na Tela Inteira

    
    pop r2
    pop r1
    rts
       
;-------------------------------------------
;                 SOME GATO
;-------------------------------------------

Morreu:
    load r5, vidasGato
    dec r5
    store vidasGato, r5

    load r2, posGato

    loadn r3, #840
    sub r3, r2, r3
    loadn r6, #tela2Linha21
    add r6, r6, r3
    loadi r6, r6

    loadn r3, #58112
    add r6, r6, r3
    outchar r6, r2
    
    loadn r2, #840
    store posGato, r2
    
    loadn r6, #0
    cmp r5, r6
    jne SalvaNovaPos        ; ainda tem vidas, continua normalmente

    ; sem vidas: limpa pilha antes de ir pro GameOver
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    jmp GameOver

;--------------------------------------------
 ;               FASE DO RATO 
 ; -----------------------------------------

 FaseDoRato:

    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1

    call Batalha
    
    call Delay
    call Delay

    Verifica:
        ; Verifica a condição de vitória: vida maior ou igual a 4
        load r5, vidasGato
        loadn r6, #4
        cmp r5, r6
        jeg Ganhou
        jne GameOverInsuficiente

    Ganhou:
        call ApagaTela
        loadn r1, #telaGanhouLinha0
        loadn r2, #0
        call ImprimeTela

        LoopGanhou:
        call Delay
        call Delay

        inchar r4                   ; Fica esperando uma tecla ser pressionada
    
        loadn r5, #255              ; Máscara 0x00FF (pega apenas os 8 bits do ASCII)
        and r4, r4, r5              ; r4 = r4 AND 255
    
        loadn r1, #13               ; Código ASCII da tecla Enter
        cmp r4, r1
        jne LoopGanhou
        jeq main


;--------------------------------------------
;                 GAME OVER
;--------------------------------------------
GameOver:
    Call ApagaTela

    loadn r1, #telaGameOverLinha0
    loadn r2, #0

    call ImprimeTela

    call Loopover

GameOverInsuficiente:
    Call ApagaTela

    loadn r1, #telaGameOverInsuficienteLinha0
    loadn r2, #0
    call ImprimeTela

    call Loopover

Loopover:
    call Delay
    call Delay

    inchar r4                   ; Fica esperando uma tecla ser pressionada
    
    loadn r5, #255              ; Máscara 0x00FF (pega apenas os 8 bits do ASCII)
    and r4, r4, r5              ; r4 = r4 AND 255
    
    loadn r1, #13               ; Código ASCII da tecla Enter
    cmp r4, r1
    jne Loopover
    jeq main

;--------------------------------------------
;                 Move Gato
;--------------------------------------------
; Parâmetro: r0 = Índice do gato (0, 1 ou 2)
;--------------------------------------------
MoveGato:
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    ; 1. Calcular os endereços na memória baseados no ID (r0)
    loadn r1, #posGato    ; r1 = endereço de posGato[ID]
    loadi r2, r1        ; r2 = valor da posição atual do gato (ex: 845)

    ;apagar gato antigo
     loadn r5, #840
    sub r5, r2, r5

    loadn r6, #tela2Linha21
    add r6, r6, r5

    loadi r5, r6

    loadn r6, #58112
    add r5, r5, r6

    outchar r5, r2

    loadn r4, #512


    ; r2 guarda a posição absoluta da tela (ex: 840 a 879)
    ; A linha 21 começa em 840. Queremos saber o deslocamento (coluna) dentro da linha:
    loadn r5, #840
    sub r5, r2, r5      ; r5 = r2 - 840 (Descobre a coluna exata de 0 a 39)

    loadn r6, #tela2Linha21
    add r6, r6, r5      
    loadi r5, r6        

    loadn r6, #58112  
    add r5, r5, r6      
    outchar r5, r2

    ; 3. Calcular a nova posição do gato
    inc r2              ; Anda 1 bloco para a direita

    ;colisao com o mato-----
    loadn r5, #845
        cmp r2, r5
        jeq Morreu

        loadn  r5, #851
        cmp r2, r5
        jeq Morreu

        loadn r5, #860
        cmp r2, r5
        jeq Morreu


    load r5, posMenina
    cmp r2, r5
    jeq Batalha

    ; 4. Verificar limite da linha 21 (Fim é 880)
    loadn r5, #880
    cmp r2, r5
    jne SalvaNovaPos
    
    loadn r2, #840      ; Se passou do fim, volta para o começo da linha

SalvaNovaPos:
    storei r1, r2       ; Atualiza a nova posição na memória (posGato[ID] = r2)

    ; 5. Desenhar o gato na nova posição com sua respectiva cor
    loadn r5, #'a'      ; Caractere do gato
    add r5, r5, r4      ; Soma o caractere 'a' com a cor correspondente
    outchar r5, r2      ; Plota o gatinho na tela!

    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    rts

;--------------------------------------------
;             Sub-rotina: Delay
;--------------------------------------------
Delay:
    push r0
    push r1
    loadn r0, #200; Controle de velocidade dos 3 juntos
Delay_Loop1:
    loadn r1, #100
Delay_Loop2:
    dec r1
    jnz Delay_Loop2
    dec r0
    jnz Delay_Loop1
    pop r1
    pop r0
    rts


;--------------------------------------------
;                 BATALHA
; --------------------------------------------
Batalha:
    push r1
    push r2
    push r4

    call ApagaTela          ; limpa tudo primeiro
    
    loadn r1, #tela4Linha0
    loadn r2, #58112
    call ImprimeTela2       ; gato pequeno

    call Delay
    call Delay
    call Delay
    call Delay
    call Delay
    call Delay
    call Delay

    call Batalha2

    Batalha2:
        call ApagaTela

        loadn r1, #tela5Linha0
        loadn r2, #7936
        call ImprimeTela2       ; rato por cima

        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay
        call Delay

        Loop_batalha2:
        inchar r4
		loadn r1, #13           ;tecla enter

		cmp r4, r1
		jeq Verifica
        jne Loop_batalha2

pop r4
pop r2
pop r1

        
    

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

	loadn r0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn r3, #40  	; Incremento da posicao da tela!
	loadn r4, #41  	; incremento do ponteiro das linhas da tela
	loadn r5, #1200 ; Limite da tela!
	
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


;Tela 01: gatinho vs. ratão
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "                                        "
tela1Linha5  : string "                _   _     _             "
tela1Linha6  : string "        ___ ___| |_|_|___| |_ ___       "
tela1Linha7  : string "       | a | a'|  _| |   |   | a |      "
tela1Linha8  : string "       |_  |__,|_| |_|_|_|_|_|___|      "
tela1Linha9  : string "       |___|                            "
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
tela2Linha21 : string "_____M_____,M_______M__,______________,M"
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
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "        

;Tela 04: Batalha1 
tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                CUIDADO!                "
tela4Linha3  : string "                                        "
tela4Linha4  : string "                                        "
tela4Linha5  : string "                                        "
tela4Linha6  : string "                                        "
tela4Linha7  : string "                                        "
tela4Linha8  : string "                                        "
tela4Linha9  : string "           .     _,-''''`-.             "
tela4Linha10 : string "         (,-.._,'(       ]K-X]          "
tela4Linha11 : string "             -.-' I )-( , o o)          "
tela4Linha12 : string "                   -    L_`'''-         "
tela4Linha13 : string "                                        "
tela4Linha14 : string "                                        "
tela4Linha15 : string "                                        "
tela4Linha16 : string "                                        "
tela4Linha17 : string "                                        "
tela4Linha18 : string "                                        "
tela4Linha19 : string "                                        "
tela4Linha20 : string "                                        "
tela4Linha21 : string "                                        "
tela4Linha22 : string "                                        "
tela4Linha23 : string "                                        "
tela4Linha24 : string "                                        "
tela4Linha25 : string "                                        "
tela4Linha26 : string "                                        "
tela4Linha27 : string "                                        "
tela4Linha28 : string "                                        "
tela4Linha29 : string "                                        "


;Tela 05: Batalha2 
tela5Linha0  : string "                                        "
tela5Linha1  : string "    O RATAO APARECEU! CONTABILIZANDO    "
tela5Linha2  : string "                 VIDAS                  "
tela5Linha3  : string "                                        "
tela5Linha4  : string "                                        "
tela5Linha5  : string "                                        "
tela5Linha6  : string "                                        "
tela5Linha7  : string "                                        "
tela5Linha8  : string "                                        "
tela5Linha9  : string "                                        "
tela5Linha10 : string "         ( ) __( )                      "
tela5Linha11 : string "         K        K                     "
tela5Linha12 : string "       K @    @  K                      "
tela5Linha13 : string "      K *       K                       "
tela5Linha14 : string "      K VWVw v   K                      "
tela5Linha15 : string "       K^^^ ^      K             )      "
tela5Linha16 : string "    7  K    7        K            )     "
tela5Linha17 : string "     K K     K         K         K      "
tela5Linha18 : string "       K                 K     K        "
tela5Linha19 : string "       K                   K K          "
tela5Linha20 : string "         k  VV        VV                "
tela5Linha21 : string "                                        "
tela5Linha22 : string "                                        "
tela5Linha23 : string "                                        "
tela5Linha24 : string "     <APERTE ENTER PARA CONTINUAR>      "
tela5Linha25 : string "                                        "
tela5Linha26 : string "                                        "
tela5Linha27 : string "                                        "
tela5Linha28 : string "                                        "
tela5Linha29 : string "                                        "

;tela de vitoria (ganhou)
telaGanhouLinha0  : string "                                        "
telaGanhouLinha1  : string "                                        "
telaGanhouLinha2  : string "                                        "
telaGanhouLinha3  : string "                                        "
telaGanhouLinha4  : string "                                        "
telaGanhouLinha5  : string "  _____ _____ _____ _____               "
telaGanhouLinha6  : string " |  |  |     |     |  __|               "
telaGanhouLinha7  : string " |  |  |  |  |   --|  __|               "
telaGanhouLinha8  : string "  `___`|_____|_____|_____|              "
telaGanhouLinha9  : string "                                        "
telaGanhouLinha10 : string "                                        "
telaGanhouLinha11 : string "  _____ _____ _____ _____ _____ _____   "
telaGanhouLinha12 : string " |   __|  _  |   | |  |  |     |  |  |  "
telaGanhouLinha13 : string " |  |  |     | | | |     |  |  |  |  |  "
telaGanhouLinha14 : string " |_____|__|__|_|___|__|__|_____|_____|  "
telaGanhouLinha15 : string "                                        "
telaGanhouLinha16 : string "                                        "
telaGanhouLinha17 : string "                                        "
telaGanhouLinha18 : string "                                        "
telaGanhouLinha19 : string "                                        "
telaGanhouLinha20 : string "                                        "
telaGanhouLinha21 : string "                                        "
telaGanhouLinha22 : string "  <APERTE ENTER PARA JOGAR NOVAMENTE>   "
telaGanhouLinha23 : string "                                        "
telaGanhouLinha24 : string "                                        "
telaGanhouLinha25 : string "                                        "
telaGanhouLinha26 : string "                                        "
telaGanhouLinha27 : string "                                        "
telaGanhouLinha28 : string "                                        "
telaGanhouLinha29 : string "                                        "

;Tela menina
telaMeninaLinha0  : string "                                        "
telaMeninaLinha1  : string "                                        "
telaMeninaLinha2  : string "                                        "
telaMeninaLinha3  : string "                                        "
telaMeninaLinha4  : string "                                        "
telaMeninaLinha5  : string "                                        "
telaMeninaLinha6  : string "                                        "
telaMeninaLinha7  : string "                                        "
telaMeninaLinha8  : string "                                        "
telaMeninaLinha9  : string "                                        "
telaMeninaLinha10 : string "                                        "
telaMeninaLinha11 : string "                                        "
telaMeninaLinha12 : string "                                        "
telaMeninaLinha13 : string "                                        "
telaMeninaLinha14 : string "                                        "
telaMeninaLinha15 : string "                                        "
telaMeninaLinha16 : string "                                        "
telaMeninaLinha17 : string "                                        "
telaMeninaLinha18 : string "                                        "
telaMeninaLinha19 : string "                                        "
telaMeninaLinha20 : string "                                  o     "
telaMeninaLinha21 : string "                                  :     "
telaMeninaLinha22 : string "                                  ]     "
telaMeninaLinha23 : string "                                        "
telaMeninaLinha24 : string "                                        "
telaMeninaLinha25 : string "                                        "
telaMeninaLinha26 : string "                                        "
telaMeninaLinha27 : string "                                        "
telaMeninaLinha28 : string "                                        "
telaMeninaLinha29 : string "                                        "

telaManualLinha0  : string "            MANUAL DO JOGO              "
telaManualLinha1  : string "                                        "
telaManualLinha2  : string "                                        "
telaManualLinha3  : string " OBJETIVO-> AJUDE O GATINHO A ENCONTRAR "
telaManualLinha4  : string " A MENINA NO FIM DO PERCURSO.           "
telaManualLinha5  : string "                                        "
telaManualLinha6  : string " CONTROLES->                            "
telaManualLinha7  : string "   -TECLA 'a'- SUBIR UMA LINHA          "
telaManualLinha8  : string "   -BARRA DE ESPACO- DESCER UMA LINHA   "
telaManualLinha9  : string "                                        "
telaManualLinha10 : string " REGRAS->                               "
telaManualLinha11 : string "   -O GATINHO SE MOVE AUTOMATICAMENTE   "
telaManualLinha12 : string " PARA A DIREItA;                        "
telaManualLinha13 : string "                                        "
telaManualLinha14 : string "   -EVITE OBSTACULOS PELO CAMINHO;      "
telaManualLinha15 : string " -AO ENCOSTAR EM UM OBSTACULO, O GATO   "
telaManualLinha16 : string "                                        "
telaManualLinha17 : string "                                        "
telaManualLinha18 : string " -SE TODAS AS VIDAS FOREM PERDIDAS      "
telaManualLinha19 : string "  O JOGO TERMINA.                       "
telaManualLinha20 : string "                                        "
telaManualLinha21 : string "                                        "
telaManualLinha22 : string "                                        "
telaManualLinha23 : string "                                        "
telaManualLinha24 : string "                                        "
telaManualLinha25 : string "                                        "
telaManualLinha26 : string "               BOA SORTE!               "
telaManualLinha27 : string "                                        "
telaManualLinha28 : string "                                        "
telaManualLinha29 : string "----------------------------------------"


telaManual2Linha0  : string "                                        "
telaManual2Linha1  : string "                                        "
telaManual2Linha2  : string "                                        "
telaManual2Linha3  : string "                                        "
telaManual2Linha4  : string "                                        "
telaManual2Linha5  : string "                                        "
telaManual2Linha6  : string "                                        "
telaManual2Linha7  : string "                                        "
telaManual2Linha8  : string "                                        "
telaManual2Linha9  : string "                                        "
telaManual2Linha10 : string " REGRAS->                               "
telaManual2Linha11 : string "   -O GATINHO SE MOVE AUTOMATICAMENTE   "
telaManual2Linha12 : string " PARA A DIREITA;                        "
telaManual2Linha13 : string "                                        "
telaManual2Linha14 : string "   -EVITE OBSTACULOS PELO CAMINHO;      "
telaManual2Linha15 : string " -AO ENCOSTAR EM UM OBSTACULO, O GATO   "
telaManual2Linha16 : string "  PERDE UMA VIDA                        "
telaManual2Linha17 : string " -AO ALCANCAR A MENINA, VOCE VENCE;     "
telaManual2Linha18 : string " -SE TODAS AS VIDAS FOREM PERDIDAS      "
telaManual2Linha19 : string "  O JOGO TERMINA.                       "
telaManual2Linha20 : string "                                        "
telaManual2Linha21 : string "                                        "
telaManual2Linha22 : string "                                        "
telaManual2Linha23 : string "                                        "
telaManual2Linha24 : string "                                        "
telaManual2Linha25 : string "                                        "
telaManual2Linha26 : string "                                        "
telaManual2Linha27 : string "                                        "
telaManual2Linha28 : string "                                        "
telaManual2Linha29 : string "----------------------------------------"

;tela game over
telaGameOverLinha0  : string "                                        "
telaGameOverLinha1  : string "                                        "
telaGameOverLinha2  : string "                                        "
telaGameOverLinha3  : string "                                        "
telaGameOverLinha4  : string "                                        "
telaGameOverLinha5  : string "  _______  _______  __   __  _______    "
telaGameOverLinha6  : string " |       ||   _   ||  |_|  ||       |   "
telaGameOverLinha7  : string " |    ___||  |_|  ||       ||    ___|   "
telaGameOverLinha8  : string " |   | __ |       ||       ||   |___    "
telaGameOverLinha9  : string " |   ||  ||       ||       ||    ___|   "
telaGameOverLinha10 : string " |   |_| ||   _   || ||_|| ||   |___    "
telaGameOverLinha11 : string " |_______||__| |__||_|   |_||_______|   "
telaGameOverLinha12 : string "  _______  __   __  _______  ______     "
telaGameOverLinha13 : string " |       ||  | |  ||       ||     _ |   "
telaGameOverLinha14 : string " |   _   ||  |_|  ||    ___||   | ||    "
telaGameOverLinha15 : string " |  | |  ||       ||   |___ |   |_||_   "
telaGameOverLinha16 : string " |  |_|  ||       ||    ___||    __  |  "
telaGameOverLinha17 : string " |       | |     | |   |___ |   |  | |  "
telaGameOverLinha18 : string " |_______|  |___|  |_______||___|  |_|  "
telaGameOverLinha19 : string "                                        "
telaGameOverLinha20 : string "         VOCE MATOU O GATINHO           "
telaGameOverLinha21 : string "                                        "
telaGameOverLinha22 : string "                                        "
telaGameOverLinha23 : string "     <APERTE ENTER PARA RECOMECAR>      "
telaGameOverLinha24 : string "                                        "
telaGameOverLinha25 : string "                                        "
telaGameOverLinha26 : string "                                        "
telaGameOverLinha27 : string "                                        "
telaGameOverLinha28 : string "                                        "
telaGameOverLinha29 : string "                                        "


;tela game over por gatinhos insuficientes
telaGameOverInsuficienteLinha0  : string "                                        "
telaGameOverInsuficienteLinha1  : string "                                        "
telaGameOverInsuficienteLinha2  : string "                                        "
telaGameOverInsuficienteLinha3  : string "                                        "
telaGameOverInsuficienteLinha4  : string "                                        "
telaGameOverInsuficienteLinha5  : string "  _______  _______  __   __  _______    "
telaGameOverInsuficienteLinha6  : string " |       ||   _   ||  |_|  ||       |   "
telaGameOverInsuficienteLinha7  : string " |    ___||  |_|  ||       ||    ___|   "
telaGameOverInsuficienteLinha8  : string " |   | __ |       ||       ||   |___    "
telaGameOverInsuficienteLinha9  : string " |   ||  ||       ||       ||    ___|   "
telaGameOverInsuficienteLinha10 : string " |   |_| ||   _   || ||_|| ||   |___    "
telaGameOverInsuficienteLinha11 : string " |_______||__| |__||_|   |_||_______|   "
telaGameOverInsuficienteLinha12 : string "  _______  __   __  _______  ______     "
telaGameOverInsuficienteLinha13 : string " |       ||  | |  ||       ||     _ |   "
telaGameOverInsuficienteLinha14 : string " |   _   ||  |_|  ||    ___||   | ||    "
telaGameOverInsuficienteLinha15 : string " |  | |  ||       ||   |___ |   |_||_   "
telaGameOverInsuficienteLinha16 : string " |  |_|  ||       ||    ___||    __  |  "
telaGameOverInsuficienteLinha17 : string " |       | |     | |   |___ |   |  | |  "
telaGameOverInsuficienteLinha18 : string " |_______|  |___|  |_______||___|  |_|  "
telaGameOverInsuficienteLinha19 : string "                                        "
telaGameOverInsuficienteLinha20 : string "                                        "
telaGameOverInsuficienteLinha21 : string "        VIDAS INSUFICIENTES             "
telaGameOverInsuficienteLinha22 : string "                                        "
telaGameOverInsuficienteLinha23 : string "                                        "
telaGameOverInsuficienteLinha24 : string "                                        "
telaGameOverInsuficienteLinha25 : string "     <APERTE ENTER PARA RECOMECAR>      "
telaGameOverInsuficienteLinha26 : string "                                        "
telaGameOverInsuficienteLinha27 : string "                                        "
telaGameOverInsuficienteLinha28 : string "                                        "
telaGameOverInsuficienteLinha29 : string "                                        "

# Função pow
## Convenção de chamada
       Registrador      Papel                Descrição       
       R0               Entrada/Saída        Base (entrada) · Resultado (saída) 
       R1               Entrada              Expoente (inteiro ≥ 0)
       R2               Interno              Acumulador do resultado
       R3               Interno              Constante 0 para comparação

Atenção: R2 e R3 são modificados pela sub-rotina. Se o chamador usar esses registradores, salve-os com PUSH antes do CALL e restaure com POP após.

## Lógica principal:
       CALL pow
       ↓
       Entrada
       R0 = base · R1 = expoente
       ↓
       Inicializa
       LOADN R2, 1 (resultado = 1)
       ↓
       loop: → CMP R1, R3
              R3 = 0 · R1 == 0 ?
              ↓ sim
              Fim do loop
              JMP igual → pow_end
              ↓
              Corpo do loop
              MUL R2, R2, R0 · DEC R1
              ↓ não
              ← (volta para loop)
       ↓
       pow_end:
       MOV R0, R2 (retorno em R0)
       ↓
       RTS

## pow:
       push R0
       push R1
       push R2
       push R3
       
       inchar R0
       inchar R1

       loadn R2, 1
       
       loop:
              cmp R1, R3
              jeq pow_end

              mul R2, R2, R0
              dec R1
              jmp loop

       pow_end:
              mov R0, R2

       pop R3
       pop R2
       pop R1
       pop R0
       
       rts


## Casos especiais:
       Situação                    Resultado                                     Motivo
       base^0                         1                               Loop não executa, retorna 1;
       0^expoente                     0                               Multiplica 1 por 0 repetidamente;
       1^expoente                     1                               Multiplica 1 por 1 repetidamente.

## Complexidade:
       Tempo: O(n) em relação ao expoente
       Espaço: O(1) — sem uso de pilha além do endereço de retorno do CALL

#Gatinho Vs. Ratão

  O jogo "Gatinho Vs. Ratão" foi desenvolvido na linguagem de programação Assembly, projetado para o processador ICMC. A versão disponível foi projetada na IDE do site: https://proc.giroto.dev.
  O projeto possui vídeo explicativo disponível no link:.
  Para um bom desempenho visual, é recomendado que se utilize o charmap modificado, disponível para download no repositório.

##Objetivo do jogo:
  O objetivo do jogo é controlar um gatinho que atravessa o cenário para encontrar uma menina localizada no lado direito da tela. Durante o percurso, o jogador deve evitar obstáculos espalhados pelo caminho. Caso o gatinho colida com um obstáculo, ele perde uma vida e retorna ao ponto inicial. Quando o gatinho alcança a menina, a fase é concluída e o jogador vence.

##Funcionamento Geral:
  O jogo é executado em um simulador Assembly e utiliza uma tela de 40 colunas por 30 linhas.
  ###Os elementos principais do jogo são:
    Gatinho (personagem controlado pelo jogador);
    Menina (objetivo final);
    Obstáculos (grama alta ou outros elementos);
    Sistema de vidas;
    Sistema de movimentação;
    Tela inicial;  
    Tela de vitória ou fim de jogo.
  ###Estrutura Inicial
    Quando o programa é iniciado:
    A tela inicial é exibida.
    O jogador pressiona Enter para começar.
    O cenário é desenhado.
    O gatinho aparece na extremidade esquerda.
    A menina aparece na extremidade direita.
    O laço principal do jogo começa.
    
  Visualmente:
  Gato --->                     Menina
  a ___________________________ :

##Sistema de Movimentação:
O gatinho se move automaticamente para a direita.
A cada ciclo do jogo: posição = posição + 1
Isso cria a sensação de caminhada contínua.
O jogador controla apenas a altura do personagem.

###Subir
  Ao pressionar uma tecla definida (por exemplo, a):
  a
  o gatinho sobe uma linha.
  Como cada linha possui 40 posições:
  novaPosição = posição - 40
  Exemplo:
  840 → 800

###Descer
  Ao pressionar Espaço:
  Espaço
  o gatinho desce uma linha.
  novaPosição = posição + 40
  Exemplo:
  800 → 840

###Sistema de Obstáculos
  No cenário existirão obstáculos fixos.
  Exemplo:
  _____M_____,M_______M__,__________
  Cada obstáculo possui uma posição específica na memória.
  Por exemplo:
  845
  851
  860
  Sempre que o gato se move, o programa verifica:
  posiçãoGato == posiçãoObstáculo ?
  Se a resposta for verdadeira:
  Uma vida é removida.
  O gato desaparece.
  O gato volta ao início.
  O jogo continua.

  Representação:
  a → M
  ####COLISÃO
  vidas = vidas - 1
  posição = início

###Sistema de Vidas
  O jogador começa com:
  vidas = 3
  Cada colisão faz:
  vidas = vidas - 1
  Quando:
  vidas = 0
  o jogo termina.

###Condição de Vitória
  A menina permanece parada no lado direito da tela.
  Exemplo:
  posiçãoMenina = 874
  Após cada movimento do gato, o programa verifica:
  posiçãoGato == posiçãoMenina ?
  Se verdadeiro:
  O gato é removido da tela.
  O programa verifica se a quantidade de vidas é maior ou igual à 4, se sim:
  A tela de vitória é exibida.
  Se não:
  A tela de derrota é exibida.
  O jogo termina.
  Representação:
  a → → → → → :

##Estrutura do Código
###O programa pode ser dividido em módulos.

####Variáveis
  Armazenam:
  posGato
  posMenina
  vidas
  fase
  
####Tela Inicial
  Responsável por:
  Exibir o título;
  Esperar o Enter.
  call ImprimeTela
  
####Desenho do Cenário
  Responsável por:
  Grama;
  Árvore;
  Obstáculos.
  call ImprimeTela2

####DesenhaGato
  Desenha o gato na posição atual.
  
####DesenhaMenina
  Desenha a menina.


####Função principal do jogo.
  Responsável por:
  Apagar o gato antigo;
  Atualizar posição;
  Verificar colisões;
  Verificar vitória;
  Desenhar novamente.

###Fluxo:

Apaga
↓
Move
↓
Verifica obstáculo
↓
Verifica menina
↓
Desenha
Colisão
cmp posição, obstáculo
jeq Morreu
Vitória
cmp posição, posMenina
jeq Venceu

###Fluxograma Geral
INÍCIO
   |
   V
Tela Inicial
   |
Enter
   |
   V
Manual
   |
Enter
   |
   V
Desenha Cenário
   |
   V
Loop Principal
   |
   +--> Ler Tecla
   |
   +--> Subir?
   |
   +--> Descer?
   |
   +--> Mover Gato
   |
   +--> Colidiu?
   |        |
   |       Sim
   |        |
   |    Perde Vida
   |        |
   |        +-->Vida igual à zero?
   |                   |
   |        Sim-------------------Não         
   |         |                     |
   |     Game Over            Volta Início
   |
   +--> Encontrou Menina?
            |
           Sim
            +-->Vida maior ou igual à 4?
                          |
            Sim----------------------Não
            |                         |
         Vitória                   Game Over
            |
           Fim
           
###Conceitos de Assembly Utilizados
load: Carrega um valor para um registrador.
load r0, posGato

store: Salva um valor na memória.
store posGato, r0

cmp: Compara dois valores.
cmp r0, r1

jeq: Salta caso sejam iguais.
jeq Morreu
Significa:
Se forem iguais, vá para Morreu

jmp: Salto incondicional.
jmp Loop
Significa:
Vá para Loop

call: Chama uma sub-rotina.
call MoveGato
Significa:
Execute MoveGato

rts: Retorna da sub-rotina.
rts
Significa:
Volte para quem chamou

halt: Finaliza a execução.
halt
Significa:
Encerrar o programa

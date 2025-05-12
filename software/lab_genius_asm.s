#.section .text

#.global genius_game

# .equ GAME_MODE   , (1 << 0)                      # Bit 0 = 1 (modo mando eu)
# .equ SPEED_GAME  , (0 << 1)                      # Bit 1 = 0 (velocidade lenta)
# .equ DIFFICULTY  , (0 << 2) | (0 << 3)           # Bits 2 e 3 = 00 (fácil)
# .equ START_BIT   , (0 << 4)                      # Bit 4 = 0 (start pressionado)
.equ START_BIT,      0b00000000                    # Bit 4 = 0 (start pressionado
# .equ SEED

genius_game:

ST_IDLE:                             # Estado inicial de configurações etc

    li   s0,  0b0000                 # Modo = Siga (bit0 = 0), Velocidade = Lenta (bit1 = 0) Dificuldade = (bit2 e 3 = 0)  
    li   t0,  START_BIT
    
    beqz t0,  ST_GEN                 # Se start pressionado, vai para o estado de gerar a sequência
    j         ST_IDLE                # Se não, continua no estado de idle

ST_GEN:

    li     s1, 0                     # s1: led_sequence_reg1 vai armazenar os 16 bits gerados (cores
    li     t3, 0                     # contador de quantas iterações já fizemos
    li     s4, 8                     # s4: Sequence_size (define o tamanho da sequência de acordo com o nível de dificuldade)	

prng_generation:
    
    # Gera um número (aleatório) para inserir na sequência
    addi   t1, t1, 3 #(Seed)         # Seed temporária (substituir por lógica adequada)
    andi   t2, t1, 0b11              # Mascara para obter 2 bits (0-3)

    slli   t4, t3, 1                 # Desloca os dois bits para esquerda
    sll    t5, t2, t4                # Desloca os bits da nova cor para a posição atual
    or     s1, s1, t5                # Adiciona ao registrador s1
    addi   t3, t3, 1  
    
    j      ST_SHOW_LEDS              # Vai mostrar o LED atual

aval_sec_size:                        # incrementa contagem de geração aleatória
    
    blt    t3, s4, prng_generation   # Avalia se sequência foi concluida (8 fácil, 16 médio, 32 dificil)
    j      VICTORY

ST_SHOW_LEDS:
    
    # bnez s3, show_color              # Necessário para manter somente 1 bit enable acionado por vez
    # addi s3, s3, 1                   # Aciona o bit enable para ser possível visualizar o LED no jogo

show_color:
    
    # Extrai os 2 bits da cor atual (t2) e mapeia para 4 bits em s7
    
    li   s7, 0                   # Reseta s7 (Apaga todos os leds)
    li   s6, 0                   # Desabilita pino (Enable LED)

    # Verifica qual cor está em t2 e configura os bits correspondentes
    
    beqz t2,     set_blue        # Se cor = 00 (Blue)
    li   t5, 1
    beq  t2, t5, set_green       # Se cor = 01 (Green)
    li   t5, 2
    beq  t2, t5, set_yellow      # Se cor = 10 (Yellow)
    li   t5, 3
    beq  t2, t5, set_red         # Se cor = 11 (Red)
    
set_green:
    ori  s7, s7, 0b0001          # Verde      [1:0] = 01 -> saída 0001 (bit 0)
    li   s6, 1                   # Enable_Led

    slli s3, s3, 1               # Rotação a esquerda de um bit
    addi s3, s3, 1               # Insere um novo bit para indicar que mais uma cor foi inserida na sequência

    j    ST_PLAYER_INPUT

set_blue:
    ori  s7, s7, 0b0010          # Azul       [2:1] = 00 -> saída 0010 (bit 1)
    li   s6, 1                   # Enable_Led

    slli s3, s3, 1               # Rotação a esquerda de um bit
    addi s3, s3, 1               # Insere um novo bit para indicar que mais uma cor foi inserida na sequência

    j    ST_PLAYER_INPUT

set_red:
    ori  s7, s7, 0b0100          # Vermelho   [3:2] = 11 -> saída 0100 (bit 2)
    li   s6, 1                   # Enable_Led

    slli s3, s3, 1               # Rotação a esquerda de um bit
    addi s3, s3, 1               # Insere um novo bit para indicar que mais uma cor foi inserida na sequência

    j    ST_PLAYER_INPUT

set_yellow:
    ori  s7, s7, 0b1000          # Amarelo    [4:3] = 10 -> saída 1000 (bit 3)
    li   s6, 1                   # Enable_Led

    #andi s6, s6, delay_led

    slli s3, s3, 1               # Rotação a esquerda de um bit
    addi s3, s3, 1               # Insere um novo bit para indicar que mais uma cor foi inserida na sequência

    j    ST_PLAYER_INPUT


#delay_led:                       # ADAPTAR O TEMPO DO LED DE ACORDO COM A VELOCIDADE (2s lento, 1s rápido)
    
#    li t1, 2000

#    addi t0, t0, 1  
#    blt  t0, t1, delay_led 


ST_PLAYER_INPUT:

    # Simula a entrada com base no contador s2 (0-3)
    beqz  s5, input_red              # Jogada 1: Vermelho (11)
    li    t0, 1
    beq   s5, t0, input_yellow       # Jogada 2: Amarelo (10)
    li    t0, 2
    beq   s5, t0, input_green        # Jogada 3: Verde (00)
    li    t0, 3
    beq   s5, t0, input_blue         # Jogada 4: Azul (01)
    li    t0, 4
    beq   s5, t0, input_red          # Jogada 5: Vermelho (11)
    li    t0, 5
    beq   s5, t0, input_yellow       # Jogada 6: Amarelo (10)
    li    t0, 6
    beq   s5, t0, input_green        # Jogada 7: Azul (00)
    li    t0, 7
    beq   s5, t0, input_blue         # Jogada 8: Verde (01)
    li    t0, 8
    j     DEFEAT                     # Entrada inválida

input_red:
    li    t5, 0b11                   # Vermelho
    addi  s5, s5, 1                  
    j     ST_EVALUATE

input_yellow:
    li    t5, 0b10                   # Amarelo
    addi  s5, s5, 1
    j     ST_EVALUATE

input_blue:
    li    t5, 0b00                   # Azul
    addi  s5, s5, 1
    j     ST_EVALUATE

input_green:
    li    t5, 0b01                   # Verde
    addi  s5, s5, 1
    j     ST_EVALUATE


  # li    t5, 0b11                    # Simula apertar o vermelho (11) - CORRETO 
  # li    t5, 0b01                    # Simula apertar o verde    (01) - INCORRETO
  # li    s4, 0                       # Simula uma sequência de apenas um led (para teste)
  #  j    ST_EVALUATE
    

ST_ADD_COLOR: # Label a ser utilizada no modo mando eu



ST_EVALUATE:
   
    # implementar verificação de modo de jogo (mando eu ou siga eu) 
    
    bne   t5, t2, DEFEAT              # Entrada errada → derrota

    # Atualiza contador e verifica fim da sequência
    addi  t5, t6, 1                   # Próxima posição
    beq   t6, s4, VICTORY             # Se todas entradas corretas → vitória
    j     aval_sec_size               # Repete para próxima entrada

   #slli s3, s3, 1   Habilita próximo led se o jogador acertar a jogada

VICTORY: 
    li s6, 2 # configura o led de vitória
    j ST_IDLE 

DEFEAT: 
    li s6, 2 # configura o led de derrota
    j ST_IDLE 

    ret    # Usado em conjunto com o main
    
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

###### Definindo condição inicial dos registradores #####  (Caso seja iniciado um novo jogo)
 
    li s1, 0
    li s2, 0
    li s3, 0
    li s4, 0
    li s5, 0
    li s6, 0
    li s7, 0

###### Configurações do Game #####

    li     s0,  0b0000                 # Modo = Siga (bit0 = 0), Velocidade = Lenta (bit1 = 0) Dificuldade = (bit2 e 3 = 0)  

###### Aguarda START para iniciar o jogo #####

    li     t0,  START_BIT              # Aguarda botão START ser pressionado

    # addi t1,  t1, 1 #(Seed)        # Seed temporária (substituir por lógica adequada)

    beqz   t0,  ST_GEN                 # Se start pressionado, vai para o estado de gerar a sequência
    j           ST_IDLE                # Se não, continua no estado de idle

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

    addi   s3, s3, 1 
    

ST_SHOW_LEDS:
      
    li   s7, 0                           # Reseta s7 (Apaga todos os leds)
    li   s6, 0                           # Desabilita pino (Enable LED) 
   
    blt  t0, s3, ADD_LED                 # Verifica se ainda há cores para mostrar
    j            ST_PLAYER_INPUT         # Quando terminar, vai para entrada do jogador
    
ADD_LED:
    
    addi t2, s1, 0                       # Copia o registrador s1 para o t2
    sll  t2, s1, t0                      # Rotaciona os bits de acordo com t0
    andi t2, t2, 0b11                    # Aplica a máscara ao conjunto de bits
    addi t0, t0, 1                       # Incrementa contador de posição

    # Verifica qual cor está em t2 e configura os bits correspondentes

    beqz t2,     SHOW_BLUE_LED        # Se cor = 00 (Blue)
    li   t5, 1
    beq  t2, t5, SHOW_GREEN_LED       # Se cor = 01 (Green)
    li   t5, 2
    beq  t2, t5, SHOW_YELLOW_LED      # Se cor = 10 (Yellow)
    li   t5, 3
    beq  t2, t5, SHOW_RED_LED         # Se cor = 11 (Red)
    

SHOW_GREEN_LED:
    
    ori  s7, s7, 0b0001              # Verde [1:0] = 01 -> saída 0001 (bit 0)
    li   s6, 1                       # Enable_Led
    j    ST_SHOW_LEDS                # Vai para o estado de mostrar os leds


SHOW_BLUE_LED:

    ori  s7, s7, 0b0010              # Azul [2:1] = 00 -> saída 0010 (bit 1)
    li   s6, 1                       # Enable_Led
    j    ST_SHOW_LEDS                # Vai para o estado de mostrar os leds


SHOW_RED_LED:

    ori  s7, s7, 0b0100              # Vermelho [3:2] = 11 -> saída 0100 (bit 2)
    li   s6, 1                       # Enable_Led
    j    ST_SHOW_LEDS                # Vai para o estado de mostrar os leds


SHOW_YELLOW_LED:

    ori  s7, s7, 0b1000              # Amarelo [4:3] = 10 -> saída 1000 (bit 3)
    li   s6, 1                       # Enable_Led
    j    ST_SHOW_LEDS                # Vai para o estado de mostrar os leds
 

#DELAY_LED:                      # ADAPTAR O TEMPO DO LED DE ACORDO COM A VELOCIDADE (2s lento, 1s rápido)
    
#    li t1, 2000

#    addi t0, t0, 1  
#    blt  t0, t1, delay_led 

#reset_t0:

#li t0, 0
#li s5, 0

ST_PLAYER_INPUT:

    li    t0, 0
    li    s5, 0
    li    t5, 0b11                   # Simula apertar o vermelho (11) - CORRETO 

    # Simula a entrada do jogador (Implementar no simulador futuramente)

    beqz  s5,     INPUT_RED          # Jogada 1: Vermelho (11)
    li    t0, 1
    beq   s5, t0, INPUT_YELLOW       # Jogada 2: Amarelo (10)
    li    t0, 2
    beq   s5, t0, INPUT_GREEN        # Jogada 3: Verde (00)
    li    t0, 3
    beq   s5, t0, INPUT_BLUE         # Jogada 4: Azul (01)
    li    t0, 4
    beq   s5, t0, INPUT_RED          # Jogada 5: Vermelho (11)
    li    t0, 5
    beq   s5, t0, INPUT_YELLOW       # Jogada 6: Amarelo (10)
    li    t0, 6
    beq   s5, t0, INPUT_GREEN        # Jogada 7: Azul (00)
    li    t0, 7
    beq   s5, t0, INPUT_GREEN        # Jogada 8: Verde (01)
    li    t0, 8
    j     DEFEAT                     # Entrada inválida


# Aciona a saída do respectivo LED

INPUT_RED:

    li    t5, 0b11                   # Seta cor Vermelha
    addi  s5, s5, 1                  # Registra jogada do jogador
    j     ST_EVALUATE                # Vai para o estado de avaliar Vitória ou derrota

INPUT_YELLOW:

    li    t5, 0b10                   # Seta cor Amarela
    addi  s5, s5, 1                  # Registra a jogada do player
    j     ST_EVALUATE                # Vai para o estado de avaliar Vitória ou derrota

INPUT_BLUE:

    li    t5, 0b00                   # Seta cor Azul
    addi  s5, s5, 1                  # Registra a jogada do player
    j     ST_EVALUATE                # Vai para o estado de avaliar Vitória ou derrota

INPUT_GREEN:

    li    t5, 0b01                   # Seta cor Verde
    addi  s5, s5, 1                  # Registra a jogada do player
    j     ST_EVALUATE                # Vai para o estado de avaliar Vitória ou derrota


ST_ADD_COLOR: # Label a ser utilizada no modo mando eu



ST_EVALUATE:
   
    # implementar verificação de modo de jogo (mando eu ou siga eu) 
    
    addi t2, s1, 0                            # Copia o registrador s1 para o t2
    sll  t2, s1, t0                           # Rotaciona os bits de acordo com t0
    andi t2, t2, 0b11                         # Aplica a máscara ao conjunto de bits

    beq   t5, t2, ST_INPUT_PLAYER_OR_PRNG     # Entrada errada → derrota
  # bne   t5, t2, ST_END #DEFEAT             # Entrada errada → derrota
  # blt   t3, s4, prng_generation             # Avalia se sequência foi concluida (8 fácil, 16 médio, 32 dificil)
  # j     VICTORY
    j     ST_END


ST_INPUT_PLAYER_OR_PRNG:

   beq s5, s3, prng_generation
   j   ST_PLAYER_INPUT

ST_END:

bne   t5, t2, DEFEAT  

VICTORY: 
    li s6, 2 # configura o led de vitória
    j ST_IDLE 

DEFEAT: 
    li s6, 2 # configura o led de derrota
    j ST_IDLE 

    ret    # Usado em conjunto com o main
    
#.section .text

#.global genius_game

# .equ GAME_MODE   , (1 << 0)                      # Bit 0 = 1 (modo mando eu)
# .equ SPEED_GAME  , (0 << 1)                      # Bit 1 = 0 (velocidade lenta)
# .equ DIFFICULTY  , (0 << 2) | (0 << 3)           # Bits 2 e 3 = 00 (fácil)
# .equ START_BIT   , (0 << 4)                      # Bit 4 = 0 (start pressionado)
.equ START_BIT,      0b00000000                    # Bit 4 = 0 (start pressionado
# .equ SEED

genius_game:

ST_IDLE:                      # Estado inicial de configurações etc

    li   s0,  0b0000          # Modo = Siga (bit0 = 0), Velocidade = Lenta (bit1 = 0) Dificuldade = (bit2 e 3 = 0)  
    li   t0,  START_BIT
    
    beqz t0,  ST_GEN          # Se start pressionado, vai para o estado de gerar a sequência
    j         ST_IDLE         # Se não, continua no estado de idle

ST_GEN:

    li     s1, 0            # s1: led_sequence_reg1 vai armazenar os 16 bits gerados (cores
    li     t3, 0            # contador de quantas iterações já fizemos
    li     s4, 8            # s4: Sequence_size (define o tamanho da sequência de acordo com o nível de dificuldade)	

prng_generation:
    
    # Gera um número (aleatório) para inserir na sequência
    addi   t1, t1, 3                # Seed temporária (substituir por lógica adequada)
    andi   t2, t1, 0b11             # Mascara para obter 2 bits (0-3)

    slli   t4, t3, 1                # Desloca os dois bits para esquerda
    sll    t5, t2, t4               # Desloca os bits da nova cor para a posição atual
    or     s1, s1, t5               # Adiciona ao registrador s1
    addi   t3, t3, 1  
    
    j      ST_SHOW_LEDS             # Vai mostrar o LED atual

inc_prng_sec:
    # incrementa contagem de geração aleatória
    blt    t3, s4, prng_generation    # s4 tamanho da sequência (8 fácil, 16 médio, 32 dificil)
    
ST_SHOW_LEDS:
    
    bnez s3, show_color            # Necessário para manter somente 1 bit enable acionado por vez
    addi s3, s3, 1                 # Aciona o bit enable para ser possível visualizar o LED no jogo

show_color:
    
    # Extrai os 2 bits da cor atual (t2) e mapeia para 4 bits em s7
    li   s7, 0                   # Reseta s7
    
    # Verifica qual cor está em t2 e configura os bits correspondentes
    beqz t2,     set_blue        # Se cor = 00 (Blue)
    li   t5, 1
    beq  t2, t5, set_green       # Se cor = 01 (Green)
    li   t5, 2
    beq  t2, t5, set_yellow      # Se cor = 10 (Yellow)
    li   t5, 3
    beq  t2, t5, set_red         # Se cor = 11 (Red)
    j            end_mapping

set_green:
    ori  s7, s7, 0b0001          # Green: bits  [1:0] = 01 -> saída 0001 (bit 0)
    j    end_mapping

set_blue:
    ori  s7, s7, 0b0010          # Blue: bits   [2:1] = 00 -> saída 0010 (bit 1)
    j    end_mapping

set_red:
    ori  s7, s7, 0b0100          # Red: bits    [3:2] = 11 -> saída 0100 (bit 2)

set_yellow:
    ori  s7, s7, 0b1000          # Yellow: bits [4:3] = 10 -> saída 1000 (bit 3)
    j    end_mapping


    
end_mapping:

    
    j inc_prng_sec



ST_PLAYER_INPUT:


ST_ADD_COLOR: # Para o modo mando eu


ST_EVALUATE:

   #slli s3, s3, 1   Habilita próximo led se o jogador acertar a jogada

VICTORY: 
    li s6, 2 # configura o led de vitória
    j ST_IDLE 

DEFEAT: 
    li s6, 2 # configura o led de derrota
    j ST_IDLE 



#    lw t1, 0(a0)  
#    lw t2, 0(a1)

#    add t0, t1, t2

#    sw t0, 0(a2)

    ret    
    
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

seed_generation:
    
    # Gera um número (aleatório) para inserir na sequência
    addi   t1, t1, 3                # Seed temporária (substituir por lógica adequada)
    andi   t2, t1, 0b11             # Mascara para obter 2 bits (0-3)

    slli   t4, t3, 1                # Desloca os dois bits para esquerda
    sll    t5, t2, t4               # Desloca os bits da nova cor para a posição atual
    or     s1, s1, t5               # Adiciona ao registrador s1
    addi   t3, t3, 1  
    j      ST_SHOW_LEDS             # Vai mostrar o LED atual

inc_seed:
    # incrementa contagem de geração aleatória
    blt    t3, s4, seed_generation    # s4 tamanho da sequência (8 fácil, 16 médio, 32 dificil)
    
ST_SHOW_LEDS:
    
    bnez s3, show_color
    addi s3, s3, 1
    j    seed_generation
    # CONTINUAR IMPLEMENTANDO A ROTINA DE MOSTRAR AS CORES
show_color:
    
    slli s3, s3, 1            # Habilita a posição correspondente ao LED a ser acesso no momento
  
    j inc_seed



ST_PLAYER_INPUT:


ST_ADD_COLOR: # Para o modo mando eu


ST_EVALUATE:


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
    
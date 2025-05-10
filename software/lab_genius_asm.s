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
    addi   t1, t1, 1                  # SUBSTITUIR O 2 POR UM CONTADOR VINCULADO AO TEMPO DO BOTÃO START
    andi   t2, t1, 0b11               # Apenas 2 bits (valores entre 0–3)
 
    # Inserie o número (aleatório) na sequência
    slli   s1, s1, 2                  # desloca s1 dois bits à esquerda para encaixar novo par
    or     s1, s1, t2                 # insere os 2 bits gerados no final de s1
    
    J      ST_SHOW_LEDS                # vai para o estado de mostrar os LEDs

inc_seed:
    # incrementa contagem de geração aleatória
    addi   t3, t3, 1                  # incrementa contador
    blt    t3, s4, seed_generation    # s4 tamanho da sequência (8 fácil, 16 médio, 32 dificil)
    
ST_SHOW_LEDS:
    
    # CONTINUAR IMPLEMENTANDO A ROTINA DE MOSTRAR AS CORES
    addi t5, s1, 0
    li t6, 1
    slli s3, t6, 0            # incrementa contador de LEDs
    addi t6, t6, 1
    #sll t5, s1, 2
    #
    #
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
    
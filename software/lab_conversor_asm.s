.section .text
.global sum
# Flag do bit (0 ou 1) << posição do bit que deseja alterar [31:0]

.equ GAME_MODE   , (1 << 0)                      # Bit 0 = 1 (modo mando eu)
.equ SPEED_GAME  , (0 << 1)                      # Bit 1 = 0 (velocidade lenta)
.equ DIFFICULTY  , (0 << 2) | (0 << 3)           # Bits 2 e 3 = 00 (fácil)
.equ START_BIT   , (1 << 4)                      # Bit 4 = 1 (start não pressionado)

sum:
    li s0, 0

    ori s0, s0, GAME_MODE
    ori s0, s0, SPEED_GAME
    ori s0, s0, DIFFICULTY
    ori s0, s0, START_BIT

    # Aqui você pode usar s0 em outras partes do código da função sum
    sw s0, 0(a2)

    ret

# ============================================================
# STAGE 16.13 - PRIME NUMBER DETECTION
# PART 2
#
# Tests:
#
#   7  -> PRIME
#   10 -> NOT PRIME
#   13 -> PRIME
#   15 -> NOT PRIME
#
# Results:
#
#   MEM[16] = 1
#   MEM[20] = 0
#   MEM[24] = 1
#   MEM[28] = 0
#
# ============================================================


# ============================================================
# TEST 7
# Check divisibility by 2
# ============================================================

# PC 0
ADDI x1, x0, 7

# PC 4
ADDI x2, x0, 2

# PC 8
ADDI x3, x0, 1

# PC 12
ADD x4, x1, x0

# PC 16
SUB x4, x4, x2

# PC 20
BEQ x4, x0, 20

# PC 24
BLT x4, x0, 8

# PC 28
JAL x0, -12

# PC 32 - PRIME
SW x3, 16(x0)

# PC 36
JAL x0, 16

# PC 40 - NOT PRIME
ADDI x3, x0, 0

# PC 44
SW x3, 16(x0)

# PC 48
JAL x0, 4


# ============================================================
# TEST 10
# Check divisibility by 2
# ============================================================

# PC 52
ADDI x1, x0, 10

# PC 56
ADDI x2, x0, 2

# PC 60
ADDI x3, x0, 1

# PC 64
ADD x4, x1, x0

# PC 68
SUB x4, x4, x2

# PC 72
BEQ x4, x0, 20

# PC 76
BLT x4, x0, 8

# PC 80
JAL x0, -12

# PC 84 - PRIME
SW x3, 20(x0)

# PC 88
JAL x0, 16

# PC 92 - NOT PRIME
ADDI x3, x0, 0

# PC 96
SW x3, 20(x0)

# PC 100
JAL x0, 4


# ============================================================
# TEST 13
# Check divisibility by 2
# ============================================================

# PC 104
ADDI x1, x0, 13

# PC 108
ADDI x2, x0, 2

# PC 112
ADDI x3, x0, 1

# PC 116
ADD x4, x1, x0

# PC 120
SUB x4, x4, x2

# PC 124
BEQ x4, x0, 20

# PC 128
BLT x4, x0, 8

# PC 132
JAL x0, -12

# PC 136 - PRIME
SW x3, 24(x0)

# PC 140
JAL x0, 16

# PC 144 - NOT PRIME
ADDI x3, x0, 0

# PC 148
SW x3, 24(x0)

# PC 152
JAL x0, 4


# ============================================================
# TEST 15
# Check divisibility by 3
# ============================================================

# PC 156
ADDI x1, x0, 15

# PC 160
ADDI x2, x0, 3

# PC 164
ADDI x3, x0, 1

# PC 168
ADD x4, x1, x0

# PC 172
SUB x4, x4, x2

# PC 176
BEQ x4, x0, 20

# PC 180
BLT x4, x0, 8

# PC 184
JAL x0, -12

# PC 188 - PRIME
SW x3, 28(x0)

# PC 192
JAL x0, 16

# PC 196 - NOT PRIME
ADDI x3, x0, 0

# PC 200
SW x3, 28(x0)

# PC 204
JAL x0, 4


# ============================================================
# END
# ============================================================

# PC 208
JAL x0, 4
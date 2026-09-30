# ============================================================
# STAGE 16.4 - CONDITIONAL DECISION PROGRAM
# ============================================================

# ------------------------------------------------------------
# Test condition:
#
# x1 = 10
# x2 = 20
#
# if x1 < x2:
#     x3 = x1 + x2
#
# Expected:
# x3 = 30
# ------------------------------------------------------------

ADDI x1, x0, 10
ADDI x2, x0, 20

BLT x1, x2, 12

# This instruction must be skipped
SUB x3, x1, x2

# Jump over second test
JAL x0, 8

# True branch
ADD x3, x1, x2

# ------------------------------------------------------------
# Second decision:
#
# x4 = 20
# x5 = 10
#
# if x4 >= x5:
#     x6 = x4 - x5
#
# Expected:
# x6 = 10
# ------------------------------------------------------------

ADDI x4, x0, 20
ADDI x5, x0, 10

BGE x4, x5, 8

# This instruction must be skipped
ADD x6, x4, x5

# True branch
SUB x6, x4, x5
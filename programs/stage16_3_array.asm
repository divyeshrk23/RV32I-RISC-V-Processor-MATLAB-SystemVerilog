# ============================================================
# STAGE 16.3 - ARRAY + MEMORY PROCESSING
# ============================================================

# Memory layout:
#
# Address 0  = 10
# Address 4  = 20
# Address 8  = 30
# Address 12 = 40
#
# Final result:
# Address 16 = 100
#
# Registers:
# x1 = current memory address
# x2 = loop counter
# x3 = accumulated sum
# x4 = loaded value
# x5 = loop limit

# Initialize
ADDI x1, x0, 0
ADDI x2, x0, 0
ADDI x3, x0, 0
ADDI x5, x0, 4

# ------------------------------------------------------------
# ARRAY LOOP
# ------------------------------------------------------------

LW x4, 0(x1)
ADD x3, x3, x4

ADDI x1, x1, 4
ADDI x2, x2, 1

BLT x2, x5, -16

# ------------------------------------------------------------
# Store final sum
# Address 16 = 100
# ------------------------------------------------------------

SW x3, 16(x0)
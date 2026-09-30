# ============================================================
# STAGE 15.2 ASSEMBLY FILE TEST
# ============================================================

# Load values
ADDI x1, x0, 10

ADDI x2, x0, 20       # Load 20 into x2

# Arithmetic
ADD x3, x1, x2
SUB x4, x3, x1

# Logical operations
AND x5, x1, x2
OR x6, x1, x2
XOR x7, x1, x2

# End of test

# ============================================================
# STAGE 16.1 - ARITHMETIC INTEGRATION PROGRAM
# ============================================================

# Load initial values
ADDI x1, x0, 50
ADDI x2, x0, 20

# Arithmetic operations
ADD x3, x1, x2
SUB x4, x1, x2

# Logical operations
AND x5, x1, x2
OR x6, x1, x2
XOR x7, x1, x2

# More dependent calculations
ADD x8, x3, x4
SUB x9, x3, x4
AND x10, x3, x4
OR x11, x3, x4
XOR x12, x3, x4
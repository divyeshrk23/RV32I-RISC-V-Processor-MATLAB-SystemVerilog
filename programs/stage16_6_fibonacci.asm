# ============================================================
# STAGE 16.6 - FIBONACCI INTEGRATION PROGRAM
# ============================================================

# ------------------------------------------------------------
# Registers
#
# x1 = previous Fibonacci value
# x2 = current Fibonacci value
# x3 = next Fibonacci value
# x4 = loop counter
# x5 = loop limit
# ------------------------------------------------------------

# F(0) = 0
ADDI x1, x0, 0

# F(1) = 1
ADDI x2, x0, 1

# Counter = 1
ADDI x4, x0, 1

# Calculate through F(7)
ADDI x5, x0, 7


# ============================================================
# FIBONACCI LOOP
# ============================================================

# x3 = x1 + x2
ADD x3, x1, x2

# x1 = old x2
ADD x1, x2, x0

# x2 = new Fibonacci value
ADD x2, x3, x0

# counter++
ADDI x4, x4, 1

# Continue while counter < 7
BLT x4, x5, -16


# ============================================================
# FINAL RESULT
# ============================================================
#
# Expected:
#
# x1 = 8
# x2 = 13
# x3 = 13
# x4 = 7
# x5 = 7
#
# Therefore:
# F(7) = 13
# ============================================================
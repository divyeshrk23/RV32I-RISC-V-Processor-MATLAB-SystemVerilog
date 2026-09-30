# ============================================================
# STAGE 16.9 - ARRAY MAXIMUM + MINIMUM
# ============================================================

# Memory:
#
# MEM[0]  = 25
# MEM[4]  = 7
# MEM[8]  = 42
# MEM[12] = 18
# MEM[16] = 33
#
# Expected:
#
# Maximum = 42
# Minimum = 7
#
# x3 = maximum
# x4 = minimum
#
# MEM[24] = maximum
# MEM[28] = minimum
# ============================================================


# ============================================================
# INITIALIZATION
# ============================================================

# x1 = array pointer
ADDI x1, x0, 0

# x2 = number of elements
ADDI x2, x0, 5

# Load first element
LW x3, 0(x1)

# Initial minimum = first element
ADD x4, x3, x0

# Move pointer to second element
ADDI x1, x1, 4

# Remaining elements = 4
ADDI x2, x2, -1


# ============================================================
# LOOP
# ============================================================

# Load current element
LW x5, 0(x1)

# ------------------------------------------------------------
# Check maximum
# ------------------------------------------------------------

# If current < maximum, skip maximum update
BLT x5, x3, 8

# Current becomes maximum
ADD x3, x5, x0


# ------------------------------------------------------------
# Check minimum
# ------------------------------------------------------------

# If minimum < current, skip minimum update
BLT x4, x5, 8

# Current becomes minimum
ADD x4, x5, x0


# ------------------------------------------------------------
# Next element
# ------------------------------------------------------------

ADDI x1, x1, 4

ADDI x2, x2, -1

# Continue while counter != 0
BNE x2, x0, -28


# ============================================================
# STORE RESULTS
# ============================================================

# Store maximum
SW x3, 24(x0)

# Store minimum
SW x4, 28(x0)


# ============================================================
# END
# ============================================================

JAL x0, 20
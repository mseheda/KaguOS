#############################################
#############################################
# Instruction set constants:
#############################################

# To execute a CPU operation, set the operation code in REG_OP and call INSTR_CPU_EXEC.
# The CPU will use REG_A, REG_B, REG_C and REG_D values(depending on the operation).
# The result will be stored in either REG_RES or REG_BOOL_RES.
# Also REG_ERROR can be used to store information about errors.
export INSTR_CPU_EXEC=0

# To copy data from a source address to a destination address.
# Example: 1 100 200 will copy the content of RAM address 100 to address 200.
export INSTR_COPY_FROM_TO_ADDRESS=1

# To read data from a specific memory address, set the address in REG_A.
# Call INSTR_READ_FROM_ADDRESS and the data will be stored in REG_RES.
export INSTR_READ_FROM_ADDRESS=2

# To jump unconditionally to a specific address specify target address a an argument of the instruction.
# Call INSTR_JUMP to transfer control to the target address.
# Example: jump 100 will jump to address 100 and will use 100 as a PROGRAM_COUNTER so all further instruction will be executed started from address 100
export INSTR_JUMP=3

# To jump conditionally, perform conditional check to ensuset the target address in REG_A and the condition in REG_B.
# Call INSTR_JUMP_IF to transfer control only if the condition is true e.g. REG_BOOL_RES is 1.
# Example: jump_if 100 will jump to address 100 if REG_BOOL_RES is equal to 1 otherwise jump_if instruction will be ignored and the next instruction will be run.
export INSTR_JUMP_IF=4

#############################################
#############################################
# Operations from CPU instruction set.
# For each operation, set the required operands in REG_A, REG_B, REG_C, or REG_D, set REG_OP, and call INSTR_CPU_EXEC.
#############################################

# To perform addition, place the first operand in REG_A and the second operand in REG_B.
# Set REG_OP to OP_ADD and call INSTR_CPU_EXEC.
# After execution, the sum of the values will be present in REG_RES.
export OP_ADD=0

# To perform subtraction, place the minuend in REG_A and the subtrahend in REG_B.
# Set REG_OP to OP_SUB and call INSTR_CPU_EXEC.
# After execution, the difference will be present in REG_RES.
export OP_SUB=1

# To increment a value, place the operand in REG_A.
# Set REG_OP to OP_INCR and call INSTR_CPU_EXEC.
# After execution, the incremented value will be present in REG_RES.
export OP_INCR=2

# To decrement a value, place the operand in REG_A.
# Set REG_OP to OP_DECR and call INSTR_CPU_EXEC.
# After execution, the decremented value will be present in REG_RES.
export OP_DECR=3

# To perform division, place the dividend in REG_A and the divisor in REG_B.
# Set REG_OP to OP_DIV and call INSTR_CPU_EXEC.
# After execution, the quotient will be present in REG_RES.
export OP_DIV=4

# To perform modulo operation, place the dividend in REG_A and the divisor in REG_B.
# Set REG_OP to OP_MOD and call INSTR_CPU_EXEC.
# After execution, the remainder will be present in REG_RES.
export OP_MOD=5

# To perform multiplication, place the first operand in REG_A and the second operand in REG_B.
# Set REG_OP to OP_MUL and call INSTR_CPU_EXEC.
# After execution, the product will be present in REG_RES.
export OP_MUL=6

# To check if a value is a number, place the value in REG_A.
# Set REG_OP to OP_IS_NUM and call INSTR_CPU_EXEC.
# After execution, the result (true or false) will be present in REG_BOOL_RES.
export OP_IS_NUM=7

# To compare equality, place the first value in REG_A and the second value in REG_B.
# Set REG_OP to OP_CMP_EQ and call INSTR_CPU_EXEC.
# After execution, the result (true if equal, false otherwise) will be present in REG_BOOL_RES.
export OP_CMP_EQ=8

# To compare inequality, place the first value in REG_A and the second value in REG_B.
# Set REG_OP to OP_CMP_NEQ and call INSTR_CPU_EXEC.
# After execution, the result (true if not equal, false otherwise) will be present in REG_BOOL_RES.
export OP_CMP_NEQ=9

# To check if one value is less than another, place the first value in REG_A and the second value in REG_B.
# Set REG_OP to OP_CMP_LT and call INSTR_CPU_EXEC.
# After execution, the result (true if REG_A < REG_B) will be present in REG_BOOL_RES.
export OP_CMP_LT=10

# To check if one value is less than or equal to another, place the first value in REG_A and the second value in REG_B.
# Set REG_OP to OP_CMP_LE and call INSTR_CPU_EXEC.
# After execution, the result (true if REG_A <= REG_B) will be present in REG_BOOL_RES.
export OP_CMP_LE=11

# To check if one value contains another, place the container in REG_A and the contained value in REG_B.
# Set REG_OP to OP_CONTAINS and call INSTR_CPU_EXEC.
# After execution, the result (true or false) will be present in REG_BOOL_RES.
export OP_CONTAINS=12

# To get the length of a string, place the string in REG_A.
# Set REG_OP to OP_GET_LENGTH and call INSTR_CPU_EXEC.
# After execution, the length will be present in REG_RES.
export OP_GET_LENGTH=13

# To check if a string starts with a given prefix, place the string in REG_A and the prefix in REG_B.
# Set REG_OP to OP_STARTS_WITH and call INSTR_CPU_EXEC.
# After execution, the result (true or false) will be present in REG_BOOL_RES.
export OP_STARTS_WITH=14

# To extract a specific column from a string, place the string in REG_A, the column number in REG_B, and the delimiter in REG_C.
# Set REG_OP to OP_GET_COLUMN and call INSTR_CPU_EXEC.
# After execution, the extracted column will be present in REG_RES.
export OP_GET_COLUMN=15

# To replace a specific column in a string, place the string in REG_A, the column number in REG_B, the delimiter in REG_C,  and the new value in REG_D.
# Set REG_OP to OP_REPLACE_COLUMN and call INSTR_CPU_EXEC.
# After execution, the modified string will be present in REG_RES.
export OP_REPLACE_COLUMN=16

# To concatenate two strings with a delimiter, place the first string in REG_A, the second string in REG_B, and the delimiter in REG_C.
# Set REG_OP to OP_CONCAT_WITH and call INSTR_CPU_EXEC.
# After execution, the concatenated string will be present in REG_RES.
export OP_CONCAT_WITH=17

# To read input from the keyboard, set REG_OP to OP_READ_INPUT and call INSTR_CPU_EXEC.
# For advanced processing set REG_A with one of the modes:
#   KEYBOARD_READ_LINE, KEYBOARD_READ_LINE_SILENTLY, KEYBOARD_READ_CHAR, KEYBOARD_READ_CHAR_SILENTLY.
# After execution, the input will be stored in the KEYBOARD_BUFFER.
export OP_READ_INPUT=18

# To display a string without a newline, place the string in DISPLAY_BUFFER and set the color in DISPLAY_COLOR.
# Set REG_OP to OP_DISPLAY and call INSTR_CPU_EXEC.
export OP_DISPLAY=19

# To display a string with a newline, place the string in DISPLAY_BUFFER and set the color in DISPLAY_COLOR.
# Set REG_OP to OP_DISPLAY_LN and call INSTR_CPU_EXEC.
export OP_DISPLAY_LN=20

# To read a block of data from a disk, set the disk name in REG_A and the block number in REG_B.
# Set REG_OP to OP_READ_BLOCK and call INSTR_CPU_EXEC.
# After execution, the data will be stored in REG_RES.
export OP_READ_BLOCK=21

# To write a string to a disk block, set the disk name in REG_A, the block number in REG_B, and the string in REG_C.
# Set REG_OP to OP_WRITE_BLOCK and call INSTR_CPU_EXEC.
# The result (success or failure) will be present in REG_BOOL_RES, and any error message will be stored in REG_ERROR if needed.
export OP_WRITE_BLOCK=22

# To change background color set COLOR_* constant to DISPLAY_BACKGROUND,
# set OP_SET_BACKGROUND_COLOR to REG_OP and call INSTR_CPU_EXEC
export OP_SET_BACKGROUND_COLOR=23

# To draw bitmap specify address of first line with bitmap representation to REG_A,
# first address after the last line of bitmap to REG_B, and OP_RENDER_BITMAP to REG_OP.
# Call INSTR_CPU_EXEC to render the bitmap.
# Each line should contain letters B(black), g(green), y(yellow), r(red), b(blue), m(magenta), c(cyan), w(white)
# For example string ggyyrr will display a line with 2 green cells, 2 yellow cells and 2 red cells
export OP_RENDER_BITMAP=24

# OP codes from 25 to 28 are reserved for future use.

# To perform no operation with sleep, set REG_OP to OP_NOP, sleep delay in seconds to REG_A and call INSTR_CPU_EXEC.
# This will have no effect and is useful for delays or placeholders.
export OP_NOP=29

# To halt the CPU and stop the system, set REG_OP to OP_HALT and call INSTR_CPU_EXEC.
# This will terminate all operations.
export OP_HALT=30

# To reset the operation code for safety, set REG_OP to OP_UNKNOWN and call INSTR_CPU_EXEC.
# This ensures that the operation code must be explicitly set before the next execution.
export OP_UNKNOWN=31

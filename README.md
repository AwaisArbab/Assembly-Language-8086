# Assembly Language Programming Guide

A comprehensive guide to x86 assembly language programming with focus on the Intel 8086 microprocessor and MASM/TASM assemblers.

## Table of Contents
- [Introduction](#introduction)
- [8086 Architecture](#8086-architecture)
- [Getting Started](#getting-started)
- [Memory Organization](#memory-organization)
- [Registers](#registers)
- [Data Types and Declarations](#data-types-and-declarations)
- [Instructions Reference](#instructions-reference)
- [Control Flow](#control-flow)
- [Procedures and Macros](#procedures-and-macros)
- [DOS Interrupts](#dos-interrupts)
- [Practical Examples](#practical-examples)
- [Best Practices](#best-practices)

---

## Introduction

Assembly language is a **low-level programming language** that provides direct communication with the CPU through human-readable mnemonics that represent machine instructions.

### Why Learn Assembly?

- **Hardware-level control**: Direct manipulation of CPU registers and memory
- **Performance optimization**: Maximum execution speed for critical code sections
- **Memory efficiency**: Precise control over memory usage and allocation
- **System programming**: Essential for OS development, device drivers, and embedded systems
- **Deep understanding**: Insight into how high-level languages work under the hood

### Assembly vs High-Level Languages

| Feature | Assembly | High-Level (C, Java) |
|---------|----------|---------------------|
| Abstraction | Direct hardware access | Multiple layers of abstraction |
| Portability | CPU-specific | Platform-independent (mostly) |
| Development Speed | Slower | Faster |
| Execution Speed | Fastest possible | Depends on compiler optimization |
| Code Size | Minimal (when optimized) | Larger |

---

## 8086 Architecture

The **Intel 8086** is a 16-bit microprocessor introduced in 1978, forming the foundation of x86 architecture.

### Key Specifications

- **Data bus**: 16-bit
- **Address bus**: 20-bit (can address 1 MB of memory)
- **Clock speed**: 5-10 MHz (original models)
- **Instruction set**: CISC (Complex Instruction Set Computing)
- **Registers**: 14 registers (16-bit each)

### Architecture Components

1. **Execution Unit (EU)**: Executes instructions
2. **Bus Interface Unit (BIU)**: Handles memory and I/O operations
3. **Instruction Queue**: 6-byte prefetch queue for pipelining

### Memory Segmentation

The 8086 uses **segmented memory architecture** to access 1 MB of memory with 16-bit registers:

- **Physical Address** = (Segment × 16) + Offset
- Maximum segment size: **64 KB**
- Segments can overlap

**Formula Example:**
```
Segment:Offset = 1000h:0500h
Physical = (1000h × 16) + 0500h = 10500h
```

---

## Getting Started

### Basic Program Structure

Every MASM program follows this template:

```asm
.model small          ; Define memory model
.stack 100h           ; Allocate stack space (256 bytes)

.data
    ; Variable declarations go here
    message db 'Hello, Assembly!$'
    number dw 1234

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax
    
    ; Your program logic here
    
    ; Exit program
    mov ah, 4Ch
    int 21h
main endp
end main
```

### Memory Models

The memory model determines how code and data segments are organized:

| Model | Code Seg | Data Seg | Total Size | Use Case |
|-------|----------|----------|------------|----------|
| **Tiny** | 1 (combined) | 1 (combined) | <64 KB | .COM programs |
| **Small** | 1 | 1 | <128 KB | Simple programs |
| **Medium** | Multiple | 1 | 64KB data | Code-heavy apps |
| **Compact** | 1 | Multiple | 64KB code | Data-heavy apps |
| **Large** | Multiple | Multiple | >128 KB | Complex applications |
| **Huge** | Multiple | Multiple (>64KB) | >1 MB | Very large programs |

**Recommendation**: Use `.MODEL SMALL` for learning and small projects.

### Essential Directives

| Directive | Purpose | Example |
|-----------|---------|---------|
| `.MODEL` | Set memory model | `.model small` |
| `.STACK` | Define stack size | `.stack 200h` |
| `.DATA` | Start data segment | `.data` |
| `.CODE` | Start code segment | `.code` |
| `PROC`/`ENDP` | Define procedure | `main proc` ... `main endp` |
| `END` | Mark program end | `end main` |

---

## Memory Organization

### Segment Registers

| Register | Purpose | Default Use |
|----------|---------|-------------|
| **CS** | Code Segment | Points to executable code |
| **DS** | Data Segment | Points to program data |
| **SS** | Stack Segment | Points to stack memory |
| **ES** | Extra Segment | Additional data access |

### Stack Operations

The stack grows **downward** in memory (from high to low addresses):

```asm
push ax          ; Store AX on stack, SP = SP - 2
push bx          ; Store BX on stack, SP = SP - 2
pop bx           ; Restore BX from stack, SP = SP + 2
pop ax           ; Restore AX from stack, SP = SP + 2
```

**Stack Rules:**
- Always **PUSH** in reverse order of **POP**
- SP (Stack Pointer) automatically adjusts
- Don't mix data sizes (push word, pop byte = error)

---

## Registers

### Register Organization

The 8086 has **fourteen 16-bit registers** divided into categories:

#### General-Purpose Registers

| Register | High/Low Split | Primary Use |
|----------|----------------|-------------|
| **AX** | AH / AL | Accumulator (arithmetic, I/O) |
| **BX** | BH / BL | Base (memory addressing) |
| **CX** | CH / CL | Counter (loops, shifts) |
| **DX** | DH / DL | Data (I/O operations, multiplication) |

**Example of splitting:**
```asm
mov ax, 1234h    ; AX = 1234h
mov al, 56h      ; AX = 1256h (only AL changed)
mov ah, 78h      ; AX = 7856h (only AH changed)
```

#### Pointer and Index Registers

| Register | Purpose |
|----------|---------|
| **SP** | Stack Pointer (top of stack) |
| **BP** | Base Pointer (stack frame access) |
| **SI** | Source Index (string operations) |
| **DI** | Destination Index (string operations) |

#### Control Registers

| Register | Purpose |
|----------|---------|
| **IP** | Instruction Pointer (next instruction address) |
| **FLAGS** | Status flags (condition codes) |

### FLAGS Register

Individual bits indicate CPU state:

| Flag | Bit | Purpose |
|------|-----|---------|
| **CF** | 0 | Carry Flag |
| **PF** | 2 | Parity Flag |
| **AF** | 4 | Auxiliary Carry Flag |
| **ZF** | 6 | Zero Flag |
| **SF** | 7 | Sign Flag |
| **TF** | 8 | Trap Flag (single-step) |
| **IF** | 9 | Interrupt Enable Flag |
| **DF** | 10 | Direction Flag |
| **OF** | 11 | Overflow Flag |

---

## Data Types and Declarations

### Basic Data Types

| Directive | Size | Range | Example |
|-----------|------|-------|---------|
| **DB** | 1 byte | 0-255 or -128 to 127 | `count db 10` |
| **DW** | 2 bytes | 0-65535 or -32768 to 32767 | `value dw 1000` |
| **DD** | 4 bytes | 32-bit values | `large dd 100000` |
| **DQ** | 8 bytes | 64-bit values | `huge dq 9999999999` |
| **DT** | 10 bytes | BCD or floating-point | `bcd dt 123456789` |

### Variable Declaration Examples

```asm
.data
    ; Single values
    char db 'A'              ; Single character
    byte_val db 255          ; Maximum unsigned byte
    word_val dw 65535        ; Maximum unsigned word
    
    ; Arrays
    array db 1, 2, 3, 4, 5   ; Byte array
    numbers dw 100, 200, 300 ; Word array
    
    ; Strings (DOS format ends with $)
    greeting db 'Hello World$'
    prompt db 'Enter input: $'
    
    ; Uninitialized variables
    buffer db 100 dup(?)     ; 100 uninitialized bytes
    result dw ?              ; Uninitialized word
    
    ; Duplicate values
    zeros db 50 dup(0)       ; 50 bytes of zero
    matrix dw 9 dup(100)     ; 9 words, each = 100
```

### String Handling

Strings in assembly require special handling:

**DOS Convention** (INT 21h, AH=09h):
```asm
msg db 'This is a string$'   ; $ marks end for DOS
```

**Null-Terminated** (C-style):
```asm
msg db 'This is a string', 0  ; 0 marks end
```

**Length-Prefixed**:
```asm
msg db 16, 'This is a string' ; First byte = length
```

---

## Instructions Reference

### Data Transfer Instructions

| Instruction | Format | Description |
|-------------|--------|-------------|
| **MOV** | `mov dest, src` | Copy data |
| **PUSH** | `push src` | Push onto stack |
| **POP** | `pop dest` | Pop from stack |
| **XCHG** | `xchg op1, op2` | Exchange values |
| **LEA** | `lea reg, mem` | Load effective address |
| **LDS** | `lds reg, mem` | Load DS:register |
| **LES** | `les reg, mem` | Load ES:register |

**Examples:**
```asm
mov ax, 1234h        ; Immediate to register
mov bx, ax           ; Register to register
mov [si], al         ; Register to memory
mov cx, [di]         ; Memory to register
lea si, array        ; Load address of array
xchg ax, bx          ; Swap AX and BX
```

### Arithmetic Instructions

| Instruction | Format | Description |
|-------------|--------|-------------|
| **ADD** | `add dest, src` | Addition |
| **ADC** | `adc dest, src` | Add with carry |
| **SUB** | `sub dest, src` | Subtraction |
| **SBB** | `sbb dest, src` | Subtract with borrow |
| **MUL** | `mul src` | Unsigned multiply (AX = AL × src) |
| **IMUL** | `imul src` | Signed multiply |
| **DIV** | `div src` | Unsigned divide (AL = AX / src) |
| **IDIV** | `idiv src` | Signed divide |
| **INC** | `inc dest` | Increment by 1 |
| **DEC** | `dec dest` | Decrement by 1 |
| **NEG** | `neg dest` | Two's complement |

**Multiplication Examples:**
```asm
; 8-bit multiplication: AL × src → AX
mov al, 5
mov bl, 10
mul bl              ; AX = 50 (0032h)

; 16-bit multiplication: AX × src → DX:AX
mov ax, 1000
mov bx, 500
mul bx              ; DX:AX = 500,000
```

**Division Examples:**
```asm
; 8-bit division: AX / src → AL (quotient), AH (remainder)
mov ax, 25
mov bl, 4
div bl              ; AL = 6, AH = 1

; 16-bit division: DX:AX / src → AX (quotient), DX (remainder)
mov dx, 0
mov ax, 1000
mov bx, 30
div bx              ; AX = 33, DX = 10
```

### Logical Instructions

| Instruction | Format | Description |
|-------------|--------|-------------|
| **AND** | `and dest, src` | Bitwise AND |
| **OR** | `or dest, src` | Bitwise OR |
| **XOR** | `xor dest, src` | Bitwise XOR |
| **NOT** | `not dest` | Bitwise NOT |
| **TEST** | `test op1, op2` | AND without storing result |

**Bit Manipulation:**
```asm
; Set bit 3 of AL
or al, 00001000b

; Clear bit 5 of AL
and al, 11011111b

; Toggle bit 2 of AL
xor al, 00000100b

; Check if AL is zero
test al, al
jz is_zero
```

### Shift and Rotate Instructions

| Instruction | Format | Description |
|-------------|--------|-------------|
| **SHL/SAL** | `shl dest, count` | Shift left |
| **SHR** | `shr dest, count` | Shift right (logical) |
| **SAR** | `sar dest, count` | Shift right (arithmetic) |
| **ROL** | `rol dest, count` | Rotate left |
| **ROR** | `ror dest, count` | Rotate right |
| **RCL** | `rcl dest, count` | Rotate left through carry |
| **RCR** | `rcr dest, count` | Rotate right through carry |

**Examples:**
```asm
mov al, 5          ; AL = 00000101b
shl al, 1          ; AL = 00001010b (multiply by 2)
shr al, 1          ; AL = 00000101b (divide by 2)
rol al, 2          ; AL = 00010100b (rotate left 2 bits)
```

### String Instructions

| Instruction | Format | Description |
|-------------|--------|-------------|
| **MOVS** | `movsb/movsw` | Move string |
| **CMPS** | `cmpsb/cmpsw` | Compare string |
| **SCAS** | `scasb/scasw` | Scan string |
| **LODS** | `lodsb/lodsw` | Load string element |
| **STOS** | `stosb/stosw` | Store string element |
| **REP** | `rep` | Repeat while CX ≠ 0 |
| **REPE** | `repe/repz` | Repeat while equal/zero |
| **REPNE** | `repne/repnz` | Repeat while not equal/zero |

**String Copy Example:**
```asm
.data
    source db 'HELLO'
    dest db 5 dup(?)
    
.code
    lea si, source
    lea di, dest
    mov cx, 5
    cld              ; Clear direction flag (forward)
    rep movsb        ; Copy CX bytes from SI to DI
```

---

## Control Flow

### Unconditional Jumps

```asm
jmp label           ; Jump to label
jmp short label     ; Short jump (-128 to +127 bytes)
jmp near label      ; Near jump (within segment)
jmp far label       ; Far jump (different segment)
```

### Conditional Jumps

**Unsigned Comparisons:**

| Instruction | Condition | Flags Checked |
|-------------|-----------|---------------|
| **JE/JZ** | Equal / Zero | ZF = 1 |
| **JNE/JNZ** | Not Equal / Not Zero | ZF = 0 |
| **JA/JNBE** | Above | CF=0 and ZF=0 |
| **JAE/JNB** | Above or Equal | CF = 0 |
| **JB/JNAE** | Below | CF = 1 |
| **JBE/JNA** | Below or Equal | CF=1 or ZF=1 |

**Signed Comparisons:**

| Instruction | Condition | Flags Checked |
|-------------|-----------|---------------|
| **JG/JNLE** | Greater | ZF=0 and SF=OF |
| **JGE/JNL** | Greater or Equal | SF = OF |
| **JL/JNGE** | Less | SF ≠ OF |
| **JLE/JNG** | Less or Equal | ZF=1 or SF≠OF |

**Flag-Based Jumps:**

| Instruction | Condition |
|-------------|-----------|
| **JC** | Carry flag set |
| **JNC** | Carry flag clear |
| **JS** | Sign flag set (negative) |
| **JNS** | Sign flag clear (positive) |
| **JO** | Overflow flag set |
| **JNO** | Overflow flag clear |
| **JP/JPE** | Parity even |
| **JNP/JPO** | Parity odd |

### Loop Instructions

```asm
loop label          ; Decrement CX, jump if CX ≠ 0
loope/loopz label   ; Loop while equal/zero
loopne/loopnz label ; Loop while not equal/zero
```

**Loop Example:**
```asm
mov cx, 10          ; Loop 10 times
start_loop:
    ; Loop body
    dec cx
    jnz start_loop  ; Alternative to LOOP
    
; Or simply:
mov cx, 10
start_loop2:
    ; Loop body
    loop start_loop2
```

### Comparison Examples

```asm
; Compare and branch
cmp ax, bx
je equal_values     ; Jump if AX = BX
jg ax_greater       ; Jump if AX > BX (signed)
ja ax_above         ; Jump if AX > BX (unsigned)

; Check for zero
test al, al         ; Faster than cmp al, 0
jz is_zero

; Range check
cmp al, 'A'
jb not_uppercase    ; Below 'A'
cmp al, 'Z'
ja not_uppercase    ; Above 'Z'
; If here, AL is uppercase letter
```

---

## Procedures and Macros

### Procedures (Functions)

Procedures provide code modularity and reusability:

```asm
; Simple procedure
print_char proc
    mov ah, 2
    int 21h
    ret
print_char endp

; Call the procedure
mov dl, 'A'
call print_char
```

### Parameter Passing

**Method 1: Using Registers**
```asm
multiply proc
    ; Input: AL, BL
    ; Output: AX
    mul bl
    ret
multiply endp

; Usage:
mov al, 5
mov bl, 10
call multiply       ; AX = 50
```

**Method 2: Using Stack**
```asm
add_numbers proc
    push bp
    mov bp, sp
    
    mov ax, [bp+4]  ; First parameter
    add ax, [bp+6]  ; Second parameter
    
    pop bp
    ret 4           ; Clean up 4 bytes
add_numbers endp

; Usage:
push 10
push 20
call add_numbers    ; AX = 30
```

### Macros

Macros are templates for code generation:

**Simple Macro:**
```asm
print_char macro char_to_print
    mov dl, char_to_print
    mov ah, 2
    int 21h
endm

; Usage:
print_char 'A'
print_char 'B'
```

**Advanced Macro with Multiple Parameters:**
```asm
print_number macro number
    local skip_hundreds, skip_tens, done
    
    mov ax, number
    mov bl, 100
    div bl              ; AH = remainder, AL = quotient
    
    cmp al, 0
    je skip_hundreds
    add al, 30h
    mov dl, al
    mov ah, 2
    int 21h
    
skip_hundreds:
    mov al, ah          ; Get remainder
    mov ah, 0
    mov bl, 10
    div bl
    
    add al, 30h
    mov dl, al
    mov ah, 2
    int 21h
    
    add ah, 30h
    mov dl, ah
    mov ah, 2
    int 21h
endm
```

### Procedure vs Macro

| Feature | Procedure | Macro |
|---------|-----------|-------|
| Code Replication | Single copy | Replicated each use |
| Memory Usage | Smaller | Larger |
| Execution Speed | Slower (call overhead) | Faster (inline) |
| Parameters | Limited methods | Flexible |
| Best For | Large, reusable code | Small, frequent code |

---

## DOS Interrupts

### INT 21h Functions

DOS interrupt 21h provides system services:

| Function (AH) | Purpose | Input | Output |
|---------------|---------|-------|--------|
| **01h** | Read character with echo | - | AL = character |
| **02h** | Display character | DL = character | - |
| **09h** | Display string | DS:DX = string address | - |
| **0Ah** | Buffered keyboard input | DS:DX = buffer | - |
| **4Ch** | Terminate program | AL = return code | - |

### Character I/O Examples

**Read a Character:**
```asm
mov ah, 1           ; Function 1
int 21h             ; AL = character read
```

**Display a Character:**
```asm
mov dl, 'A'         ; Character to display
mov ah, 2           ; Function 2
int 21h
```

**Display a String:**
```asm
.data
    msg db 'Hello, World!$'
    
.code
    mov dx, offset msg
    mov ah, 9
    int 21h
```

### Number Conversion

**ASCII to Binary:**
```asm
; Convert ASCII digit to number
mov al, '7'         ; AL = 37h
sub al, 30h         ; AL = 7
```

**Binary to ASCII:**
```asm
; Convert number to ASCII digit
mov al, 7
add al, 30h         ; AL = 37h ('7')
```

**AAM (ASCII Adjust after Multiplication):**
```asm
; Multiply two decimal digits
mov al, 7
mov bl, 8
mul bl              ; AX = 56 (38h)
aam                 ; AH = 5, AL = 6 (decimal digits)

; Convert to ASCII
add ah, 30h         ; AH = '5'
add al, 30h         ; AL = '6'

; Display
mov dl, ah
mov ah, 2
int 21h             ; Print '5'
mov dl, al
mov ah, 2
int 21h             ; Print '6'
```

**AAD (ASCII Adjust before Division):**
```asm
; Prepare ASCII digits for division
mov ah, '5'         ; Tens digit
mov al, '6'         ; Ones digit
sub ah, 30h         ; Convert to binary
sub al, 30h
aad                 ; AX = 56 (decimal)
```

---

## Practical Examples

### Example 1: Print Numbers 1-10

```asm
.model small
.stack 100h

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov cx, 10          ; Counter
    mov bl, 1           ; Current number
    
print_loop:
    mov al, bl
    add al, 30h         ; Convert to ASCII
    mov dl, al
    mov ah, 2
    int 21h
    
    ; Print space
    mov dl, ' '
    mov ah, 2
    int 21h
    
    inc bl
    loop print_loop
    
    mov ah, 4Ch
    int 21h
main endp
end main
```

### Example 2: Multiplication Table

```asm
.model small
.stack 100h

.data
    num db 5            ; Number for multiplication table
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov cl, 1           ; Multiplier
    mov ch, 10          ; Loop 10 times
    
mult_loop:
    mov al, num
    mul cl              ; AL = num × CL
    
    ; Print result using AAM
    aam
    add ah, 30h
    add al, 30h
    
    ; Print tens digit if not zero
    cmp ah, 30h
    je skip_tens
    mov dl, ah
    mov ah, 2
    int 21h
    
skip_tens:
    mov dl, al
    mov ah, 2
    int 21h
    
    ; Print newline
    mov dl, 13
    mov ah, 2
    int 21h
    mov dl, 10
    mov ah, 2
    int 21h
    
    inc cl
    dec ch
    jnz mult_loop
    
    mov ah, 4Ch
    int 21h
main endp
end main
```

### Example 3: String Reversal

```asm
.model small
.stack 100h

.data
    str db 'HELLO$'
    reversed db 6 dup('$')
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Find string length
    lea si, str
    mov cx, 0
count_loop:
    mov al, [si]
    cmp al, '$'
    je done_counting
    inc si
    inc cx
    jmp count_loop
    
done_counting:
    ; Reverse the string
    lea si, str
    lea di, reversed
    add si, cx
    dec si
    
reverse_loop:
    mov al, [si]
    mov [di], al
    dec si
    inc di
    loop reverse_loop
    
    ; Print reversed string
    lea dx, reversed
    mov ah, 9
    int 21h
    
    mov ah, 4Ch
    int 21h
main endp
end main
```

### Example 4: Array Sum

```asm
.model small
.stack 100h

.data
    array dw 10, 20, 30, 40, 50
    sum dw 0
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea si, array
    mov cx, 5
    mov ax, 0           ; Accumulator
    
sum_loop:
    add ax, [si]
    add si, 2           ; Move to next word
    loop sum_loop
    
    mov sum, ax
    
    mov ah, 4Ch
    int 21h
main endp
end main
```

---

## Best Practices

### Code Organization

1. **Always initialize DS**:
```asm
mov ax, @data
mov ds, ax
```

2. **Clear registers before operations**:
```asm
mov ah, 0           ; Before MUL
mov dx, 0           ; Before DIV
```

3. **Use meaningful labels**:
```asm
; Good
calculate_sum:
print_result:

; Bad
label1:
label2:
```

4. **Comment your code**:
```asm
mov cx, 10          ; Loop counter
add ax, bx          ; Total = base + offset
```

### Common Pitfalls

❌ **Forgetting to initialize DS**
```asm
; Wrong - DS not initialized
mov al, [num]       ; May access wrong memory

; Correct
mov ax, @data
mov ds, ax
mov al, [num]
```

❌ **Not clearing AH before MUL**
```asm
; Wrong
mov al, 5
mul bl              ; AX = (unknown AH value × 256) + result

; Correct
mov ah, 0
mov al, 5
mul bl
```

❌ **Mixing data sizes**
```asm
; Wrong
push al             ; Can't push 8-bit register
mov ax, bl          ; Size mismatch

; Correct
mov ah, 0
push ax
mov al, bl
```

❌ **Stack imbalance**
```asm
; Wrong
push ax
push bx
pop ax              ; Imbalanced!

; Correct
push ax
push bx
pop bx
pop ax
```

### Optimization Tips

1. **Use XOR to clear registers** (faster than MOV):
```asm
xor ax, ax          ; Faster than mov ax, 0
```

2. **Use shifts for multiplication/division by powers of 2**:
```asm
shl ax, 1           ; Faster than mul 2
shr ax, 2           ; Faster than div 4
```

3. **Use TEST instead of CMP when checking for zero**:
```asm
test ax, ax         ; Faster than cmp ax, 0
jz is_zero
```

4. **Minimize memory access**:
```asm
; Slower
mov ax, [num]
add ax, 1
mov [num], ax

; Faster
inc [num]
```

### Debugging Techniques

1. **Print intermediate values**
2. **Use step-by-step execution in debuggers**
3. **Check flag values after operations**
4. **Verify register contents at breakpoints**

---

## Additional Resources

### Assemblers

- **MASM** (Microsoft Macro Assembler)
- **TASM** (Turbo Assembler)
- **NASM** (Netwide Assembler)
- **FASM** (Flat Assembler)

### Learning Resources

1. **Books**:
   - *Assembly Language for x86 Processors* by Kip Irvine
   - *The Art of Assembly Language* by Randall Hyde
   - *PC Assembly Language* by Paul A. Carter

2. **Online Documentation**:
   - Intel 8086 Family User's Manual
   - MASM 6.1 Programmer's Guide
   - x86 Instruction Set Reference

3. **Practice Platforms**:
   - DOSBox (DOS emulator)
   - emu8086 (8086 emulator with debugger)
   - SASM (Simple crossplatform IDE for NASM, MASM, GAS, FASM)

### Quick Reference

**Segment Registers**: CS, DS, SS, ES  
**General Registers**: AX, BX, CX, DX  
**Index Registers**: SI, DI, BP, SP  
**Common Operations**: MOV, ADD, SUB, MUL, DIV, CMP, JMP  
**DOS Functions**: INT 21h (AH=01h input, 02h output, 09h string, 4Ch exit)

---

## Contributing

Feel free to contribute to this guide by:
- Reporting errors or unclear sections
- Suggesting additional examples
- Adding more advanced topics
- Improving existing explanations

---

## License

This guide is provided for educational purposes. Assembly language and x86 architecture are documented by Intel and other organizations.

**Happy coding in Assembly! 🖥️**

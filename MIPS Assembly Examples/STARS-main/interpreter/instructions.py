import math
import warnings
from typing import Union, Tuple, Dict

from numpy import float32

from constants import WORD_SIZE, HALF_SIZE, WORD_MASK, WORD_MAX, WORD_MIN
from interpreter import exceptions as ex

'''
Copyright 2020 Kevin McDonnell, Jihu Mun, and Ian Peitzsch

Developed by Kevin McDonnell (ktm@cs.stonybrook.edu),
Jihu Mun (jihu1011@gmail.com),
and Ian Peitzsch (irpeitzsch@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''

# Regular instructions
# Helper function to account for overflow issues.
def overflow_detect(n: int) -> int:
    mod = n % WORD_SIZE

    if mod >= WORD_SIZE // 2:
        return mod - WORD_SIZE

    return mod


# Check if a 16-bit immediate is valid.
def valid_immed(n: int) -> bool:
    return -HALF_SIZE // 2 <= n < HALF_SIZE // 2


# Check if an unsigned 16-bit immediate is valid.
def valid_immed_unsigned(n: int) -> bool:
    return 0 <= n < HALF_SIZE


# Check if a shift amount is valid.
def valid_shamt(n: int) -> bool:
    return 0 <= n < 32


# Convert a signed 32-bit integer to an unsigned one.
def to_unsigned(n: int) -> int:
    return n if n >= 0 else n + WORD_SIZE


def add(a: int, b: int, signed: bool = True) -> int:
    # Add two 32-bit two's complement numbers
    if signed:
        if not -WORD_SIZE // 2 <= a + b < WORD_SIZE // 2:
            raise ex.ArithmeticOverflow("Overflow while adding")

    return a + b


def addi(a: int, b: int) -> int:
    if not valid_immed(b):
        raise ex.InvalidImmediate("Immediate is not 16-bit")

    return add(a, b, signed=True)


def addiu(a: int, b: int) -> int:
    if not valid_immed(b):
        raise ex.InvalidImmediate("Immediate is not 16-bit")

    return addu(a, b)


def addu(a: int, b: int) -> int:
    return add(a, b, signed=False)


def _and(a: int, b: int) -> int:
    # Bitwise AND of two 32-bit numbers.
    return a & b


def andi(a: int, b: int) -> int:
    if valid_immed_unsigned(b):
        raise ex.InvalidImmediate("Immediate is not unsigned 16 bit")

    return _and(a, b)


def mul(a: int, b: int, thirty_two_bits: bool = True, signed: bool = True) -> Union[int, Tuple[int, int]]:
    # Multiply two 32-bit numbers
    # The result is a 64-bit number. (Unless 32 bits are specified)
    if thirty_two_bits:  # mul
        return a * b

    if signed:  # mult (64 bits, signed)
        result = a * b

    else:  # multu (64 bits, unsigned)
        result = to_unsigned(a) * to_unsigned(b)

    return result & WORD_MASK, (result >> 32) & WORD_MASK


def mult(a: int, b: int) -> Tuple[int, int]:
    return mul(a, b, thirty_two_bits=False, signed=True)


def multu(a: int, b: int) -> Tuple[int, int]:
    return mul(a, b, thirty_two_bits=False, signed=False)


def div(a: int, b: int, signed: bool = True) -> Union[int, Tuple[int, int]]:
    def sign(n: int) -> int:
        return -1 if n < 0 else 1

    # Divide two 32-bit numbers
    if b == 0:
        raise ex.DivisionByZero(" ")

    elif signed:  # div
        return int(a / b), abs(a) % abs(b) * sign(a)

    # divu
    a_unsigned = to_unsigned(a)
    b_unsigned = to_unsigned(b)

    return a_unsigned // b_unsigned, a_unsigned % b_unsigned


def clo(a: int, bit: int = 1) -> int:
    temp = 32

    for i in reversed(range(32)):
        if (a >> i) & 1 != bit:
            return 31 - i

    return temp


def clz(a: int) -> int:
    return clo(a, bit=0)


def lui(a: int) -> int:
    if not valid_immed_unsigned(a):
        raise ex.InvalidImmediate("Immediate is not unsigned 16 bit")

    return a << 16


def nor(a: int, b: int) -> int:
    # Bitwise NOR of two 32-bit numbers.
    return ~(_or(a, b))


def _or(a: int, b: int) -> int:
    # Bitwise OR of two 32-bit numbers.
    return a | b


def ori(a: int, b: int) -> int:
    if not valid_immed_unsigned(b):
        raise ex.InvalidImmediate("Immediate is not unsigned 16 bit")

    return _or(a, b)


def sllv(a: int, b: int) -> int:
    # Shift left of a 32-bit number.
    b %= 32
    return (a << b) & WORD_MASK


def sll(a: int, b: int) -> int:
    if not valid_shamt(b):
        raise ex.InvalidImmediate("Shift amount is not 0-31")

    return sllv(a, b)


def slt(a: int, b: int, signed: bool = True) -> int:
    # Set on less than.
    if signed:
        if a < b:
            return 1

    else:
        if a & 0xFFFFFFFF < b & 0xFFFFFFFF:
            return 1

    return 0


def sltu(a: int, b: int) -> int:
    # Set on less than unsigned
    return slt(a, b, False)


def slti(a: int, b: int) -> int:
    if not valid_immed(b):
        raise ex.InvalidImmediate("Immediate is not 16 bit")

    return slt(a, b, True)


def sltiu(a: int, b: int) -> int:
    if not valid_immed(b):
        raise ex.InvalidImmediate("Immediate is not 16 bit")

    return slt(a, b, False)


def srav(a: int, b: int) -> int:
    # Shift right of a 32-bit number.
    b %= 32
    return a >> b


def sra(a: int, b: int) -> int:
    if not valid_shamt(b):
        raise ex.InvalidImmediate("Shift amount is not 0-31")

    return srav(a, b)


def srlv(a: int, b: int) -> int:
    b %= 32
    return a >> b if a >= 0 else (a + 0x100000000) >> b


def srl(a: int, b: int) -> int:
    if not valid_shamt(b):
        raise ex.InvalidImmediate("Shift amount is not 0-31")

    return srlv(a, b)


def sub(a: int, b: int, signed: bool = True) -> int:
    # Subtract two 32-bit two's complement numbers
    return add(a, -b, signed)


def subu(a: int, b: int) -> int:
    # Subtract unsigned
    return sub(a, b, False)


def xor(a: int, b: int) -> int:
    # Bitwise XOR of two 32-bit numbers.
    return a ^ b


def xori(a: int, b: int) -> int:
    if not valid_immed_unsigned(b):
        raise ex.InvalidImmediate("Immediate is not unsigned 16 bit")

    return xor(a, b)


def lw(addr: int, mem) -> int:
    # Load word.
    return mem.getWord(addr)


def lh(addr: int, mem) -> int:
    # Load half word.
    return mem.getHWord(addr)


def lb(addr: int, mem) -> int:
    # Load byte.
    return mem.getByte(addr)


def lbu(addr: int, mem) -> int:
    # Load byte unsigned.
    return mem.getByte(addr, signed=False)


def lhu(addr: int, mem) -> int:
    # Load half unsigned.
    return mem.getHWord(addr, signed=False)


def lwl(addr: int, mem, reg: int) -> int:
    # Load word left
    word_start = addr - addr % 4
    result = 0

    for i in range(addr % 4 + 1):
        byte = mem.getByte(word_start + i, signed=False)
        alignment = 3 - addr % 4 + i
        result |= byte << (8 * alignment)

    mask = (1 << ((3 - addr % 4) * 8)) - 1
    return (reg & mask) + result


def lwr(addr: int, mem, reg: int) -> int:
    # Load word right
    word_start = addr - addr % 4
    result = 0

    for i in range(4 - addr % 4):
        byte = mem.getByte(word_start + 3 - i, signed=False)
        alignment = 3 - i - addr % 4
        result |= byte << (8 * alignment)

    mask = ((1 << (addr % 4 * 8)) - 1) << ((4 - addr % 4) * 8)
    return (reg & mask) + result


def sw(addr: int, mem, data: int) -> None:
    # Store word.
    mem.addWord(data, addr)


def sh(addr: int, mem, data: int) -> None:
    # Store half.
    mem.addHWord(data, addr)


def sb(addr: int, mem, data: int) -> None:
    # Store byte.
    mem.addByte(data, addr)


# Helper function for swl, swr
def _get_reg_byte(data: int, i: int) -> int:
    # Get the ith byte of a 32-bit integer
    return data >> (8 * i) & 0xFF


def swl(addr: int, mem, data: int) -> None:
    # Store word left
    alignment = addr % 4
    word_start = addr - alignment

    for i in range(alignment + 1):
        byte = _get_reg_byte(data, 3 - i)
        sb(word_start + alignment - i, mem, byte)


def swr(addr: int, mem, data: int) -> None:
    # Store word right
    alignment = addr % 4
    word_start = addr - alignment

    for i in range(4 - alignment):
        byte = _get_reg_byte(data, i)
        sb(word_start + alignment + i, mem, byte)


def blez(a: int) -> bool:
    # Branch on less than or equal to 0
    return a <= 0


def bltz(a: int) -> bool:
    # Branch on less than 0
    return a < 0


def bgez(a: int) -> bool:
    # Branch on greater than or equal to.
    return a >= 0


def bgtz(a: int) -> bool:
    # Branch on greater than.
    return a > 0


def beq(a: int, b: int) -> bool:
    # Branch on equal to.
    return a == b


def bne(a: int, b: int) -> bool:
    # Branch on not equal to.
    return a != b


def jal(reg: Dict[str, int], mem, label: str) -> None:
    # Jump and link.
    reg['$ra'] = reg['pc']
    l = mem.getLabel(label)

    if l:
        reg['pc'] = l
    else:
        raise ex.InvalidLabel(label + ' is not a valid label.')


def j(reg: Dict[str, int], mem, label: str) -> None:
    # Unconditional jump.
    l = mem.getLabel(label)

    if l:
        reg['pc'] = l
    else:
        raise ex.InvalidLabel(label + ' is not a valid label.')


def jalr(reg: Dict[str, int], target: str) -> None:
    # Jump and link register
    reg['$ra'] = reg['pc']
    reg['pc'] = reg[target]


def jr(reg: Dict[str, int], target: str) -> None:
    # Jump register
    reg['pc'] = reg[target]


def movz(a: int, b: int) -> int:
    return a


# Floating point instructions
def add_f(a: Union[float32, float], b: Union[float32, float]) -> Union[float32, float]:
    if type(a) is float32:
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return float32(a + b)

    return a + b


def sub_f(a: Union[float32, float], b: Union[float32, float]) -> Union[float32, float]:
    if type(a) is float32:
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return float32(a - b)

    return a - b


def mul_f(a: Union[float32, float], b: Union[float32, float]) -> Union[float32, float]:
    if type(a) is float32:
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return float32(a * b)

    return a * b


def div_f(a: Union[float32, float], b: Union[float32, float]) -> Union[float32, float]:
    if type(a) is float32:
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return float32(a / b)

    try:
        result = a / b
    except ZeroDivisionError:
        if a > 0:
            result = float('inf')
        elif a < 0:
            result = float('-inf')
        else:
            result = float('nan')

    return result


def _abs(a: Union[float32, float]) -> Union[float32, float]:
    return abs(a)


def mov(a: Union[float32, float]) -> Union[float32, float]:
    return a


def neg(a: Union[float32, float]) -> Union[float32, float]:
    return -a


def sqrt(a: Union[float32, float]) -> Union[float32, float]:
    if a < 0:
        if type(a) is float32:
            return float32('nan')
        else:
            return float('nan')

    return a ** 0.5


# Helper method for float -> int conversion instructions
def nan_or_inf(a: Union[float32, float]) -> bool:
    return math.isnan(a) or math.isinf(a)


def convert_to_int(a: Union[float32, float], func) -> int:
    if nan_or_inf(a):
        return WORD_MAX

    result = func(a)
    return result if WORD_MIN <= result <= WORD_MAX else WORD_MAX


def ceil(a: Union[float32, float]) -> int:
    return convert_to_int(a, math.ceil)


def floor(a: Union[float32, float]) -> int:
    return convert_to_int(a, math.floor)


def _round(a: Union[float32, float]) -> int:
    return convert_to_int(a, round)


def trunc(a: Union[float32, float]) -> int:
    return convert_to_int(a, math.trunc)


table = {'abs': _abs,
         'add': add,
         'add_f': add_f,
         'addu': addu,
         'addi': addi,
         'addiu': addiu,
         'and': _and,
         'andi': andi,
         'mul': mul,
         'mul_f': mul_f,
         'div_f': div_f,
         'ceil': ceil,
         'clo': clo,
         'clz': clz,
         'floor': floor,
         'neg': neg,
         'nor': nor,
         'or': _or,
         'ori': ori,
         'round': _round,
         'sll': sll,
         'sllv': sllv,
         'slt': slt,
         'sltu': sltu,
         'slti': slt,
         'sltiu': sltiu,
         'sra': sra,
         'srav': srav,
         'srl': srl,
         'srlv': srlv,
         'sqrt': sqrt,
         'sub': sub,
         'sub_f': sub_f,
         'subu': subu,
         'trunc': trunc,
         'xor': xor,
         'xori': xori,
         'lw': lw,
         'lh': lh,
         'lb': lb,
         'lwl': lwl,
         'lwr': lwr,
         'swl': swl,
         'swr': swr,
         'sw': sw,
         'sh': sh,
         'sb': sb,
         'lbu': lbu,
         'lhu': lhu,
         'beq': beq,
         'blez': blez,
         'bltz': bltz,
         'bgtz': bgtz,
         'bgez': bgez,
         'bne': bne,
         'jal': jal,
         'jalr': jalr,
         'b': j,
         'j': j,
         'jr': jr,
         'mov': mov,
         'movz': movz,
         'movn': movz
         }

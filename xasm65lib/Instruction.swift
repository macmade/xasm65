/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation

public class Instruction
{
    public enum AddressingMode
    {
        case implied
        case accumulator
        case immediate
        case zeroPage
        case zeroPageX
        case zeroPageY
        case relative
        case absolute
        case absoluteX
        case absoluteY
        case indirect
        case indirectX
        case indirectY
    }

    public var mnemonic:       String
    public var opcode:         UInt8
    public var addressingMode: AddressingMode

    public init( mnemonic: String, opcode: UInt8, addressingMode: AddressingMode )
    {
        self.mnemonic       = mnemonic
        self.opcode         = opcode
        self.addressingMode = addressingMode
    }

    public static let all =
        [
            Instruction( mnemonic: "ADC", opcode: 0x6D, addressingMode: .absolute ),
            Instruction( mnemonic: "ADC", opcode: 0x7D, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ADC", opcode: 0x79, addressingMode: .absoluteY ),
            Instruction( mnemonic: "ADC", opcode: 0x69, addressingMode: .immediate ),
            Instruction( mnemonic: "ADC", opcode: 0x61, addressingMode: .indirectX ),
            Instruction( mnemonic: "ADC", opcode: 0x71, addressingMode: .indirectY ),
            Instruction( mnemonic: "ADC", opcode: 0x65, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ADC", opcode: 0x75, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "AND", opcode: 0x2D, addressingMode: .absolute ),
            Instruction( mnemonic: "AND", opcode: 0x3D, addressingMode: .absoluteX ),
            Instruction( mnemonic: "AND", opcode: 0x39, addressingMode: .absoluteY ),
            Instruction( mnemonic: "AND", opcode: 0x29, addressingMode: .immediate ),
            Instruction( mnemonic: "AND", opcode: 0x21, addressingMode: .indirectX ),
            Instruction( mnemonic: "AND", opcode: 0x31, addressingMode: .indirectY ),
            Instruction( mnemonic: "AND", opcode: 0x25, addressingMode: .zeroPage ),
            Instruction( mnemonic: "AND", opcode: 0x35, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "ASL", opcode: 0x0E, addressingMode: .absolute ),
            Instruction( mnemonic: "ASL", opcode: 0x1E, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ASL", opcode: 0x0A, addressingMode: .accumulator ),
            Instruction( mnemonic: "ASL", opcode: 0x06, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ASL", opcode: 0x16, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "BCC", opcode: 0x90, addressingMode: .relative ),
            Instruction( mnemonic: "BCS", opcode: 0xB0, addressingMode: .relative ),
            Instruction( mnemonic: "BEQ", opcode: 0xF0, addressingMode: .relative ),
            Instruction( mnemonic: "BIT", opcode: 0x2C, addressingMode: .absolute ),
            Instruction( mnemonic: "BIT", opcode: 0x24, addressingMode: .zeroPage ),
            Instruction( mnemonic: "BMI", opcode: 0x30, addressingMode: .relative ),
            Instruction( mnemonic: "BNE", opcode: 0xD0, addressingMode: .relative ),
            Instruction( mnemonic: "BPL", opcode: 0x10, addressingMode: .relative ),
            Instruction( mnemonic: "BRK", opcode: 0x00, addressingMode: .implied ),
            Instruction( mnemonic: "BVC", opcode: 0x50, addressingMode: .relative ),
            Instruction( mnemonic: "BVS", opcode: 0x70, addressingMode: .relative ),
            Instruction( mnemonic: "CLC", opcode: 0x18, addressingMode: .implied ),
            Instruction( mnemonic: "CLD", opcode: 0xD8, addressingMode: .implied ),
            Instruction( mnemonic: "CLI", opcode: 0x58, addressingMode: .implied ),
            Instruction( mnemonic: "CLV", opcode: 0xB8, addressingMode: .implied ),
            Instruction( mnemonic: "CMP", opcode: 0xCD, addressingMode: .absolute ),
            Instruction( mnemonic: "CMP", opcode: 0xDD, addressingMode: .absoluteX ),
            Instruction( mnemonic: "CMP", opcode: 0xD9, addressingMode: .absoluteY ),
            Instruction( mnemonic: "CMP", opcode: 0xC9, addressingMode: .immediate ),
            Instruction( mnemonic: "CMP", opcode: 0xC1, addressingMode: .indirectX ),
            Instruction( mnemonic: "CMP", opcode: 0xD1, addressingMode: .indirectY ),
            Instruction( mnemonic: "CMP", opcode: 0xC5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "CMP", opcode: 0xD5, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "CPX", opcode: 0xEC, addressingMode: .absolute ),
            Instruction( mnemonic: "CPX", opcode: 0xE0, addressingMode: .immediate ),
            Instruction( mnemonic: "CPX", opcode: 0xE4, addressingMode: .zeroPage ),
            Instruction( mnemonic: "CPY", opcode: 0xCC, addressingMode: .absolute ),
            Instruction( mnemonic: "CPY", opcode: 0xC0, addressingMode: .immediate ),
            Instruction( mnemonic: "CPY", opcode: 0xC4, addressingMode: .zeroPage ),
            Instruction( mnemonic: "DEC", opcode: 0xCE, addressingMode: .absolute ),
            Instruction( mnemonic: "DEC", opcode: 0xDE, addressingMode: .absoluteX ),
            Instruction( mnemonic: "DEC", opcode: 0xC6, addressingMode: .zeroPage ),
            Instruction( mnemonic: "DEC", opcode: 0xD6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "DEX", opcode: 0xCA, addressingMode: .implied ),
            Instruction( mnemonic: "DEY", opcode: 0x88, addressingMode: .implied ),
            Instruction( mnemonic: "EOR", opcode: 0x4D, addressingMode: .absolute ),
            Instruction( mnemonic: "EOR", opcode: 0x5D, addressingMode: .absoluteX ),
            Instruction( mnemonic: "EOR", opcode: 0x59, addressingMode: .absoluteY ),
            Instruction( mnemonic: "EOR", opcode: 0x49, addressingMode: .immediate ),
            Instruction( mnemonic: "EOR", opcode: 0x41, addressingMode: .indirectX ),
            Instruction( mnemonic: "EOR", opcode: 0x51, addressingMode: .indirectY ),
            Instruction( mnemonic: "EOR", opcode: 0x45, addressingMode: .zeroPage ),
            Instruction( mnemonic: "EOR", opcode: 0x55, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "INC", opcode: 0xEE, addressingMode: .absolute ),
            Instruction( mnemonic: "INC", opcode: 0xFE, addressingMode: .absoluteX ),
            Instruction( mnemonic: "INC", opcode: 0xE6, addressingMode: .zeroPage ),
            Instruction( mnemonic: "INC", opcode: 0xF6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "INX", opcode: 0xE8, addressingMode: .implied ),
            Instruction( mnemonic: "INY", opcode: 0xC8, addressingMode: .implied ),
            Instruction( mnemonic: "JMP", opcode: 0x4C, addressingMode: .absolute ),
            Instruction( mnemonic: "JMP", opcode: 0x6C, addressingMode: .indirect ),
            Instruction( mnemonic: "JSR", opcode: 0x20, addressingMode: .absolute ),
            Instruction( mnemonic: "LDA", opcode: 0xAD, addressingMode: .absolute ),
            Instruction( mnemonic: "LDA", opcode: 0xBD, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LDA", opcode: 0xB9, addressingMode: .absoluteY ),
            Instruction( mnemonic: "LDA", opcode: 0xA9, addressingMode: .immediate ),
            Instruction( mnemonic: "LDA", opcode: 0xA1, addressingMode: .indirectX ),
            Instruction( mnemonic: "LDA", opcode: 0xB1, addressingMode: .indirectY ),
            Instruction( mnemonic: "LDA", opcode: 0xA5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDA", opcode: 0xB5, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "LDX", opcode: 0xAE, addressingMode: .absolute ),
            Instruction( mnemonic: "LDX", opcode: 0xBE, addressingMode: .absoluteY ),
            Instruction( mnemonic: "LDX", opcode: 0xA2, addressingMode: .immediate ),
            Instruction( mnemonic: "LDX", opcode: 0xA6, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDX", opcode: 0xB6, addressingMode: .zeroPageY ),
            Instruction( mnemonic: "LDY", opcode: 0xAC, addressingMode: .absolute ),
            Instruction( mnemonic: "LDY", opcode: 0xBC, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LDY", opcode: 0xA0, addressingMode: .immediate ),
            Instruction( mnemonic: "LDY", opcode: 0xA4, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDY", opcode: 0xB4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "LSR", opcode: 0x4E, addressingMode: .absolute ),
            Instruction( mnemonic: "LSR", opcode: 0x5E, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LSR", opcode: 0x4A, addressingMode: .accumulator ),
            Instruction( mnemonic: "LSR", opcode: 0x46, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LSR", opcode: 0x56, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "NOP", opcode: 0xEA, addressingMode: .implied ),
            Instruction( mnemonic: "ORA", opcode: 0x0D, addressingMode: .absolute ),
            Instruction( mnemonic: "ORA", opcode: 0x1D, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ORA", opcode: 0x19, addressingMode: .absoluteY ),
            Instruction( mnemonic: "ORA", opcode: 0x09, addressingMode: .immediate ),
            Instruction( mnemonic: "ORA", opcode: 0x01, addressingMode: .indirectX ),
            Instruction( mnemonic: "ORA", opcode: 0x11, addressingMode: .indirectY ),
            Instruction( mnemonic: "ORA", opcode: 0x05, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ORA", opcode: 0x15, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "PHA", opcode: 0x48, addressingMode: .implied ),
            Instruction( mnemonic: "PHP", opcode: 0x08, addressingMode: .implied ),
            Instruction( mnemonic: "PLA", opcode: 0x68, addressingMode: .implied ),
            Instruction( mnemonic: "PLP", opcode: 0x28, addressingMode: .implied ),
            Instruction( mnemonic: "ROL", opcode: 0x2E, addressingMode: .absolute ),
            Instruction( mnemonic: "ROL", opcode: 0x3E, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ROL", opcode: 0x2A, addressingMode: .accumulator ),
            Instruction( mnemonic: "ROL", opcode: 0x26, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ROL", opcode: 0x36, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "ROR", opcode: 0x6E, addressingMode: .absolute ),
            Instruction( mnemonic: "ROR", opcode: 0x7E, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ROR", opcode: 0x6A, addressingMode: .accumulator ),
            Instruction( mnemonic: "ROR", opcode: 0x66, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ROR", opcode: 0x76, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "RTI", opcode: 0x40, addressingMode: .implied ),
            Instruction( mnemonic: "RTS", opcode: 0x60, addressingMode: .implied ),
            Instruction( mnemonic: "SBC", opcode: 0xED, addressingMode: .absolute ),
            Instruction( mnemonic: "SBC", opcode: 0xFD, addressingMode: .absoluteX ),
            Instruction( mnemonic: "SBC", opcode: 0xF9, addressingMode: .absoluteY ),
            Instruction( mnemonic: "SBC", opcode: 0xE9, addressingMode: .immediate ),
            Instruction( mnemonic: "SBC", opcode: 0xE1, addressingMode: .indirectX ),
            Instruction( mnemonic: "SBC", opcode: 0xF1, addressingMode: .indirectY ),
            Instruction( mnemonic: "SBC", opcode: 0xE5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "SBC", opcode: 0xF5, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "SEC", opcode: 0x38, addressingMode: .implied ),
            Instruction( mnemonic: "SED", opcode: 0xF8, addressingMode: .implied ),
            Instruction( mnemonic: "SEI", opcode: 0x78, addressingMode: .implied ),
            Instruction( mnemonic: "STA", opcode: 0x8D, addressingMode: .absolute ),
            Instruction( mnemonic: "STA", opcode: 0x9D, addressingMode: .absoluteX ),
            Instruction( mnemonic: "STA", opcode: 0x99, addressingMode: .absoluteY ),
            Instruction( mnemonic: "STA", opcode: 0x81, addressingMode: .indirectX ),
            Instruction( mnemonic: "STA", opcode: 0x91, addressingMode: .indirectY ),
            Instruction( mnemonic: "STA", opcode: 0x85, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STA", opcode: 0x95, addressingMode: .zeroPageY ),
            Instruction( mnemonic: "STX", opcode: 0x8E, addressingMode: .absolute ),
            Instruction( mnemonic: "STX", opcode: 0x86, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STX", opcode: 0x96, addressingMode: .zeroPageY ),
            Instruction( mnemonic: "STY", opcode: 0x8C, addressingMode: .absolute ),
            Instruction( mnemonic: "STY", opcode: 0x84, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STY", opcode: 0x94, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "TAX", opcode: 0xAA, addressingMode: .implied ),
            Instruction( mnemonic: "TAY", opcode: 0xA8, addressingMode: .implied ),
            Instruction( mnemonic: "TSX", opcode: 0xBA, addressingMode: .implied ),
            Instruction( mnemonic: "TXA", opcode: 0x8A, addressingMode: .implied ),
            Instruction( mnemonic: "TXS", opcode: 0x9A, addressingMode: .implied ),
            Instruction( mnemonic: "TYA", opcode: 0x98, addressingMode: .implied ),
        ]
}

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
    public enum AddressingMode: CustomStringConvertible
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

        public var description: String
        {
            switch self
            {
                case .implied:     return "Implied"
                case .accumulator: return "Accumulator"
                case .immediate:   return "Immediate"
                case .zeroPage:    return "ZeroPage"
                case .zeroPageX:   return "ZeroPage,X"
                case .zeroPageY:   return "ZeroPage,Y"
                case .relative:    return "Relative"
                case .absolute:    return "Absolute"
                case .absoluteX:   return "Absolute,X"
                case .absoluteY:   return "Absolute,Y"
                case .indirect:    return "(Indirect)"
                case .indirectX:   return "(Indirect,X)"
                case .indirectY:   return "(Indirect),Y"
            }
        }
    }

    public var mnemonic:       String
    public var opcode:         UInt8
    public var size:           UInt
    public var cycles:         UInt
    public var addressingMode: AddressingMode

    public init( mnemonic: String, opcode: UInt8, size: UInt, cycles: UInt, addressingMode: AddressingMode )
    {
        self.mnemonic       = mnemonic
        self.opcode         = opcode
        self.size           = size
        self.cycles         = cycles
        self.addressingMode = addressingMode
    }

    public static let all =
        [
            Instruction( mnemonic: "ADC", opcode: 0x6D, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "ADC", opcode: 0x7D, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ADC", opcode: 0x79, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "ADC", opcode: 0x69, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "ADC", opcode: 0x61, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "ADC", opcode: 0x71, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "ADC", opcode: 0x65, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ADC", opcode: 0x75, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "AND", opcode: 0x2D, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "AND", opcode: 0x3D, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "AND", opcode: 0x39, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "AND", opcode: 0x29, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "AND", opcode: 0x21, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "AND", opcode: 0x31, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "AND", opcode: 0x25, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "AND", opcode: 0x35, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "ASL", opcode: 0x0E, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "ASL", opcode: 0x1E, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ASL", opcode: 0x0A, size: 1, cycles: 2, addressingMode: .accumulator ),
            Instruction( mnemonic: "ASL", opcode: 0x06, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ASL", opcode: 0x16, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "BCC", opcode: 0x90, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BCS", opcode: 0xB0, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BEQ", opcode: 0xF0, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BIT", opcode: 0x2C, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "BIT", opcode: 0x24, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "BMI", opcode: 0x30, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BNE", opcode: 0xD0, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BPL", opcode: 0x10, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BRK", opcode: 0x00, size: 1, cycles: 7, addressingMode: .implied ),
            Instruction( mnemonic: "BVC", opcode: 0x50, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "BVS", opcode: 0x70, size: 2, cycles: 2, addressingMode: .relative ),
            Instruction( mnemonic: "CLC", opcode: 0x18, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "CLD", opcode: 0xD8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "CLI", opcode: 0x58, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "CLV", opcode: 0xB8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "CMP", opcode: 0xCD, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "CMP", opcode: 0xDD, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "CMP", opcode: 0xD9, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "CMP", opcode: 0xC9, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "CMP", opcode: 0xC1, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "CMP", opcode: 0xD1, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "CMP", opcode: 0xC5, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "CMP", opcode: 0xD5, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "CPX", opcode: 0xEC, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "CPX", opcode: 0xE0, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "CPX", opcode: 0xE4, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "CPY", opcode: 0xCC, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "CPY", opcode: 0xC0, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "CPY", opcode: 0xC4, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "DEC", opcode: 0xCE, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "DEC", opcode: 0xDE, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "DEC", opcode: 0xC6, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "DEC", opcode: 0xD6, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "DEX", opcode: 0xCA, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "DEY", opcode: 0x88, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "EOR", opcode: 0x4D, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "EOR", opcode: 0x5D, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "EOR", opcode: 0x59, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "EOR", opcode: 0x49, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "EOR", opcode: 0x41, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "EOR", opcode: 0x51, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "EOR", opcode: 0x45, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "EOR", opcode: 0x55, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "INC", opcode: 0xEE, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "INC", opcode: 0xFE, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "INC", opcode: 0xE6, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "INC", opcode: 0xF6, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "INX", opcode: 0xE8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "INY", opcode: 0xC8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "JMP", opcode: 0x4C, size: 3, cycles: 3, addressingMode: .absolute ),
            Instruction( mnemonic: "JMP", opcode: 0x6C, size: 3, cycles: 5, addressingMode: .indirect ),
            Instruction( mnemonic: "JSR", opcode: 0x20, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "LDA", opcode: 0xAD, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "LDA", opcode: 0xBD, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LDA", opcode: 0xB9, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "LDA", opcode: 0xA9, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "LDA", opcode: 0xA1, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "LDA", opcode: 0xB1, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "LDA", opcode: 0xA5, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDA", opcode: 0xB5, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "LDX", opcode: 0xAE, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "LDX", opcode: 0xBE, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "LDX", opcode: 0xA2, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "LDX", opcode: 0xA6, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDX", opcode: 0xB6, size: 2, cycles: 4, addressingMode: .zeroPageY ),
            Instruction( mnemonic: "LDY", opcode: 0xAC, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "LDY", opcode: 0xBC, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LDY", opcode: 0xA0, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "LDY", opcode: 0xA4, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LDY", opcode: 0xB4, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "LSR", opcode: 0x4E, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "LSR", opcode: 0x5E, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "LSR", opcode: 0x4A, size: 1, cycles: 2, addressingMode: .accumulator ),
            Instruction( mnemonic: "LSR", opcode: 0x46, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "LSR", opcode: 0x56, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "NOP", opcode: 0xEA, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "ORA", opcode: 0x0D, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "ORA", opcode: 0x1D, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ORA", opcode: 0x19, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "ORA", opcode: 0x09, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "ORA", opcode: 0x01, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "ORA", opcode: 0x11, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "ORA", opcode: 0x05, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ORA", opcode: 0x15, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "PHA", opcode: 0x48, size: 1, cycles: 3, addressingMode: .implied ),
            Instruction( mnemonic: "PHP", opcode: 0x08, size: 1, cycles: 3, addressingMode: .implied ),
            Instruction( mnemonic: "PLA", opcode: 0x68, size: 1, cycles: 4, addressingMode: .implied ),
            Instruction( mnemonic: "PLP", opcode: 0x28, size: 1, cycles: 4, addressingMode: .implied ),
            Instruction( mnemonic: "ROL", opcode: 0x2E, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "ROL", opcode: 0x3E, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ROL", opcode: 0x2A, size: 1, cycles: 2, addressingMode: .accumulator ),
            Instruction( mnemonic: "ROL", opcode: 0x26, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ROL", opcode: 0x36, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "ROR", opcode: 0x6E, size: 3, cycles: 6, addressingMode: .absolute ),
            Instruction( mnemonic: "ROR", opcode: 0x7E, size: 3, cycles: 7, addressingMode: .absoluteX ),
            Instruction( mnemonic: "ROR", opcode: 0x6A, size: 1, cycles: 2, addressingMode: .accumulator ),
            Instruction( mnemonic: "ROR", opcode: 0x66, size: 2, cycles: 5, addressingMode: .zeroPage ),
            Instruction( mnemonic: "ROR", opcode: 0x76, size: 2, cycles: 6, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "RTI", opcode: 0x40, size: 1, cycles: 6, addressingMode: .implied ),
            Instruction( mnemonic: "RTS", opcode: 0x60, size: 1, cycles: 6, addressingMode: .implied ),
            Instruction( mnemonic: "SBC", opcode: 0xED, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "SBC", opcode: 0xFD, size: 3, cycles: 4, addressingMode: .absoluteX ),
            Instruction( mnemonic: "SBC", opcode: 0xF9, size: 3, cycles: 4, addressingMode: .absoluteY ),
            Instruction( mnemonic: "SBC", opcode: 0xE9, size: 2, cycles: 2, addressingMode: .immediate ),
            Instruction( mnemonic: "SBC", opcode: 0xE1, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "SBC", opcode: 0xF1, size: 2, cycles: 5, addressingMode: .indirectY ),
            Instruction( mnemonic: "SBC", opcode: 0xE5, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "SBC", opcode: 0xF5, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "SEC", opcode: 0x38, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "SED", opcode: 0xF8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "SEI", opcode: 0x78, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "STA", opcode: 0x8D, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "STA", opcode: 0x9D, size: 3, cycles: 5, addressingMode: .absoluteX ),
            Instruction( mnemonic: "STA", opcode: 0x99, size: 3, cycles: 5, addressingMode: .absoluteY ),
            Instruction( mnemonic: "STA", opcode: 0x81, size: 2, cycles: 6, addressingMode: .indirectX ),
            Instruction( mnemonic: "STA", opcode: 0x91, size: 2, cycles: 6, addressingMode: .indirectY ),
            Instruction( mnemonic: "STA", opcode: 0x85, size: 2, cycles: 3, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STA", opcode: 0x95, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "STX", opcode: 0x8E, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "STX", opcode: 0x86, size: 2, cycles: 2, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STX", opcode: 0x96, size: 2, cycles: 4, addressingMode: .zeroPageY ),
            Instruction( mnemonic: "STY", opcode: 0x8C, size: 3, cycles: 4, addressingMode: .absolute ),
            Instruction( mnemonic: "STY", opcode: 0x84, size: 2, cycles: 2, addressingMode: .zeroPage ),
            Instruction( mnemonic: "STY", opcode: 0x94, size: 2, cycles: 4, addressingMode: .zeroPageX ),
            Instruction( mnemonic: "TAX", opcode: 0xAA, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "TAY", opcode: 0xA8, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "TSX", opcode: 0xBA, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "TXA", opcode: 0x8A, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "TXS", opcode: 0x9A, size: 1, cycles: 2, addressingMode: .implied ),
            Instruction( mnemonic: "TYA", opcode: 0x98, size: 1, cycles: 2, addressingMode: .implied ),
        ]
}

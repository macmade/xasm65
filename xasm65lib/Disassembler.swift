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
import XSLabsSwift

public class Disassembler
{
    private let origin:       UInt16
    private var address:      UInt64
    private var size:         UInt64
    private var instructions: UInt64
    private let stream:       ByteStream
    private let options:      Options
    private var separator:    String
    private var comments:     [ UInt16: String ]
    private var labels:       [ UInt16: String ]

    public struct Options: OptionSet
    {
        public static var address:     Options { Options( rawValue: 1 << 0 ) }
        public static var bytes:       Options { Options( rawValue: 1 << 1 ) }
        public static var labels:      Options { Options( rawValue: 1 << 3 ) }
        public static var disassembly: Options { Options( rawValue: 1 << 4 ) }
        public static var comments:    Options { Options( rawValue: 1 << 5 ) }

        public let rawValue: Int

        public init( rawValue: Int )
        {
            self.rawValue = rawValue
        }
    }

    public class func disassemble( stream: ByteStream, origin: UInt16, size: UInt64, options: Options, separator: String = "    ", comments: [ UInt16: String ] = [ : ], labels: [ UInt16: String ] = [ : ] ) throws -> String
    {
        if size == 0
        {
            throw RuntimeError( message: "Invalid size: \( size )" )
        }

        return try Disassembler( stream: stream, origin: origin, size: size, instructions: 0, options: options, separator: separator, comments: comments, labels: labels ).disassemble()
    }

    public class func disassemble( stream: ByteStream, origin: UInt16, instructions: UInt64, options: Options, separator: String = "    ", comments: [ UInt16: String ] = [ : ], labels: [ UInt16: String ] = [ : ] ) throws -> String
    {
        if instructions == 0
        {
            throw RuntimeError( message: "Invalid instruction count: \( instructions )" )
        }

        return try Disassembler( stream: stream, origin: origin, size: 0, instructions: instructions, options: options, separator: separator, comments: comments, labels: labels ).disassemble()
    }

    public init( stream: ByteStream, origin: UInt16, size: UInt64, instructions: UInt64, options: Options, separator: String, comments: [ UInt16: String ], labels: [ UInt16: String ] ) throws
    {
        self.origin       = origin
        self.address      = UInt64( origin )
        self.size         = size
        self.instructions = instructions
        self.stream       = stream
        self.options      = options.isEmpty ? [ .address, .bytes, .labels, .disassembly, .comments ] : options
        self.separator    = separator
        self.comments     = comments
        self.labels       = labels
    }

    private var dataAvailable: Bool
    {
        return true
    }

    public func disassemble() throws -> String
    {
        var instructions: [ ( address: UInt64, bytes: [ UInt8 ], disassembly: String, label: String?, comment: String? ) ] = []

        while true
        {
            instructions.append( try self.disassembleInstruction() )

            if self.instructions > 0, instructions.count == self.instructions
            {
                break
            }
            else if self.size > 0, self.address - UInt64( self.origin ) >= self.size
            {
                break
            }
        }

        let hasLabels   = instructions.first { $0.label?.isEmpty   == false } != nil && self.options.contains( .labels )
        let hasComments = instructions.first { $0.comment?.isEmpty == false } != nil && self.options.contains( .comments )

        let strings = instructions.map
        {
            (
                address:     String( format: "%04X:", $0.address ),
                bytes:       $0.bytes.map { String( format: "%02X", $0 ) }.joined( separator: " " ),
                label:       $0.label ?? "",
                disassembly: $0.disassembly,
                comment:     $0.comment ?? ""
            )
        }
        .map
        {
            var components: [ String ] = []

            if self.options.contains( .address     ) { components.append( $0.address ) }
            if self.options.contains( .bytes       ) { components.append( $0.bytes ) }
            if hasLabels                             { components.append( $0.label ) }
            if self.options.contains( .disassembly ) { components.append( $0.disassembly ) }
            if hasComments                           { components.append( $0.comment.isEmpty ? "" : "; \( $0.comment )" ) }

            return components
        }

        return String.aligningComponents( in: strings, componentSeparator: self.separator, lineSeparator: "\n" )
    }

    private func readUInt8() throws -> UInt8
    {
        let value     = try self.stream.readUInt8()
        self.address += 1

        return value
    }

    private func readUInt16() throws -> UInt16
    {
        let u1 = UInt16( try self.readUInt8() )
        let u2 = UInt16( try self.readUInt8() )

        return ( u2 << 8 ) | u1
    }

    private func disassembleInstruction() throws -> ( address: UInt64, bytes: [ UInt8 ], disassembly: String, label: String?, comment: String? )
    {
        let address = self.address

        if address == 0xFFFA
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(NMI: LSB)" )
        }
        else if address == 0xFFFB
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(NMI: MSB)" )
        }
        else if address == 0xFFFC
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(RESET: LSB)" )
        }
        else if address == 0xFFFD
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(RESET: MSB)" )
        }
        else if address == 0xFFFE
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(IRQ: LSB)" )
        }
        else if address == 0xFFFF
        {
            let byte = try self.readUInt8()

            return ( address, [ byte ], String( format: "db $%02X", byte ), nil, "(IRQ: MSB)" )
        }
        else if address > UInt16.max
        {
            throw RuntimeError( message: "Invalid address: \( String( format: "%X", address ) )" )
        }

        let opcode = try self.readUInt8()

        guard let instruction = Instruction.all.first( where: { $0.opcode == opcode } )
        else
        {
            return ( address, [ opcode ], "???", nil, nil )
        }

        if self.size > 0, ( address - UInt64( self.origin ) ) + UInt64( instruction.size ) > self.size
        {
            return ( address, [ opcode ], "???", nil, nil )
        }

        var bytes       = [ opcode ]
        var disassembly = [ instruction.mnemonic ]

        switch instruction.addressingMode
        {
            case .implied:

                break

            case .accumulator:

                disassembly.append( "A" )

            case .immediate:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "#$\( String( format: "%02X", value ) )" )

            case .zeroPage:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "$\( String( format: "%02X", value ) )" )

            case .zeroPageX:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "$\( String( format: "%02X", value ) ),X" )

            case .zeroPageY:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "$\( String( format: "%02X", value ) ),Y" )

            case .relative:

                let value  = try self.readUInt8()
                let signed = Int8( bitPattern: value )

                bytes.append( value )

                if signed > 0
                {
                    disassembly.append( "*+\( signed )" )
                }
                else
                {
                    disassembly.append( "*\( signed )" )
                }

            case .absolute:

                let value = try self.readUInt16()

                bytes.append( UInt8( value & 0xFF ) )
                bytes.append( UInt8( ( value >> 8 ) & 0xFF ) )
                disassembly.append( "$\( String( format: "%04X", value ) )" )

            case .absoluteX:

                let value = try self.readUInt16()

                bytes.append( UInt8( value & 0xFF ) )
                bytes.append( UInt8( ( value >> 8 ) & 0xFF ) )
                disassembly.append( "$\( String( format: "%04X", value ) ),X" )

            case .absoluteY:

                let value = try self.readUInt16()

                bytes.append( UInt8( value & 0xFF ) )
                bytes.append( UInt8( ( value >> 8 ) & 0xFF ) )
                disassembly.append( "$\( String( format: "%04X", value ) ),Y" )

            case .indirect:

                let value = try self.readUInt16()

                bytes.append( UInt8( value & 0xFF ) )
                bytes.append( UInt8( ( value >> 8 ) & 0xFF ) )
                disassembly.append( "($\( String( format: "%04X", value ) ))" )

            case .indirectX:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "($\( String( format: "%02X", value ) ),X)" )

            case .indirectY:

                let value = try self.readUInt8()

                bytes.append( value )
                disassembly.append( "($\( String( format: "%02X", value ) )),Y" )
        }

        return (
            address,
            bytes,
            disassembly.joined( separator: " " ),
            address > UInt16.max ? nil : self.labels[   UInt16( address & 0xFFFF ) ],
            address > UInt16.max ? nil : self.comments[ UInt16( address & 0xFFFF ) ]
        )
    }
}

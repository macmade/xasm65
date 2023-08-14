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

public class Disassembler
{
    private let origin:  UInt16
    private let data:    Data
    private let options: Options
    private var offset:  Int = 0

    public struct Options: OptionSet
    {
        public static var address:     Options { Options( rawValue: 1 << 0 ) }
        public static var bytes:       Options { Options( rawValue: 1 << 1 ) }
        public static var disassembly: Options { Options( rawValue: 1 << 2 ) }

        public let rawValue: Int

        public init( rawValue: Int )
        {
            self.rawValue = rawValue
        }
    }

    public convenience init( url: URL, origin: UInt16, options: Options ) throws
    {
        try self.init( data: try Data( contentsOf: url ), origin: origin, options: options )
    }

    public init( data: Data, origin: UInt16, options: Options ) throws
    {
        self.origin  = origin
        self.data    = data
        self.options = options

        if self.options.isEmpty
        {
            self.options = [ .address, .bytes, .disassembly ]
        }
    }

    private var dataAvailable: Bool
    {
        self.offset < self.data.count
    }

    public func disassemble() throws -> String
    {
        self.offset = 0

        var instructions: [ ( address: UInt64, bytes: [ UInt8 ], disassembly: String ) ] = []

        while self.dataAvailable
        {
            instructions.append( try self.disassembleInstruction() )
        }

        let strings = instructions.map
        {
            (
                address:     String( format: "%04X", $0.address ),
                bytes:       $0.bytes.map { String( format: "%02X", $0 ) }.joined( separator: " " ),
                disassembly: $0.disassembly
            )
        }

        let maxAddress = strings.reduce( 0 )
        {
            $0 > $1.address.count ? $0 : $1.address.count
        }

        let maxBytes = strings.reduce( 0 )
        {
            $0 > $1.bytes.count ? $0 : $1.bytes.count
        }

        return strings.map
        {
            let address     = $0.address.padding( toLength: maxAddress, withPad: " ", startingAt: 0 )
            let bytes       = $0.bytes.padding(   toLength: maxBytes,   withPad: " ", startingAt: 0 )
            let disassembly = $0.disassembly
            var strings     = [ String ]()

            if self.options.contains( .address )
            {
                strings.append( "\( address ):" )
            }

            if self.options.contains( .bytes )
            {
                strings.append( bytes )
            }

            if self.options.contains( .disassembly )
            {
                strings.append( disassembly )
            }

            return strings.joined( separator: "    " )
        }
        .joined( separator: "\n" )
    }

    private func readUInt8() throws -> UInt8
    {
        guard self.offset < self.data.count
        else
        {
            throw RuntimeError( message: "Index out of bounds: \( self.offset )" )
        }

        let u        = self.data[ self.offset ]
        self.offset += 1

        return u
    }

    private func readUInt16() throws -> UInt16
    {
        let u1 = UInt16( try self.readUInt8() )
        let u2 = UInt16( try self.readUInt8() )

        return ( u2 << 8 ) | u1
    }

    private func disassembleInstruction() throws -> ( UInt64, [ UInt8 ], String )
    {
        let address = UInt64( self.origin ) + UInt64( self.offset )

        if address == 0xFFFA, self.offset + 2 <= self.data.count
        {
            let value = try self.readUInt16()

            return ( address, [ UInt8( value & 0xFF ), UInt8( ( value >> 8 ) & 0xFF ) ], "(NMI)" )
        }
        else if address == 0xFFFC, self.offset + 2 <= self.data.count
        {
            let value = try self.readUInt16()

            return ( address, [ UInt8( value & 0xFF ), UInt8( ( value >> 8 ) & 0xFF ) ], "(RESET)" )
        }
        else if address == 0xFFFE, self.offset + 2 <= self.data.count
        {
            let value = try self.readUInt16()

            return ( address, [ UInt8( value & 0xFF ), UInt8( ( value >> 8 ) & 0xFF ) ], "(IRQ)" )
        }

        let opcode = try self.readUInt8()

        guard let instruction = Instruction.all.first( where: { $0.opcode == opcode } )
        else
        {
            return ( address, [ opcode ], "???" )
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

        return ( address, bytes, disassembly.joined( separator: " " ) )
    }
}

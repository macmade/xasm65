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

public class AssemblerInstruction
{
    public private( set ) var line:     UInt
    public private( set ) var label:    String?
    public private( set ) var mnemonic: String
    public private( set ) var operand:  String?

    public init( line: UInt, tokens: [ String ], variables: [ AssemblerVariable ] ) throws
    {
        guard tokens.isEmpty == false
        else
        {
            throw SyntaxError( line: line, message: "Instruction expected" )
        }

        var tokens = tokens

        if Instruction.all.filter( { $0.mnemonic == tokens[ 0 ] } ).isEmpty
        {
            self.label = tokens.removeFirst()
        }

        guard tokens.isEmpty == false
        else
        {
            throw SyntaxError( line: line, message: "Instruction expected" )
        }

        self.line     = line
        self.mnemonic = tokens.removeFirst()

        let instructions = Instruction.all.filter
        {
            $0.mnemonic == self.mnemonic
        }

        guard instructions.isEmpty == false
        else
        {
            throw SyntaxError( line: line, message: "Unrecognized instruction \( self.mnemonic )" )
        }

        guard let mode = AssemblerInstruction.addressingMode( for: tokens.first, variables: variables )
        else
        {
            throw SyntaxError( line: line, message: "Unable to infer the addressing mode for instruction \( self.mnemonic )" )
        }

        guard let _ = instructions.first( where: { $0.addressingMode == mode } )
        else
        {
            throw SyntaxError( line: line, message: "Invalid addressing mode for instruction \( self.mnemonic ) \( mode.description )" )
        }
    }

    public class func addressingMode( for operand: String?, variables: [ AssemblerVariable ] ) -> Instruction.AddressingMode?
    {
        guard let operand = variables.first( where: { $0.name == operand } )?.value ?? operand
        else
        {
            return .implied
        }

        if operand == "A"
        {
            return .accumulator
        }
        
        return nil
    }
}

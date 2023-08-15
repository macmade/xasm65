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

public class Assembler
{
    private let source: String

    public class func assemble( url: URL ) throws -> Data
    {
        try self.assemble( data: try Data( contentsOf: url ) )
    }

    public class func assemble( data: Data ) throws -> Data
    {
        guard let source = String( data: data, encoding: .utf8 )
        else
        {
            throw RuntimeError( message: "Cannot read data" )
        }

        return try self.assemble( source: source )
    }

    public class func assemble( source: String ) throws -> Data
    {
        try Assembler( source: source ).assemble()
    }

    private init( source: String ) throws
    {
        self.source = source
    }

    private func assemble() throws -> Data
    {
        let components = try Assembler.components( in: Assembler.tokens( in: self.source ) )

        let variables = components.variables.map
        {
            [ "    \( $0.line ):", $0.name, "=", $0.value ]
        }

        let instructions = components.instructions.map
        {
            [ "    \( $0.line ):", $0.label ?? "", $0.mnemonic, $0.operand ?? "" ]
        }

        print( "Variables: " )
        print( String.aligningComponents( in: variables, componentSeparator: " ", lineSeparator: "\n" ) )
        print( "Instructions: " )
        print( String.aligningComponents( in: instructions, componentSeparator: " ", lineSeparator: "\n" ) )

        return Data()
    }

    private class func lines( in source: String ) -> [ ( line: UInt, text: String ) ]
    {
        source.components( separatedBy: "\n" ).enumerated().map
        {
            ( line: UInt( $0.offset + 1 ), text: $0.element )
        }
    }

    private class func stripComments( in lines: [ ( line: UInt, text: String ) ] ) -> [ ( line: UInt, text: String ) ]
    {
        lines.map
        {
            guard let r = $0.text.range( of: ";" )
            else
            {
                return $0
            }

            return ( line: $0.line, text: String( $0.text[ $0.text.startIndex ..< r.lowerBound ] ) )
        }
    }

    private class func tokens( in source: String ) -> [ ( line: UInt, tokens: [ String ] ) ]
    {
        self.stripComments( in: self.lines( in: source ) ).filter
        {
            $0.text.trimmingCharacters( in: .whitespaces ).isEmpty == false
        }
        .map
        {
            (
                line:   $0.line,
                tokens: $0.text.components( separatedBy: .whitespaces ).filter
                {
                    $0.isEmpty == false
                }
            )
        }
    }

    public class func components( in tokens: [ ( line: UInt, tokens: [ String ] ) ] ) throws -> ( instructions: [ AssemblerInstruction ], variables: [ AssemblerVariable ] )
    {
        let variables = tokens.filter
        {
            guard $0.tokens.count == 3
            else
            {
                return false
            }

            return $0.tokens[ 1 ] == "equ"
        }
        .map
        {
            AssemblerVariable( line: $0.line, name: $0.tokens[ 0 ], value: $0.tokens[ 2 ] )
        }

        try variables.forEach
        {
            variable in if let redefined = variables.first( where: { $0.name == variable.name && $0.line != variable.line } )
            {
                throw SyntaxError( line: redefined.line, message: "Variable \( variable.name ) is already defined at line \( variable.line )" )
            }
        }

        let instructions = try tokens.filter
        {
            token in variables.contains
            {
                $0.line == token.line
            }
            == false
        }
        .map
        {
            try AssemblerInstruction( line: $0.line, tokens: $0.tokens, variables: variables )
        }

        return ( instructions: instructions, variables: variables )
    }
}

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

public extension String
{
    static func aligningComponents( in lines: [ [ String ] ], componentSeparator: String, lineSeparator: String ) -> String
    {
        let max = lines.reduce( into: [ Int ]() )
        {
            max, components in components.enumerated().forEach
            {
                if $0.offset < max.count
                {
                    max[ $0.offset ] = $0.element.count > max[ $0.offset ] ? $0.element.count : max[ $0.offset ]
                }
                else
                {
                    max.append( $0.element.count )
                }
            }
        }

        return lines.map
        {
            $0.enumerated().map
            {
                $0.element.padding( toLength: max[ $0.offset ], withPad: " ", startingAt: 0 )
            }
            .joined( separator: componentSeparator ).trimmingCharacters( in: .whitespaces )
        }
        .joined( separator: lineSeparator )
    }
}

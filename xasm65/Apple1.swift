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

public class Apple1
{
    private init()
    {}

    public static var rom: ( data: Data, comments: [ UInt16: String ], labels: [ UInt16: String ] )
    {
        get throws
        {
            let data = try Data( contentsOf: Bundle.main.bundleURL.appendingPathComponent( "wozmon.bin" ) )

            return ( data: data, comments: self.romComments, labels: self.romLabels )
        }
    }

    public static var asm: URL
    {
        Bundle.main.bundleURL.appendingPathComponent( "wozmon.s" )
    }

    public static var romComments: [ UInt16: String ]
    {
        [
            0xFF00: "Clear decimal arithmetic mode.",
            0xFF02: "Mask for DSP data direction register.",
            0xFF04: "Set it up.",
            0xFF07: "KBD and DSP control register mask.",
            0xFF09: "Enable interrupts, set CA1, CB1, for",
            0xFF0C: " positive edge sense/output mode.",
            0xFF0F: "\"<-\"?",
            0xFF11: "Yes.",
            0xFF13: "ESC?",
            0xFF15: "Yes.",
            0xFF17: "Advance text index.",
            0xFF18: "Auto ESC if > 127.",
            0xFF1A: "\"\\\".",
            0xFF1C: "Output it.",
            0xFF1F: "CR.",
            0xFF21: "Output it.",
            0xFF24: "Initiallize text index.",
            0xFF26: "Backup text index.",
            0xFF27: "Beyond start of line, reinitialize.",
            0xFF29: "Key ready?",
            0xFF2C: "Loop until ready.",
            0xFF2E: "Load character. B7 should be '1'.",
            0xFF31: "Add to text buffer.",
            0xFF34: "Display character.",
            0xFF37: "CR?",
            0xFF39: "No.",
            0xFF3B: "Reset text index.",
            0xFF3D: "For XAM mode.",
            0xFF3F: "0->X.",
            0xFF40: "Leaves $7B if setting STOR mode.",
            0xFF41: "$00 = XAM, $7B = STOR, $AE = BLOK XAM.",
            0xFF43: "Advance text index.",
            0xFF44: "Get character.",
            0xFF47: "CR?",
            0xFF49: "Yes, done this line.",
            0xFF4B: "\".\"?",
            0xFF4D: "Skip delimiter.",
            0xFF4F: "Set BLOCK XAM mode.",
            0xFF51: "\":\"?",
            0xFF53: "Yes, set STOR mode.",
            0xFF55: "\"R\"?",
            0xFF57: "Yes, run user program.",
            0xFF59: "$00->L.",
            0xFF5B: " and H.",
            0xFF5D: "Save Y for comparison.",
            0xFF5F: "Get character for hex test.",
            0xFF62: "Map digits to $0-9.",
            0xFF64: "Digit?",
            0xFF66: "Yes.",
            0xFF68: "Map letter \"A\"—\"F\" to $FA—FF.",
            0xFF6A: "Hex letter?",
            0xFF6C: "No, character not hex.",
            0xFF6F: "Hex digit to MSD of A.",
            0xFF72: "Shift count.",
            0xFF74: "Hex digit left, MSB to carry.",
            0xFF75: "Rotate into LSD.",
            0xFF77: "Rotate into MSD's.",
            0xFF70: "Done 4 shifts?",
            0xFF7A: "No, loop.",
            0xFF7C: "Advence text index.",
            0xFF7D: "Always taken. Check next character for hex.",
            0xFF7F: "Check if L, H empty (no hex digits).",
            0xFF81: "Yes, generate ESC sequence.",
            0xFF83: "Test MODE byte.",
            0xFF85: "B6 = 0 for STOR, 1 for XAM and BLOCK XAM",
            0xFF87: "LSD's of hex data.",
            0xFF89: "Store at current 'store index'.",
            0xFF8B: "Increment store index.",
            0xFFBD: "Get next item. (no carry).",
            0xFF8F: "Add carry to 'store index' high order.",
            0xFF91: "Get next command item.",
            0xFF94: "Run at current XAM index.",
            0xFF97: "B7 = 0 for XAM, 1 for BLOCK XAM.",
            0xFF99: "Byte count.",
            0xFF9B: "Copy hex data to",
            0xFF9D: " 'store index'.",
            0xFF9F: "And to 'XAM index'.",
            0xFFA1: "Next of 2 bytes.",
            0xFFA2: "Loop unless X = 0.",
            0xFFA4: "NE means no address to print.",
            0xFFA7: "CR.",
            0xFFA8: "Output it.",
            0xFFAB: "'Examine index' high-order byte.",
            0xFFAD: "Output it in hex format.",
            0xFFB0: "Low-order 'examine index' byte.",
            0xFFB2: "Output it in hex format.",
            0xFFB5: "\":\".",
            0xFFB7: "Output it.",
            0xFFBA: "Blank.",
            0xFFBC: "Output it.",
            0xFFBF: "Get data byte at 'examine index'.",
            0xFFC1: "Output it in hex format.",
            0xFFC4: "0-> MODE (XAM mode).",
            0xFFC8: "Compare 'examine index' to hex data.",
            0xFFCE: "Not less, so no more data to output.",
            0xFFD2: "Increment 'examine index'.",
            0xFFD6: "Check low-order 'examine index' byte",
            0xFFD7: " For MOD 8 = 0",
            0xFFDA: "Always taken.",
            0xFFDC: "Save A for LSD.",
            0xFFDF: "MSD to LSD position.",
            0xFFE1: "Output hex digit.",
            0xFFE4: "Restore A.",
            0xFFE5: "Mask LSD for hex print.",
            0xFFE7: "Add \"0\".",
            0xFFE9: "Digit?",
            0xFFEB: "Yes, output it.",
            0xFFED: "Add offset for letter.",
            0xFFEF: "DA bit (B7) cleared yet?",
            0xFFF2: "No, wait for display.",
            0xFFF4: "Output character. Sets DA.",
            0xFFF7: "Return.",
            0xFFF8: "(unused)",
            0xFFF9: "(unused)",
        ]
    }

    public static var romLabels: [ UInt16: String ]
    {
        [
            0xFF00: "RESET",
            0xFF0F: "NOTCR",
            0xFF1A: "ESCAPE",
            0xFF1F: "GETLINE",
            0xFF26: "BACKSPACE",
            0xFF29: "NEXTCHAR",
            0xFF40: "SETSTOR",
            0xFF41: "SETMODE",
            0xFF43: "BLSKIP",
            0xFF44: "NEXT ITEM",
            0xFF5F: "NEXTHEX",
            0xFF6E: "DIG",
            0xFF74: "HEXSHIFT",
            0xFF7F: "NOTHEX",
            0xFF91: "TONEXTITEM",
            0xFF94: "RUN",
            0xFF97: "NOTSTOR",
            0xFF9B: "SETADR",
            0xFFA4: "NXTPRNT",
            0xFFBA: "PRDATA",
            0xFFC4: "XAMNEXT",
            0xFFD6: "MOD8CHK",
            0xFFDC: "PRBYTE",
            0xFFE5: "PRHEX",
            0xFFEF: "ECHO",
        ]
    }
}

/*
"Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it.
After a brief flash, you recognize the interior of the Ceres monitoring station!

As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt;
she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words.
It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them.
Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

..X...
.SAMX.
.A..A.
XMAS.S
.X....

The actual word search will be full of letters instead. For example:

MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX

In this word search, XMAS occurs a total of 18 times; here's the same word search again,
but where letters not involved in any XMAS have been replaced with .:

....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX

Take a look at the little Elf's word search. How many times does XMAS appear?
*/

package AdventOfCode

import "core:fmt"
import "core:strings"

Day4ParserState :: struct {
    strings: [dynamic]string
}

d4LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day4ParserState)(state)
    append(&state^.strings, strings.clone(line))
}

d4p1 :: proc(inputPath: string) -> (count: i64 = 0) {
    state: Day4ParserState
    defer delete(state.strings)
    defer for s in state.strings {
        delete(s)
    }
    parseFileToFunction(inputPath, d4LineParser, &state)

    stringsCount := len(state.strings)
    stringLength := len(state.strings[0])
    for i := 0; i < stringsCount; i += 1 {
        for j := 0; j < stringLength; j += 1 {
            if state.strings[i][j] != 'X' {
                continue
            }
            // DOWN
            if i < stringsCount - 3 {
                if state.strings[i + 1][j] == 'M' && state.strings[i + 2][j] == 'A' && state.strings[i + 3][j] == 'S' {
                    count += 1
                }
                // DOWN RIGHT
                if j < stringLength - 3 \
                  && state.strings[i + 1][j + 1] == 'M' && state.strings[i + 2][j + 2] == 'A' && state.strings[i + 3][j + 3] == 'S' {
                    count += 1
                }
                // DOWN LEFT
                if j > 2 \
                  && state.strings[i + 1][j - 1] == 'M' && state.strings[i + 2][j - 2] == 'A' && state.strings[i + 3][j - 3] == 'S' {
                    count += 1
                }
            }
            // UP
            if i > 2 {
                if state.strings[i - 1][j] == 'M' && state.strings[i - 2][j] == 'A' && state.strings[i - 3][j] == 'S' {
                    count += 1
                }
                // UP RIGHT
                if j < stringLength - 3 \
                  && state.strings[i - 1][j + 1] == 'M' && state.strings[i - 2][j + 2] == 'A' && state.strings[i - 3][j + 3] == 'S' {
                    count += 1
                }
                // UP LEFT
                if j > 2 \
                  && state.strings[i - 1][j - 1] == 'M' && state.strings[i - 2][j - 2] == 'A' && state.strings[i - 3][j - 3] == 'S' {
                    count += 1
                }
            }
            // RIGHT
            if j < stringLength - 3 \
              && state.strings[i][j + 1] == 'M' && state.strings[i][j + 2] == 'A' && state.strings[i][j + 3] == 'S' {
                count += 1
            }
            // LEFT
            if j > 2 \
              && state.strings[i][j - 1] == 'M' && state.strings[i][j - 2] == 'A' && state.strings[i][j - 3] == 'S' {
                count += 1
            }
        }
    }
    return count
}

/*
The Elf looks quizzically at you. Did you misunderstand the assignment?

Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle;
it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

M.S
.A.
M.S

Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

Here's the same example from before, but this time all of the X-MASes have been kept instead:

.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........

In this example, an X-MAS appears 9 times.
*/

d4p2 :: proc(inputPath: string) -> (count: i64 = 0) {
    state: Day4ParserState
    defer delete(state.strings)
    defer for s in state.strings {
        delete(s)
    }
    parseFileToFunction(inputPath, d4LineParser, &state)

    stringsCount := len(state.strings)
    stringLength := len(state.strings[0])
    for i := 1; i < stringsCount - 1; i += 1 {
        for j := 1; j < stringLength - 1; j += 1 {
            if state.strings[i][j] != 'A' {
                continue
            }
            if   ((state.strings[i - 1][j - 1] == 'M' && state.strings[i + 1][j + 1] == 'S') \
               || (state.strings[i - 1][j - 1] == 'S' && state.strings[i + 1][j + 1] == 'M'))\
             &&  ((state.strings[i - 1][j + 1] == 'M' && state.strings[i + 1][j - 1] == 'S') \
               || (state.strings[i - 1][j + 1] == 'S' && state.strings[i + 1][j - 1] == 'M')){
                count += 1
            }
        }
    }
    return count
}

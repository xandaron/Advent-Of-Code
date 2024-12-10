/*
"Our computers are having issues, so I have no idea if we have any Chief Historians in stock!
You're welcome to check the warehouse, though," says the mildly flustered shopkeeper at the North Pole Toboggan Rental Shop.
The Historians head out to take a look.

The shopkeeper turns to you. "Any chance you can see why our computers are having issues again?"

The computer appears to be trying to run a program, but its memory (your puzzle input) is corrupted. All of the instructions have been jumbled up!

It seems like the goal of the program is just to multiply some numbers. It does that with instructions like mul(X,Y),
where X and Y are each 1-3 digit numbers. For instance, mul(44,46) multiplies 44 by 46 to get a result of 2024.
Similarly, mul(123,4) would multiply 123 by 4.

However, because the program's memory has been corrupted, there are also many invalid characters that should be ignored,
even if they look like part of a mul instruction. Sequences like mul(4*, mul(6,9!, ?(12,34), or mul ( 2 , 4 ) do nothing.

For example, consider the following section of corrupted memory:

xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

Only the four highlighted sections are real mul instructions. Adding up the result of each instruction produces 161 (2*4 + 5*5 + 11*8 + 8*5).
*/

package AdventOfCode


import "core:fmt"
import "core:strings"
import "core:text/regex/tokenizer"

Day3ParserState :: struct {
    total: i64,
    doMult: b8
}

d3p1LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day3ParserState)(state)
    a, b: i64 = 0, 0
    lineLength := len(line)
    loop: for i := 0; i < lineLength; i += 1 {
        if line[i] == 'm' && line[i: i + 4] == "mul(" {
            i += 4
            a, b = 0, 0
            for j := i; j < lineLength; j += 1 {
                digit := line[j] - '0'
                if digit >= 0 && digit <= 9 {
                    a *= 10
                    a += i64(digit)
                }
                else if line[j] == ',' {
                    i = j + 1
                    break
                }
                else {
                    i = j - 1
                    continue loop
                }
            }
            for j := i; j < lineLength; j += 1 {
                digit := line[j] - '0'
                if digit >= 0 && digit <= 9 {
                    b *= 10
                    b += i64(digit)
                }
                else if line[j] == ')' {
                    i = j
                    break
                }
                else {
                    i = j - 1
                    continue loop
                }
            }
            state^.total += a * b
        }
    }
}

d3p1 :: proc(inputPath: string) -> i64 {
    state: Day3ParserState
    parseFileToFunction(inputPath, d3p1LineParser, &state)
    return state.total
}

/*
As you scan through the corrupted memory, you notice that some of the conditional statements are also still intact.
If you handle some of the uncorrupted conditional statements in the program, you might be able to get an even more accurate result.

There are two new instructions you'll need to handle:

    The do() instruction enables future mul instructions.
    The don't() instruction disables future mul instructions.

Only the most recent do() or don't() instruction applies. At the beginning of the program, mul instructions are enabled.

For example:

xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))

This corrupted memory is similar to the example from before, but this time the mul(5,5) and mul(11,8) instructions are disabled because there is a
don't() instruction before them. The other mul instructions function normally, including the one at the end that gets re-enabled by a do() instruction.

This time, the sum of the results is 48 (2*4 + 8*5).
*/

d3p2LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day3ParserState)(state)
    a, b: i64 = 0, 0
    lineLength := len(line)
    loop: for i := 0; i < lineLength; i += 1 {
        if state^.doMult && line[i] == 'm' && line[i: i + 4] == "mul(" {
            i += 4
            a, b = 0, 0
            for j := i; j < lineLength; j += 1 {
                digit := line[j] - '0'
                if digit >= 0 && digit <= 9 {
                    a *= 10
                    a += i64(digit)
                }
                else if line[j] == ',' {
                    i = j + 1
                    break
                }
                else {
                    i = j - 1
                    continue loop
                }
            }
            for j := i; j < lineLength; j += 1 {
                digit := line[j] - '0'
                if digit >= 0 && digit <= 9 {
                    b *= 10
                    b += i64(digit)
                }
                else if line[j] == ')' {
                    i = j
                    break
                }
                else {
                    i = j - 1
                    continue loop
                }
            }
            state^.total += a * b
        }
        else if line[i] == 'd' && line[i: i + 4] == "do()" {
            state^.doMult = true
            i += 3
        }
        else if line[i] == 'd' && line[i: i + 7] == "don't()" {
            state^.doMult = false
            i += 6
        }
    }
}

d3p2 :: proc(inputPath: string) -> i64 {
    output: Day3ParserState = {
        doMult = true
    }
    parseFileToFunction(inputPath, d3p2LineParser, &output)
    return output.total
}

/*
The Historians take you to a familiar rope bridge over a river in the middle of a jungle.
The Chief isn't on this side of the bridge, though; maybe he's on the other side?

When you go to cross the bridge, you notice a group of engineers trying to repair it.
(Apparently, it breaks pretty frequently.) You won't be able to cross until it's fixed.

You ask how long it'll take; the engineers tell you that it only needs final calibrations,
but some young elephants were playing nearby and stole all the operators from their calibration equations!
They could finish the calibrations if only someone could determine which test values could possibly be produced by
placing any combination of operators into their calibration equations (your puzzle input).

For example:

190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20

Each line represents a single equation. The test value appears before the colon on each line;
it is your job to determine whether the remaining numbers can be combined with operators to produce the test value.

Operators are always evaluated left-to-right, not according to precedence rules.
Furthermore, numbers in the equations cannot be rearranged. Glancing into the jungle, you can see elephants holding two different types of operators:
add (+) and multiply (*).

Only three of the above equations can be made true by inserting operators:

    190: 10 19 has only one position that accepts an operator: between 10 and 19. Choosing + would give 29,
    but choosing * would give the test value (10 * 19 = 190).
    3267: 81 40 27 has two positions for operators. Of the four possible configurations of the operators,
    two cause the right side to match the test value: 81 + 40 * 27 and 81 * 40 + 27 both equal 3267 (when evaluated left-to-right)!
    292: 11 6 16 20 can be solved in exactly one way: 11 + 6 * 16 + 20.

The engineers just need the total calibration result, which is the sum of the test values from just the equations that could possibly be true.
In the above example, the sum of the test values for the three equations listed above is 3749.

Determine which equations could possibly be true. What is their total calibration result?
*/

package AdventOfCode

import "core:strings"
import "core:math"
import "core:fmt"

Day7ParserState :: struct {
    total: i64
}

d7p1LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day7ParserState)(state)
    numbersStrings := strings.split(line, " ")
    target := stringToInt(numbersStrings[0][0:len(numbersStrings[0]) - 1])
    numbers := make([]i64, len(numbersStrings) - 1)
    defer delete(numbers)
    for i := 1; i < len(numbersStrings); i += 1 {
        numbers[i - 1] = stringToInt(numbersStrings[i])
    }
    for i := 0; i < int(math.pow(2, f64(len(numbers)))) - 1; i += 1 {
        sum := numbers[0]
        for j: u64 = 0; j < u64(len(numbers) - 1); j += 1 {
            if (0b1 << j) & i != 0 {
                sum *= numbers[j + 1]
            }
            else {
                sum += numbers[j + 1]
            }
        }
        if sum == target {
            state^.total += target
            break
        }
    }
}

d7p1 :: proc(inputPath: string) -> i64 {
    state: Day7ParserState
    parseFileToFunction(inputPath, d7p1LineParser, &state)
    return state.total
}

/*
The engineers seem concerned; the total calibration result you gave them is nowhere close to being within safety tolerances.
Just then, you spot your mistake: some well-hidden elephants are holding a third type of operator.

The concatenation operator (||) combines the digits from its left and right inputs into a single number.
For example, 12 || 345 would become 12345. All operators are still evaluated left-to-right.

Now, apart from the three equations that could be made true using only addition and multiplication,
the above example has three more equations that can be made true by inserting operators:

    156: 15 6 can be made true through a single concatenation: 15 || 6 = 156.
    7290: 6 8 6 15 can be made true using 6 * 8 || 6 * 15.
    192: 17 8 14 can be made true using 17 || 8 + 14.

Adding up all six test values (the three that could be made before using only + and * plus the new three that can now be made by also using ||)
produces the new total calibration result of 11387.

Using your new knowledge of elephant hiding spots, determine which equations could possibly be true. What is their total calibration result?
*/

d7p2LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day7ParserState)(state)
    numbersStrings := strings.split(line, " ")
    target := stringToInt(numbersStrings[0][0:len(numbersStrings[0]) - 1])
    numbers := make([]i64, len(numbersStrings) - 1)
    defer delete(numbers)
    for i := 1; i < len(numbersStrings); i += 1 {
        numbers[i - 1] = stringToInt(numbersStrings[i])
    }
    // This code is horrendously slow.
    permutations := int(math.pow(2, f64(len(numbers)))) - 1
    main: for i := 0; i < permutations; i += 1 {
        inner: for j := 0; j < permutations; j += 1 {
            for ; j != 0 && j &~ i == 0; j = (j << 1) {} // This line is strictly unnecessary but allows us to skip some permutations
            sum := numbers[0]
            for k: u64 = 0; k < u64(len(numbers) - 1); k += 1 {
                if (0b1 << k) & i != 0 {
                    sum *= numbers[k + 1]
                }
                else if (0b1 << k) & j != 0 {
                    sum *= i64(math.pow(10, math.floor(math.log10(f64(numbers[k + 1]))) + 1))
                    sum += numbers[k + 1]
                }
                else {
                    sum += numbers[k + 1]
                }
                if sum > target {
                    continue inner
                }
            }
            if sum == target {
                state^.total += target
                break main
            }
        }
    }
}

d7p2 :: proc(inputPath:string) -> i64 {
    state: Day7ParserState
    parseFileToFunction(inputPath, d7p2LineParser, &state)
    return state.total
}

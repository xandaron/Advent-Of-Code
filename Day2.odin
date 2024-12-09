/*
Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's office.

While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian,
the engineers there run up to you as soon as they see you.
Apparently, they still talk about the time Rudolph was saved through molecular synthesis from a single electron.

They're quick to add that - since you're already here - they'd really appreciate your help analyzing some unusual data from the Red-Nosed reactor.
You turn to check if The Historians are waiting for you,
but they seem to have already divided into groups that are currently searching every corner of the facility. You offer to help with the unusual data.
The unusual data (your puzzle input) consists of many reports, one report per line.
Each report is a list of numbers called levels that are separated by spaces. For example:

7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9

This example data contains six reports each containing five levels.

The engineers are trying to figure out which reports are safe.
The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing.
So, a report only counts as safe if both of the following are true:

    The levels are either all increasing or all decreasing.
    Any two adjacent levels differ by at least one and at most three.

In the example above, the reports can be found safe or unsafe by checking those rules:

    7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
    1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
    9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
    1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
    8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
    1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.

So, in this example, 2 reports are safe.
*/

package AdventOfCode

import "core:fmt"
import "core:strings"

Day2ParserOutput :: struct {
    safeCount: i64
}

d2p1LineParser : lineParseFunction : proc(line: string, output: rawptr) {
    output := (^Day2ParserOutput)(output)
    numbers := strings.split(line, " ")

    lastInt := stringToInt(numbers[1])
    direction := lastInt - stringToInt(numbers[0])

    if abs(direction) <= 3 && direction != 0 {
        direction /= abs(direction)
        for i := 2; i < len(numbers); i += 1 {
            number := stringToInt(numbers[i])
            diff := number - lastInt
            if abs(diff) > 3 || diff == 0 || diff / abs(diff) != direction {
                return
            }
            lastInt = number
        }
        output^.safeCount += 1
    }
}

d2p1 :: proc(inputPath: string) -> i64 {
    output: Day2ParserOutput
    parseFileToFunction(inputPath, d2p1LineParser, &output)
    return output.safeCount
}

/*
The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report.
It's like the bad level never happened!

Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

More of the above example's reports are now safe:

    7 6 4 2 1: Safe without removing any level.
    1 2 7 8 9: Unsafe regardless of which level is removed.
    9 7 6 2 1: Unsafe regardless of which level is removed.
    1 3 2 4 5: Safe by removing the second level, 3.
    8 6 4 4 1: Safe by removing the third level, 4.
    1 3 6 7 9: Safe without removing any level.

Thanks to the Problem Dampener, 4 reports are actually safe!
*/

d2p2LineParser : lineParseFunction : proc(line: string, output: rawptr) {
    output := (^Day2ParserOutput)(output)
    numbers := strings.split(line, " ")

    skippedValue := false
    direction: i64 = 0
    lastInt := stringToInt(numbers[1])
    direction = lastInt - stringToInt(numbers[0])

    if abs(direction) <= 3 && direction != 0 {
        direction /= abs(direction)
        for i := 2; i < 4; i += 1 {
            number := stringToInt(numbers[i])
            diff := number - lastInt
            if abs(diff) > 3 || diff == 0 || diff / abs(diff) != direction {
                skippedValue = true
                break
            }
            lastInt = number
        }
    }
    else {
        skippedValue = true
    }
    
    if skippedValue {
        foundWorkingSkip := false
        loop: for i := 0; i < 4; i += 1 {
            direction = 0
            firstInt := true
            for j := 0; j < 4 ; j += 1 {
                if j == i {
                    continue
                }

                if firstInt {
                    firstInt = false
                    lastInt = stringToInt(numbers[j])
                    continue
                }

                number := stringToInt(numbers[j])
                diff := stringToInt(numbers[j]) - lastInt
                if diff == 0 || abs(diff) > 3 {
                    continue loop
                }

                if direction == 0 {
                    direction = diff / abs(diff)
                }
                else if diff / abs(diff) != direction {
                    continue loop
                }
                lastInt = number
            }
            foundWorkingSkip = true
            break
        }
        if !foundWorkingSkip {
            return
        }
    }

    for i := 4; i < len(numbers); i += 1 {
        number := stringToInt(numbers[i])
        diff := number - lastInt
        if abs(diff) > 3 || diff == 0 || diff / abs(diff) != direction {
            if skippedValue {
                return
            }
            skippedValue = true
            continue
        }
        lastInt = number
    }
    output^.safeCount += 1
}

d2p2 :: proc(inputPath: string) -> (safeCount: i64 = 0) {
    output: Day2ParserOutput
    parseFileToFunction(inputPath, d2p2LineParser, &output)
    return output.safeCount
}
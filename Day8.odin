/*
You find yourselves on the roof of a top-secret Easter Bunny installation.

While The Historians do their thing, you take a look at the familiar huge antenna. Much to your surprise,
it seems to have been reconfigured to emit a signal that makes people 0.1% more likely to buy Easter Bunny brand Imitation Mediocre
Chocolate as a Christmas gift! Unthinkable!

Scanning across the city, you find that there are actually many such antennas.
Each antenna is tuned to a specific frequency indicated by a single lowercase letter,
uppercase letter, or digit. You create a map (your puzzle input) of these antennas. For example:

............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............

The signal only applies its nefarious effect at specific antinodes based on the resonant frequencies of the antennas. In particular,
an antinode occurs at any point that is perfectly in line with two antennas of the same frequency -
but only when one of the antennas is twice as far away as the other.
This means that for any pair of antennas with the same frequency, there are two antinodes, one on either side of them.

So, for these two antennas with frequency a, they create the two antinodes marked with #:

..........
...#......
..........
....a.....
..........
.....a....
..........
......#...
..........
..........

Adding a third antenna with the same frequency creates several more antinodes.
It would ideally add four antinodes, but two are off the right side of the map, so instead it adds only two:

..........
...#......
#.........
....a.....
........a.
.....a....
..#.......
......#...
..........
..........

Antennas with different frequencies don't create antinodes; A and a count as different frequencies. However,
antinodes can occur at locations that contain antennas.
In this diagram, the lone antenna with frequency capital A creates no antinodes but has a lowercase-a-frequency antinode at its location:

..........
...#......
#.........
....a.....
........a.
.....a....
..#.......
......A...
..........
..........

The first example has antennas with two different frequencies, so the antinodes they create look like this
plus an antinode overlapping the topmost A-frequency antenna:

......#....#
...#....0...
....#0....#.
..#....0....
....0....#..
.#....A.....
...#........
#......#....
........A...
.........A..
..........#.
..........#.

Because the topmost A-frequency antenna overlaps with a 0-frequency antinode,
there are 14 total unique locations that contain an antinode within the bounds of the map.

Calculate the impact of the signal. How many unique locations within the bounds of the map contain an antinode?
*/

package AdventOfCode

import "core:strings"

Day8ParserState :: struct {
    lines: [dynamic]string
}

d8LineParser : lineParseFunction : proc(line: string, state: rawptr) {
    state := (^Day8ParserState)(state)
    append(&state.lines, strings.clone(line))
}

d8p1 :: proc(inputPath: string) -> (nodeCount: i64 = 0) {
    state: Day8ParserState
    defer {
        for line in state.lines {
            delete(line)
        }
        delete(state.lines)
    }
    parseFileToFunction(inputPath, d8LineParser, &state)

    maxX := len(state.lines[0])
    maxY := len(state.lines)
    
    antinodes: [dynamic][2]int
    defer delete(antinodes)

    for char: u8 = '0'; char <= 'z'; char += 1 {
        locations: [dynamic][2]int
        defer delete(locations)

        for x := 0; x < maxX; x += 1 {
            for y := 0; y < maxY; y += 1 {
                if state.lines[y][x] == char {
                    append(&locations, ([2]int)({x, y}))
                }
            }
        }

        for i := 0; i < len(locations) - 1; i += 1 {
            for j := i + 1; j < len(locations); j += 1 {
                relativePosition := locations[i] - locations[j]
                pos1 := locations[i] + relativePosition
                pos2 := locations[j] - relativePosition
                
                contains1 := false
                contains2 := false
                for node in antinodes {
                    if node == pos1 {
                        contains1 = true
                    }
                    else if node == pos2 {
                        contains2 = true
                    }
                }

                if !contains1 && pos1.x >= 0 && pos1.x < maxX && pos1.y >= 0 && pos1.y < maxY {
                    append(&antinodes, pos1)
                    nodeCount += 1
                }
                if !contains2 && pos2.x >= 0 && pos2.x < maxX && pos2.y >= 0 && pos2.y < maxY {
                    append(&antinodes, pos2)
                    nodeCount += 1
                }
            }
        }
    }
    return
}

/*
Watching over your shoulder as you work, one of The Historians asks if you took the effects of resonant harmonics into your calculations.

Whoops!

After updating your model, it turns out that an antinode occurs at any grid position exactly in line with at least two antennas of the same frequency,
regardless of distance. This means that some of the new antinodes will occur at the position of each antenna (unless that antenna is the only one of its frequency).

So, these three T-frequency antennas now create many antinodes:

T....#....
...T......
.T....#...
.........#
..#.......
..........
...#......
..........
....#.....
..........

In fact, the three T-frequency antennas are all exactly in line with two antennas, so they are all also antinodes!
This brings the total number of antinodes in the above example to 9.

The original example now has 34 antinodes, including the antinodes that appear on every antenna:

##....#....#
.#.#....0...
..#.#0....#.
..##...0....
....0....#..
.#...#A....#
...#..#.....
#....#.#....
..#.....A...
....#....A..
.#........#.
...#......##

Calculate the impact of the signal using this updated model. How many unique locations within the bounds of the map contain an antinode?
*/

d8p2 :: proc(inputPath: string) -> (nodeCount: i64 = 0) {
    state: Day8ParserState
    defer {
        for line in state.lines {
            delete(line)
        }
        delete(state.lines)
    }
    parseFileToFunction(inputPath, d8LineParser, &state)

    maxX := len(state.lines[0])
    maxY := len(state.lines)
    
    antinodes: [dynamic][2]int
    defer delete(antinodes)

    for char: u8 = '0'; char <= 'z'; char += 1 {
        locations: [dynamic][2]int
        defer delete(locations)

        for x := 0; x < maxX; x += 1 {
            for y := 0; y < maxY; y += 1 {
                if state.lines[y][x] == char {
                    append(&locations, ([2]int)({x, y}))
                }
            }
        }

        locationsLength := i64(len(locations))
        if locationsLength > 1 {
            for location in locations {
                contains := false
                for node in antinodes {
                    if node == location {
                        contains = true
                        break
                    }
                }
                if !contains {
                    append(&antinodes, location)
                    nodeCount += 1
                }
            }
        }
        for i: i64 = 0; i < locationsLength - 1; i += 1 {
            for j := i + 1; j < locationsLength; j += 1 {
                relativePosition := locations[i] - locations[j]
                for k := 0; true; k += 1 {
                    pos1 := locations[i] + (k * relativePosition)
                    pos2 := locations[j] - (k * relativePosition)
                    
                    contains1 := false
                    contains2 := false
                    for node in antinodes {
                        if node == pos1 {
                            contains1 = true
                        }
                        else if node == pos2 {
                            contains2 = true
                        }
                    }

                    if !contains1 && pos1.x >= 0 && pos1.x < maxX && pos1.y >= 0 && pos1.y < maxY {
                        append(&antinodes, pos1)
                        nodeCount += 1
                    }
                    if !contains2 && pos2.x >= 0 && pos2.x < maxX && pos2.y >= 0 && pos2.y < maxY {
                        append(&antinodes, pos2)
                        nodeCount += 1
                    }

                    if (pos1.x < 0 || pos1.x >= maxX || pos1.y < 0 || pos1.y >= maxY) \
                    && (pos2.x < 0 || pos2.x >= maxX || pos2.y < 0 || pos2.y >= maxY) {
                        break
                    }
                }
            }
        }
    }    

    return
}

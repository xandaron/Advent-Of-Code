package AdventOfCode

import "core:fmt"
import "core:os"
import "core:bufio"
import "core:strings"
import "core:slice"
import "core:mem"

main :: proc() {
    when ODIN_DEBUG {
		tracker: mem.Tracking_Allocator
		mem.tracking_allocator_init(&tracker, context.allocator)
		context.allocator = mem.tracking_allocator(&tracker)

		defer {
			if len(tracker.allocation_map) > 0 {
				fmt.printfln("=== %v allocations not freed: ===", len(tracker.allocation_map))
				for _, entry in tracker.allocation_map {
					fmt.printfln("- %v bytes @ %v", entry.size, entry.location)
				}
			}
			if len(tracker.bad_free_array) > 0 {
				fmt.printfln("=== %v incorrect frees: ===", len(tracker.bad_free_array))
				for entry in tracker.bad_free_array {
					fmt.printfln("- %p @ %v", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&tracker)
		}
	}

    // fmt.println(d1p1("./Day1-Input.txt"))
    // fmt.println(d1p2("./Day1-Input.txt"))
    // fmt.println(d2p1("./Day2-Input.txt"))
    // fmt.println(d2p2("./Day2-Input.txt"))
    // fmt.println(d3p1("./Day3-Input.txt"))
    // fmt.println(d3p2("./Day3-Input.txt"))
    // fmt.println(d4p1("./Day4-Input.txt"))
    // fmt.println(d4p2("./Day4-Input.txt"))
    // fmt.println(d5p1("./Day5-Input.txt"))
    fmt.println(d5p2("./Day5-Test.txt"))
    fmt.println(d5p2("./Day5-Input.txt"))
    // fmt.println(d6p1("./Day6-Input.txt"))
    // fmt.println(d6p2("./Day6-Input.txt"))
    // fmt.println(d7p1("./Day7-Input.txt"))
    // fmt.println(d7p2("./Day7-Test.txt"))
    // fmt.println(d7p2("./Day7-Input.txt")) // Takes a few minutes
}

stringToInt :: proc(s: string) -> (number: i64 = 0) {
    for i := 0; i < len(s); i += 1 {
        number *= 10
        number += i64(s[i] - '0')
    }
    return
}

lineParseFunction :: proc(string, rawptr)

parseFileToFunction :: proc(filepath: string, function: lineParseFunction, output: rawptr) {
    file, err := os.open(filepath)
    defer os.close(file)
    if err != nil {
        fmt.eprintln("Failed to open file:", err)
        return
    }

    reader: bufio.Reader
    bufio.reader_init(&reader, os.stream_from_handle(file))
    defer bufio.reader_destroy(&reader)

    for {
        line, err := bufio.reader_read_string(&reader, '\n')
        if err != nil && err != .EOF {
           fmt.eprintln("Error reading line", err)
           return
        }

		line = strings.trim(line, "\r\n")
        defer delete(line)
        function(line, output)

        if err == .EOF {
            break
        }
    }
}
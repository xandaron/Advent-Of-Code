package AdventOfCode

import "core:fmt"
import "core:os"
import "core:bufio"
import "core:strings"
import "core:slice"

main :: proc() {
    fmt.println(d1p1("./Day1-Input.txt"))
    fmt.println(d1p2("./Day1-Input.txt"))
    fmt.println(d2p1("./Day2-Input.txt"))
    fmt.println(d2p2("./Day2-Input.txt"))
}

stringToInt :: proc(s: string) -> (number: i64 = 0) {
    exponent: i64 = 1
    for i := len(s) - 1; i >= 0; i -= 1 {
        number += i64(s[i] - '0') * exponent
        exponent *= 10
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
    for {
        line, err := bufio.reader_read_string(&reader, '\n')
        if err != nil && err != .EOF {
           fmt.eprintln("Error reading line", err)
           return
        }
        defer delete(line)

		line = strings.trim(line, "\r\n")
        function(line, output)

        if err == .EOF {
            break
        }
    }
    return
}
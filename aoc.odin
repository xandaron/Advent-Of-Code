package AdventOfCode

import "core:fmt"

main :: proc() {
    // fmt.println(d1p1("./Day1-Input.txt"))
    // fmt.println(d1p2("./Day1-Input.txt"))
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
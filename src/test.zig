const std = @import("std");
const String = @import("root.zig").String;
const print = @import("std").debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

test "string init" {
    const new_str = String.init(allocator);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), ""));
}

test "string from" {
    const test_str = "test";

    const new_str = String.from(allocator, test_str);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), test_str));
}

test "string put" {
    const test_str = "test";

    var new_str = String.init(allocator);
    new_str.put(test_str);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), test_str));
}

test "string push char" {
    const test_char = "t";

    var new_str = String.from(allocator, "tes");

    new_str.push(test_char);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), "test"));
}

test "string push word" {
    const test_char = "world";

    var new_str = String.from(allocator, "hello ");

    new_str.push(test_char);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), "hello world"));
}

test "string clear" {
    var new_str = String.from(allocator, "test");

    new_str.clear();

    try std.testing.expect(new_str.items.len == 0);
}

// test "string pop count" {
//     var new_str = String.from(allocator, "test string");

//     const popped = new_str.pop_count(6, allocator);

//     try std.testing.expect(std.mem.eql(u8, popped.get(), "string"));
// }

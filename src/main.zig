const std = @import("std");
const String = @import("root.zig").String;

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();
}

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

test "string init" {
    const new_str = try String.init(allocator);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), ""));
}

test "string from" {
    const test_str = "test";

    const new_str = try String.from(allocator, test_str);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), test_str));
}

test "string put" {
    const test_str = "test";

    var new_str = try String.init(allocator);
    new_str.put(test_str);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), test_str));
}

test "string push" {
    const test_char = "t";

    var new_str = try String.from(allocator, "tes");

    new_str.push(test_char);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), "test"));
}

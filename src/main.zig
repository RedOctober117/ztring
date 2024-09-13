const std = @import("std");
const String = @import("root.zig").String;

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    // var string = try allocator.alloc(u8, 10);
    // errdefer allocator.free(string);

    // const str = "hello ";

    // @memcpy(string[0..str.len], str);

    // const append_str = "world";

    // if (str.len + append_str.len > string.len) {
    //     _ = allocator.resize(string[0..string.len], str.len + append_str.len + 1);
    // }

    // @memcpy(string[str.len .. str.len + append_str.len], append_str);

    // std.debug.print("{s}\n", .{string});
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

test "string push char" {
    const test_char = "t";

    var new_str = try String.from(allocator, "tes");

    new_str.push(test_char);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), "test"));
}

test "string push word" {
    const test_char = "world";

    var new_str = try String.from(allocator, "hello ");

    new_str.push(test_char);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), "hello world"));
}

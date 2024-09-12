const std = @import("std");
// const String = @import("root.zig").String;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var string = try allocator.alloc(u8, 10);
    errdefer allocator.free(string);

    // @memcpy(string[0..], 0);

    const str = "test";

    @memcpy(string[0..str.len], str);

    std.debug.print("{s}\n", .{string});

    // const test_string = String.from(allocator, "test");
    // std.debug.print("{}\n}", .{test_string.get()});
    // _ = String.from("test");
}

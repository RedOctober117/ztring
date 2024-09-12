const std = @import("std");
const String = @import("root.zig").String;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var string = try allocator.alloc(u8, 10);
    errdefer allocator.free(string);

    const str = "test";

    @memcpy(string[0..str.len], str);

    std.debug.print("{s}\n", .{string});

    const new_string = String.init(allocator);
    defer new_string.deinit();

    std.debug.print("Empty string: {s}\n", .{new_string.get()});

    new_string.put("test");

    std.debug.print("Full string: {s}\n", .{new_string.get()});
}

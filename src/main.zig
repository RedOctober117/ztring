const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var string = try allocator.alloc(u8, 10);
    errdefer allocator.free(string);

    const str = "test";

    @memcpy(string[0..str.len], str);

    std.debug.print("{s}\n", .{string});
}

const std = @import("std");
const String = @import("root.zig").String;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
}

test "string init" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const new_str = try String.init(allocator);

    try std.testing.expect(std.mem.eql(u8, new_str.get(), ""));
}

const std = @import("std");
const Allocator = std.mem.Allocator;
// const FixedBufferAllocator = std.heap.FixedBufferAllocator;

const buffer_size = 10;

pub const String = struct {
    allocator: Allocator,
    string_ptr: []u8,

    fn init(allocator: Allocator) !String {
        return .{
            .allocator = allocator,
            .string_ptr = allocator.alloc(u8, buffer_size) catch unreachable,
        };
    }

    fn deinit(self: *String) void {
        self.allocator.free(self.string_ptr);
    }

    fn from(allocator: Allocator, string: []const u8) String {}
    fn get() []u8 {}
    fn put(self: *String) void {}

    fn resize(self: *String) void {}
};

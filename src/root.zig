const std = @import("std");
const Allocator = std.mem.Allocator;
// const FixedBufferAllocator = std.heap.FixedBufferAllocator;

const buffer_size = 10;

pub const String = struct {
    allocator: Allocator,
    string_ptr: []u8,
    length: usize,

    fn capacity(self: String) usize {
        return self.string_ptr.len;
    }

    pub fn init(allocator: Allocator) String {
        return String{
            .allocator = allocator,
            .string_ptr = allocator.alloc(u8, buffer_size) catch unreachable,
            .length = 0,
        };

        // var i = undefined;

        // for (0..new_str.string_ptr.len) |i| {
        //     new_str.string_ptr[i] = 0;
        // }

        // return new_str;
    }

    pub fn deinit(self: String) void {
        self.allocator.free(self.string_ptr);
    }

    pub fn from(allocator: Allocator, string: []const u8) String {
        var new_string = String.init(allocator);
        if (new_string.capacity() < string.len) {
            new_string.resize_with_len(string.len);
        }
        new_string.put(string);

        return string;
        // @memcpy(new_string.string_ptr.*, string);
    }

    pub fn get(self: String) []u8 {
        return self.string_ptr[0..self.length];
    }

    pub fn put(self: String, string: []const u8) void {
        if (string.len > self.capacity()) {
            self.resize_with_len(string.len);
        }

        @memcpy(self.string_ptr[0..string.len], string);
    }

    fn resize(self: String) !void {
        _ = self.allocator.resize(self.string_ptr, self.length + buffer_size);
    }

    fn resize_with_len(self: String, length: usize) void {
        _ = self.allocator.resize(self.string_ptr, length);
    }
};

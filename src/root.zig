const std = @import("std");
const Allocator = std.mem.Allocator;
// const FixedBufferAllocator = std.heap.FixedBufferAllocator;

// fn name(self: Self) returns a copy of the value. if the value contains a
// pointer in a field, a copy of that pointer is made and can still be
// dereferenced. non-pointer values are not mutable unless the parameter is
// (self: *Self).

const buffer_size = 10;

pub const String = struct {
    //ptr, ptr, value
    allocator: Allocator,
    string_ptr: []u8,
    length: usize,

    pub fn init(allocator: Allocator) !String {
        return String{
            .allocator = allocator,
            .string_ptr = try allocator.alloc(u8, buffer_size),
            .length = 0,
        };
    }

    pub fn deinit(self: String) void {
        self.allocator.free(self.string_ptr);
    }

    pub fn from(allocator: Allocator, string: []const u8) !String {
        var new_string = try String.init(allocator);
        if (new_string.capacity() < string.len) {
            new_string.resize_with_len(string.len);
        }
        new_string.put(string);

        return new_string;
    }

    pub fn get(self: String) []u8 {
        return self.string_ptr[0..self.length];
    }

    pub fn put(self: *String, string: []const u8) void {
        if (string.len > self.capacity()) {
            _ = &self.resize_with_len(string.len);
        }

        self.put_at(string, 0, string.len);
        self.length = string.len;
    }

    fn put_at(self: String, string: []const u8, start_index: usize, end_index: usize) void {
        @memcpy(self.string_ptr[start_index..end_index], string);
    }

    pub fn push(self: *String, char: []const u8) void {
        const new_len = self.length + 1;
        if (new_len > self.capacity() and char.len > buffer_size) {
            _ = &self.resize_with_len(new_len + buffer_size);
        }

        self.put_at(char, self.length, new_len);
        self.length = new_len;
    }

    pub fn capacity(self: String) usize {
        return self.string_ptr.len;
    }

    fn resize(self: *String) void {
        const new_len = self.length + buffer_size;
        _ = self.allocator.resize(self.string_ptr, new_len);
    }

    fn resize_with_len(self: *String, length: usize) void {
        std.debug.print("inc len {d}", .{length});
        _ = self.allocator.resize(self.string_ptr, length);
    }
};

pub const StringError = error{
    IndexOutOfBound,
};

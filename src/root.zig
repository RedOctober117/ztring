const std = @import("std");
const Allocator = std.mem.Allocator;
// const FixedBufferAllocator = std.heap.FixedBufferAllocator;

// fn name(self: Self) returns a copy of the value. if the value contains a
// pointer in a field, a copy of that pointer is made and can still be
// dereferenced. non-pointer values are not mutable unless the parameter is
// (self: *Self).

const BUFFER_SIZE = 10;

/// A structure to handle strings in a more robust way.
pub const String = struct {
    //ptr, ptr, value
    /// The allocator pointer, received from the implementing program.
    allocator: Allocator,

    /// The pointer to the mem location of the string. All operations are
    /// guaranteed to not change the pointer address.
    string_ptr: []u8,

    /// The length of the text stored. This is different from the capacity of the array itself.
    length: usize,

    fn put_at(self: String, string: []const u8, start_index: usize, end_index: usize) void {
        @memcpy(self.string_ptr[start_index..end_index], string);
    }

    pub fn init(allocator: Allocator) !String {
        return String{
            .allocator = allocator,
            .string_ptr = try allocator.alloc(u8, BUFFER_SIZE),
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

    pub fn push(self: *String, string: []const u8) void {
        const new_len = self.length + string.len;
        if (new_len >= self.capacity()) {
            _ = self.allocator.resize(self.string_ptr, new_len);
            // self.resize_with_len(new_len + BUFFER_SIZE);
        }

        self.put_at(string, self.length, new_len);
        self.length = new_len;
    }

    pub fn capacity(self: String) usize {
        return self.string_ptr.len;
    }

    fn resize(self: *String) void {
        const new_len = self.length + BUFFER_SIZE;
        _ = self.allocator.resize(self.string_ptr, new_len);
    }

    fn resize_with_len(self: *String, length: usize) void {
        std.debug.print("inc len {d}", .{length});
        _ = self.allocator.resize(self.string_ptr.ptr, length);
    }
};

pub const StringError = error{
    IndexOutOfBound,
};

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
    const Self = @This();

    //ptr, ptr, value
    /// The allocator pointer, received from the implementing program.
    allocator: Allocator,

    /// The pointer to the mem location of the string. All operations are
    /// guaranteed to not change the pointer address.
    items: []u8,

    /// The length of the text stored. This is different from the capacity of the array itself.
    items_count: usize,

    total_capacity: usize,

    fn put_at(self: String, string: []const u8, start_index: usize, end_index: usize) void {
        @memcpy(self.items[start_index..end_index], string);
    }

    pub fn init(allocator: Allocator) !String {
        return String{
            .allocator = allocator,
            .items = try allocator.alloc(u8, BUFFER_SIZE),
            .items_count = 0,
            .total_capacity = BUFFER_SIZE,
        };
    }

    pub fn deinit(self: String) void {
        self.allocator.free(self.items);
    }

    pub fn from(allocator: Allocator, string: []const u8) !String {
        var new_string = try String.init(allocator);
        if (new_string.total_capacity < string.len) {
            _ = &new_string.grow();
        }
        new_string.put(string);

        return new_string;
    }

    pub fn get(self: String) []u8 {
        return self.items[0..self.items_count];
    }

    fn allocatedItems(self: String) []u8 {
        return self.items.ptr[0..self.total_capacity];
    }

    pub fn put(self: *String, string: []const u8) void {
        if (string.len > self.total_capacity) {
            _ = &self.grow();
        }

        self.put_at(string, 0, string.len);
        self.items_count = string.len;
    }

    pub fn push(self: *String, string: []const u8) void {
        const new_len = self.items_count + string.len;
        _ = &self.grow();

        self.put_at(string, self.items_count, new_len);
        self.items_count = new_len;
    }

    pub fn capacity(self: String) usize {
        return self.items.len;
    }

    fn grow(self: *Self) void {
        const new_mem = self.allocator.alloc(u8, self.total_capacity * 2) catch unreachable;

        @memcpy(new_mem[0..self.items_count], self.items[0..self.items_count]);

        self.items = new_mem;
    }
};

pub const StringError = error{
    IndexOutOfBound,
};

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
    item_length: usize,

    /// Total cappacity of the allocation.
    alloc_capacity: usize,

    fn insert_at(self: Self, string: []const u8, start_index: usize, end_index: usize) void {
        @memcpy(self.items[start_index..end_index], string);
    }

    pub fn init(allocator: Allocator) Self {
        return Self{
            .allocator = allocator,
            .items = undefined,
            .item_length = 0,
            .alloc_capacity = 0,
        };
    }

    pub fn from(allocator: Allocator, string: []const u8) Self {
        var new_string = Self.init(allocator);
        _ = &new_string.put(string);

        return new_string;
    }

    /// Can panic on mem allocation failure
    fn guarantee_size(self: *Self, incoming_string_len: usize) void {
        const required_size = calc_space_to_alloc(self.item_length + incoming_string_len);
        self.resize(required_size);
    }

    fn resize(self: *Self, required_length: usize) void {
        if (required_length > self.alloc_capacity) {
            const new_mem = self.allocator.alloc(u8, required_length) catch std.debug.panic("STRING::GUARANTEE_SIZE::MEMORY ALLOCATION FAIL.", .{});

            @memcpy(new_mem[0..self.item_length], self.items[0..self.item_length]);

            self.items = new_mem;
            self.alloc_capacity = required_length;
        }
    }

    pub fn deinit(self: Self) void {
        self.allocator.free(self.items);
    }

    pub fn get(self: Self) []u8 {
        return self.items[0..self.item_length];
    }

    pub fn put(self: *Self, string: []const u8) void {
        self.guarantee_size(string.len);

        self.insert_at(string, 0, string.len);
        self.item_length = string.len;
    }

    pub fn push(self: *Self, string: []const u8) void {
        const new_str_len = self.item_length + string.len;
        const required_size = calc_space_to_alloc(new_str_len);
        self.guarantee_size(required_size);

        self.insert_at(string, self.item_length, new_str_len);
        self.item_length = new_str_len;
    }

    pub fn capacity(self: Self) usize {
        return self.items.len;
    }

    fn calc_space_to_alloc(size: usize) usize {
        return size + BUFFER_SIZE;
    }
};

pub const StringError = error{
    MemoryAllocationError,
    IndexOutOfBound,
};

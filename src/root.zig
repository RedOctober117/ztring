//! This module provides an encapsulated and succinct manner of creating,
//! modifying, and destroying variable lenght strings.

const std = @import("std");
const Allocator = std.mem.Allocator;

/// Arbitrary buffersize to append to newly allocated strings when the string
/// exceeds the current `alloc_capacity`. The length of the string (not the
/// capacity) is encoded into the `items` pointer field.
const BUFFER_SIZE = 10;

/// A structure to handle strings in a more robust way.
pub const String = struct {
    const Self = @This();

    /// A named constant to make managing []u8s a little less insanity
    /// inducing.
    pub const Slice = []u8;

    /// The allocator struct, received from the implementing program.
    allocator: Allocator,

    /// The pointer to the mem location of the string. All operations are
    /// guaranteed to not change the pointer address.
    items: []u8,

    /// Total capacity of the allocation.
    alloc_capacity: usize,

    /// Interal wrapper function to insert an arbitrary sized string into a
    /// specified index range. This fn is allowed to overwrite existing memory.
    fn insert_at(self: Self, string: []const u8, start_index: usize, end_index: usize) void {
        @memcpy(self.items[start_index..end_index], string);
    }

    /// Initialize an empty string with unallocated memory. This is guaranteed
    /// to work.
    pub fn init(allocator: Allocator) Self {
        return Self{
            .allocator = allocator,
            .items = &[_]u8{},
            .alloc_capacity = 0,
        };
    }

    /// Initialize a String from a string. It is possible for this to fail if
    /// the allocator fails.
    pub fn from(allocator: Allocator, string: []const u8) Self {
        var new_string = Self.init(allocator);
        errdefer new_string.deinit();

        _ = &new_string.put(string);

        return new_string;
    }

    /// Can panic on mem allocation failure
    fn guarantee_size(self: *Self, incoming_string_len: usize) void {
        const required_size = calc_space_to_alloc(self.items.len + incoming_string_len);
        self.resize(required_size);
    }

    /// CAN PANIC!! Attempts to resize the memory allocation to the size
    /// dictated by `calc_space_to_alloc()`, and reassign the internal
    /// pointer.
    fn resize(self: *Self, required_length: usize) void {
        if (required_length > self.alloc_capacity) {
            const new_mem = self.allocator.alloc(u8, required_length) catch std.debug.panic("STRING::RESIZE::MEMORY ALLOCATION FAIL.", .{});

            @memcpy(new_mem[0..self.items.len], self.items[0..self.items.len]);

            self.items = new_mem;
            self.alloc_capacity = required_length;
        }
    }

    /// Clean up memory allocated by this struct.
    pub fn deinit(self: Self) void {
        self.allocator.free(self.items);
    }

    /// Return only the items stored, not the whole allocation.
    pub fn get(self: Self) []u8 {
        return self.items[0..self.items.len];
    }

    /// Replace the current string. Does not guarantee an empty memory
    /// location, but will change the `item_length` accordingly.
    pub fn put(self: *Self, string: []const u8) void {
        self.guarantee_size(string.len);

        self.insert_at(string, 0, string.len);
        self.items.len = string.len;
    }

    /// Append an n-length string to the current string.
    pub fn push(self: *Self, string: []const u8) void {
        const new_str_len = self.items.len + string.len;
        const required_size = calc_space_to_alloc(new_str_len);
        self.guarantee_size(required_size);

        self.insert_at(string, self.items.len, new_str_len);
        self.items.len = new_str_len;
    }

    pub fn pop_count(self: *Self, count: u32, allocator: Allocator) String {
        var return_string: []u8 = undefined;

        if (count < self.items.len) {
            return_string = self.get()[self.items.len - count .. self.items.len];
            self.items.len = self.items.len - count;
            return String.from(allocator, return_string);
        } else {
            return_string = self.get();
            self.clear();
            return String.from(allocator, return_string);
        }
    }

    pub fn clear(self: *Self) void {
        self.put("");
    }

    pub fn to_owned_slice(self: *Self) []u8 {
        const allocator = self.allocator;

        const old_mem = self.get();

        if (allocator.resize(old_mem, self.items.len)) {
            const result = self.items;
            self.* = self.init(allocator);
            return result;
        }

        const new_mem = allocator.alloc(u8, self.items.len);
        @memcpy(new_mem, self.items);
        @memset(self.items, undefined);
        self.deinit();
        return new_mem;
    }

    /// Return the total capacity of the allocation.
    pub fn capacity(self: Self) usize {
        return self.alloc_capacity;
    }

    /// Calculate the required size of a new allocation.
    fn calc_space_to_alloc(size: usize) usize {
        return size + BUFFER_SIZE;
    }
};

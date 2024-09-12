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

    pub fn capacity(self: String) usize {
        return self.string_ptr.len;
    }

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

        @memcpy(self.string_ptr[0..string.len], string);
        self.length = string.len;
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

// const print = @import("std").debug.print;

// const Duck = struct { Hp: i8, const Self = @This(); fn sleep(self: *Self) void { self.Hp += 1; } };

// const RubberDuck = struct { Hp: i8, const Self = @This(); fn sleep(self: *Self) void { self.Hp -= 1; } };

// fn Rest(t: anytype) void { t.sleep(); }

// pub fn main() void { var d = Duck{ .Hp = 0, };

// var rd = RubberDuck{
//     .Hp = 0,
// };

// Rest(&d);
// Rest(&rd);
// print("{d},{d}\n", .{ d.Hp, rd.Hp });

// }

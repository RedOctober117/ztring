to build: `zig build`
to test: `zig build test`

# Problem Analysis

## Goal 
Create a structured and deterministic way to handle dynamically sized strings in zig.

## Analysis
The `String` struct will live in whichever part of memory the passed allocator determines. `Strings` are represented as `[]u8`.

Operations on the allocated memory:
 - grow allocation
 - shrink allocation
   - shrink to exact size

Operations on the string:
 - add range
   - grow if needed
   - copy new range into allocation
 - remove range
   - shrink if capacity is 2x item count

## Fields
 - allocator: Allocator
 - item_length: usize
 - alloc_capacity: usize
 - items: []u8

## Required Fns
 - \+ init(allocator: Allocator) Self
 - \+ from(allocator: Allocator, from: []const u8) Self
 - \+ get(self) []u8
 - \+ set(self, from: []const u8) void
 - \- put(*self, from: []const u8) void
 - \+ push(*self, from: []const u8) void
 - \- grow(*self) void
 - \- shrink(*self) void
 - \- guarantee_size(*self, new_length: usize) void
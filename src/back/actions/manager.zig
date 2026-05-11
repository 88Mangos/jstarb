const std = @import("std");
const d = @import("../data.zig");

pub const Manager = struct {
    arena: std.heap.ArenaAllocator,
    entries: std.MultiArrayList(d.Entry),

    // creating fresh Entry/Event ids
    n_entries: u64,
    n_events: u64,

    pub fn init() Manager {}
    pub fn deinit() !void {}

    pub fn freshEntryId() u64 {}
    pub fn freshEventId() u64 {}
};

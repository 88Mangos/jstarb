const std = @import("std");
const d = @import("../data.zig");

pub const Manager = struct {
    arena: std.heap.ArenaAllocator,
    entries: std.MultiArrayList(d.Entry),

    // for creating fresh Entry/Update ids
    n_entries: u64,
    n_events: u64,

    pub fn init(child_allocator: std.mem.Allocator) Manager {
        return .{
            .arena = std.heap.ArenaAllocator.init(child_allocator),
            .entries = std.MultiArrayList(d.Entry).init(child_allocator),
            .n_entries = 0,
            .n_events = 0,
        };
    }
    pub fn deinit(self: *Manager) void {
        for (self.entries.items) |*entry| {
            entry.deinit(self.allocator); // Free strings and ledger
        }
        self.entries.deinit();
        self.arena.deinit();
    }

    fn freshEntryId(self: *Manager) u64 {
        self.n_entries += 1;
        return self.n_entries;
    }

    fn freshUpdateId(self: *Manager) u64 {
        self.n_events += 1;
        return self.n_events;
    }

    pub fn newEntry(self: *Manager) d.Entry {
        return d.Entry{
            .id = self.freshEntryId(),
            .created_at = std.time.timestamp(),
            .status = .Pending,
            // everything else initialized to defaults
        };
    }
    pub fn newUpdate(self: *Manager) d.Update {
        return d.Update{
            .id = self.freshUpdateId(),
            .created_at = std.time.timestamp(),
            // everything else initialized to defaults
        };
    }
};

const std = @import("std");
const d = @import("../data.zig");

pub const Manager = struct {
    arena: std.heap.ArenaAllocator,
    entries: std.ArrayList(d.Entry),

    // for creating fresh Entry/Update ids
    n_entries: u64,
    n_updates: u64,

    pub fn init(arena: std.heap.ArenaAllocator, db: std.ArrayList(d.Entry)) Manager {
        return .{
            .arena = arena,
            .entries = db,
            .n_entries = 0,
            .n_updates = 0,
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
        self.n_updates += 1;
        return self.n_updates;
    }

    // updates manager entry list and entry id counter
    pub fn newEntry(self: *Manager) !*d.Entry {
        const entry = d.Entry{
            .id = self.freshEntryId(),
            .created_at = std.time.timestamp(),
            .status = .Pending,
            .ledger = std.ArrayList(d.Entry).init(self.arena.allocator()),
            // everything else initialized to defaults
        };
        try self.entries.append(entry);

        return &(self.entries[self.n_entries - 1]);
    }

    // updates manager update id counter
    pub fn newUpdate(self: *Manager) d.Update {
        return d.Update{
            .id = self.freshUpdateId(),
            .created_at = std.time.timestamp(),
            .action = .Ignore,
            .item = null,
            // everything else initialized to defaults
        };
    }

    // manual user updates
    // TODO: write this last, once the Entry struct has been finalized.
    pub fn updateManually(
        self: *Manager,
        entry: *d.Entry,
        // plus parameters necessary as optionals
        // to modify all fields in struct Entry
    ) !void {
        var u = self.newUpdate();
        u.action = .UpdateEntry;
        u.item = null;

        try entry.ledger.append(u);
        return;
    }
};

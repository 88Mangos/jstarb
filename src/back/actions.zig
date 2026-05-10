//
// Implementing Workflow Logic
//
const std = @import("std");
const data = @import("data.zig");

pub const EntryUpdateError = error{InvalidUpdate};

//
// MARK: Manager
// NOTE: This is probably not great for concurrency,
//  since we'd have to lock the entries and events lists
//  but I guess we can make this concurrent in the future.
//
pub const Manager = struct {
    arena: std.heap.ArenaAllocator,
    entries: std.ArrayList(data.Entry),
    n_entries: u64,
    n_events: u64,

    pub fn init(child_allocator: std.mem.Allocator) Manager {
        return .{
            .arena = std.heap.ArenaAllocator.init(child_allocator),
            .entries = std.ArrayList(data.Entry).init(child_allocator),
            .n_entries = 0,
            .n_events = 0,
        };
    }

    pub fn deinit(self: *Manager) void {
        for (self.entries.items) |*entry| {
            entry.deinit(self.allocator); // Free strings and ledger
        }
        self.entries.deinit();
    }

    pub fn fresh_entry_id(self: *Manager) u64 {
        std.debug.assert(self.initialized);
        // NOTE: if we do concurrency in the future, this must be lock protected
        const highest = self.n_entries;
        self.n_entries += 1;
        return highest + 1;
    }

    pub fn fresh_event_id(self: *Manager) u64 {
        // NOTE: if we do concurrency in the future, this must be lock protected
        std.debug.assert(self.initialized);
        const highest = self.n_events;
        self.n_events += 1;
        return highest + 1;
    }
};

//
// MARK: Job Opening Namespace
//
pub const job_openings = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: [][]const u8,
        link: []const u8,
        user_notes: ?[]const u8,
        // job opening specific
        job_title: []const u8,
    ) !*data.Entry {
        const currtime = std.time.timestamp();
        const entryId = mgr.fresh_entry_id();

        const notes = try std.fmt.allocPrint(
            mgr.arena.allocator(),
            "Created at {d}: {s}",
            .{ currtime, user_notes orelse "" },
        );

        var entry = data.Entry{
            .id = entryId,
            .created_at = currtime,
            .tags = tags,
            .type = data.JobOpening,
            .company = company,
            .link = link,
            .notes = notes,
            .ledger = std.ArrayList(data.Event),
            .view = data.job_opening{
                .due = null,
                .applied_at = null,
                .job_title = job_title,
                .state = data.pending.LookingAt,
            },
        };

        try entry.ledger.append(data.Event{
            .id = mgr.fresh_event_id(),
            .created_at = currtime,
            .entryId = entryId,
            .type = data.job_opening.BeginTracking,
        });

        try mgr.entries.append(entry);
        return &mgr.entries.items[mgr.entries.items.len - 1];
    }

    pub fn apply(
        mgr: *Manager,
        entryId: u64,
        new_notes: ?[]const u8,
    ) !*data.Entry {
        var entry = mgr.entries[entryId];
        entry.type = data.job_opening.Applied;
        if (new_notes) |new_notes_str| {
            entry.notes = entry.notes ++ "\n" ++ new_notes_str;
        }

        return &mgr.entries.items[entryId];
    }
    pub fn receive_oa(mgr: *Manager) !*data.Entry {}
    pub fn complete_oa(mgr: *Manager) !*data.Entry {}
    pub fn receive_interview(mgr: *Manager) !*data.Entry {}
    pub fn schedule_interview(mgr: *Manager) !*data.Entry {}
    pub fn reschedule_interview(mgr: *Manager) !*data.Entry {}
    pub fn complete_interview(mgr: *Manager) !*data.Entry {}
    pub fn receive_offer(mgr: *Manager) !*data.Entry {}
    pub fn accept_offer(mgr: *Manager) !*data.Entry {}
    pub fn reject_offer(mgr: *Manager) !*data.Entry {}
    pub fn receive_rejection(mgr: *Manager) !*data.Entry {}
    pub fn withdraw_application(mgr: *Manager) !*data.Entry {}

    //
    // Functions that run automatically
    // if it's been too long since last new new ledger entry...
    //
    // and we haven't submitted an application to the job_opening,
    //  if there's a due date and it's passed,
    //    Entry.job_opening.state.pending = DeadlinePassed
    //  else,
    //    Entry.job_opening.state.pending = Ignored
    // and we haven't heard back after submitting (including if we've interviewed)
    //  Entry.job_opening.state.noOffer = Ghosted
};

//
// MARK: Outreach Event Namespace
//
pub const outreach_event = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: [][]const u8,
        link: []const u8,
        user_notes: ?[]const u8,
        // outreach event specific
        people: ?std.ArrayList(data.Person),
        location: ?data.location,
        scheduled: ?data.time,
    ) !*data.Entry {
        const currtime = std.time.timestamp();
        const entryId = mgr.fresh_entry_id();

        const notes = try std.fmt.allocPrint(
            mgr.arena.allocator(),
            "Created at {d}: {s}",
            .{ currtime, user_notes orelse "" },
        );

        const entry = data.Entry{
            .id = entryId,
            .created_at = currtime,
            .tags = tags,
            .type = data.OutreachEvent,
            .company = company,
            .link = link,
            .notes = notes,
            .ledger = std.ArrayList(data.Event),
            .view = data.outreach_event{
                .people = people orelse std.ArrayList(data.Person),
                .location = location,
                .scheduled = scheduled,
                .complete = false,
                .state = data.pending.LookingAt,
            },
        };

        try mgr.entries.append(entry);
        return &mgr.entries.items[mgr.entries.items.len - 1];
    }

    pub fn apply(mgr: *Manager) !*data.Entry {}
    pub fn receive_oa(mgr: *Manager) !*data.Entry {}
    pub fn complete_oa(mgr: *Manager) !*data.Entry {}
    pub fn attend_event(mgr: *Manager) !*data.Entry {}
    pub fn receive_rejection(mgr: *Manager) !*data.Entry {}
};

//
// MARK: Coffee Chat Namespace
//
pub const coffee_chats = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: [][]const u8,
        link: []const u8,
        user_notes: ?[]const u8,
        // coffee chat specific
        people: ?std.ArrayList(data.Person),
        location: ?data.location,
        scheduled: ?data.time,
    ) !*data.Entry {
        const currtime = std.time.timestamp();
        const entryId = mgr.fresh_entry_id();

        const notes = try std.fmt.allocPrint(
            mgr.arena.allocator(),
            "Created at {d}: {s}",
            .{ currtime, user_notes orelse "" },
        );

        const entry = data.Entry{
            .id = entryId,
            .created_at = currtime,
            .tags = tags,
            .type = data.OutreachEvent,
            .company = company,
            .link = link,
            .notes = notes,
            .ledger = null,
            .view = data.outreach_event{
                .people = people orelse std.ArrayList(data.Person),
                .location = location,
                .scheduled = scheduled,
                .complete = false,
            },
        };

        try mgr.entries.append(entry);
        return &mgr.entries.items[mgr.entries.items.len - 1];
    }
    pub fn schedule(
        mgr: *Manager,
        entryId: u64,
        loc: data.location,
        time: data.time,
        notes: ?[]const u8,
    ) !*data.Entry {
        var cc_entry = mgr.entries[entryId];
        std.debug.assert(cc_entry.type == data.coffee_chat);

        const currtime = std.time.timestamp();

        if (cc_entry.complete) {
            std.debug.print("Cannot schedule a coffee chat that has already completed ", .{});
            return EntryUpdateError.InvalidUpdate;
        }

        cc_entry.location = loc;
        cc_entry.scheduled = time;
        try cc_entry.ledger.append(data.Event{
            .id = mgr.fresh_event_id(),
            .created_at = currtime,
            .entryId = entryId,
            .notes = notes,
            .type = .coffee_chat.Scheduled,
        });
    }
    pub fn complete(
        mgr: *Manager,
        entryId: u64,
        notes: ?[]const u8,
    ) !*data.Entry {
        var cc_entry = mgr.entries[entryId];
        std.debug.assert(cc_entry.type == data.coffee_chat);

        const currtime = std.time.timestamp();

        if (cc_entry.complete) {
            std.debug.print("Cannot complete a coffee chat that has already completed ", .{});
            return EntryUpdateError.InvalidUpdate;
        }

        cc_entry.complete = true;
        try cc_entry.ledger.append(data.Event{
            .id = mgr.fresh_event_id(),
            .created_at = currtime,
            .entryId = entryId,
            .notes = notes,
            .type = .coffee_chat.Scheduled,
        });
    }
};

//
// MARK: Resume Bucket logic
//
pub const resume_bucket = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: [][]const u8,
        link: []const u8,
        user_notes: ?[]const u8,
    ) !*data.Entry {
        const currtime = std.time.timestamp();
        const entryId = mgr.fresh_entry_id();

        const notes = try std.fmt.allocPrint(
            mgr.arena.allocator(),
            "Created at {d}: {s}",
            .{ currtime, user_notes orelse "" },
        );
        const entry = data.Entry{
            .id = entryId,
            .created_at = currtime,
            .tags = tags,
            .type = data.OutreachEvent,
            .company = company,
            .link = link,
            .notes = notes,

            // no ledger necessary for resume buckets
            .ledger = null,
            .view = data.resume_bucket{},
        };

        try mgr.entries.append(entry);
        return &mgr.entries.items[mgr.entries.items.len - 1];
    }
};

//
// MARK: Tests for Actions
//  Using the testing.allocator we can simulate the frontend sending payloads over
//

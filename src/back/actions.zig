//
// Implementing Workflow Logic
//
const std = @import("std");
const data = @import("data.zig");

pub const EntryUpdateError = error{InvalidUpdate};

// NOTE: This is probably not great for concurrency,
//  since we'd have to lock the entries and events lists
//  but I guess we can make this concurrent in the future.
pub const Manager = struct {
    allocator: std.mem.Allocator,
    entries: std.ArrayList(data.Entry),
    n_entries: u64,
    n_events: u64,
    initialized: bool,

    pub fn init(self: *Manager) void {
        if (self.initialized) return;
        // set the number of existing entries and the number of existing events
        self.n_entries = self.entries.len;
        self.n_events = 0;
        for (self.entries) |entry| {
            if (entry.ledger) {
                self.n_events += entry.ledger.len;
            }
        }
        self.initialized = true;
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
// MARK: Namespaces for Entry Updates
// NOTE: we don't really need a namespace for resume buckets,
//  since you just submit a resume and that's that.
//

//
// MARK: Job Opening Namespace
//
pub const job_openings = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: ?[][]const u8,
        link: ?[]const u8,
        notes: ?[]const u8,
        // job opening specific
        job_title: []const u8,
    ) !*data.Entry {
        const entry = data.Entry{
            .id = mgr.fresh_entry_id(),
            .created_at = std.time.timestamp(),
            .tags = tags orelse {},
            .type = data.JobOpening,
            .company = company,
            .link = link orelse "",
            .notes = notes orelse "",
            .ledger = std.ArrayList(data.Event),
            .view = data.job_opening{
                .due = null,
                .applied_at = null,
                .job_title = job_title,
                .state = data.pending.LookingAt,
            },
        };

        try mgr.entries.append(entry);
        return &mgr.entries.items[mgr.entries.items.len - 1];
    }

    pub fn apply(mgr: *Manager) !*data.Entry {}
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
        tags: ?[][]const u8,
        link: ?[]const u8,
        notes: ?[]const u8,
        // outreach event specific
        people: ?std.ArrayList(data.Person),
        location: ?data.location,
        scheduled: ?data.time,
    ) !*data.Entry {
        const entry = data.Entry{
            .id = mgr.fresh_entry_id(),
            .created_at = std.time.timestamp(),
            .tags = tags orelse {},
            .type = data.OutreachEvent,
            .company = company,
            .link = link orelse "",
            .notes = notes orelse "",
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
        tags: ?[][]const u8,
        link: ?[]const u8,
        notes: ?[]const u8,
        // coffee chat specific
        people: ?std.ArrayList(data.Person),
        location: ?data.location,
        scheduled: ?data.time,
    ) !*data.Entry {
        const entry = data.Entry{
            .id = mgr.fresh_entry_id(),
            .created_at = std.time.timestamp(),
            .tags = tags orelse {},
            .type = data.OutreachEvent,
            .company = company,
            .link = link orelse "",
            .notes = notes orelse "",
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
    pub fn schedule(mgr: *Manager) !*data.Entry {}
    pub fn complete(mgr: *Manager) !*data.Entry {}
};

//
// MARK: Resume Bucket logic
//
pub const resume_bucket = struct {
    pub fn new(
        mgr: *Manager,
        company: []const u8,
        tags: ?[][]const u8,
        link: ?[]const u8,
        notes: ?[]const u8,
    ) !*data.Entry {
        const entry = data.Entry{
            .id = mgr.fresh_entry_id(),
            .created_at = std.time.timestamp(),
            .tags = tags orelse {},
            .type = data.OutreachEvent,
            .company = company,
            .link = link orelse "",
            .notes = notes orelse "",
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

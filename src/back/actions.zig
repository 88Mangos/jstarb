//
// Implementing Workflow Logic
//
const std = @import("std");
const data = @import("data.zig");

pub const EntryUpdateError = error{InvalidUpdate};

pub const Manager = struct {
    allocator: std.mem.Allocator,
    entries: std.ArrayList(data.Entry),

    pub fn deinit(self: *Manager) void {
        for (self.entries.items) |*entry| {
            entry.deinit(self.allocator); // Free strings and ledger
        }
        self.entries.deinit();
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
    pub fn new(mgr: *Manager) !*data.Entry {
        var entry = data.Entry{};
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
    pub fn new(mgr: *Manager) !*data.Entry {
        var entry = data.Entry{};
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
    pub fn new(mgr: *Manager) !*data.Entry {
        var entry = data.Entry{};
    }
    pub fn schedule(mgr: *Manager) !*data.Entry {}
    pub fn complete(mgr: *Manager) !*data.Entry {}
};

//
// MARK: Resume Bucket logic
//
pub fn resume_bucket_new(mgr: *Manager) !*data.Entry {}

//
// MARK: Tests for Actions
//  Using the testing.allocator we can simulate the frontend sending payloads over
//

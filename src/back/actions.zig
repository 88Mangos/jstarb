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

    //
    // MARK: Add Entries to DB
    //

    pub fn add_job_opening() data.Entry {}
    pub fn add_outreach_event() data.Entry {}
    pub fn add_coffee_chat() data.Entry {}
    pub fn add_resume_bucket() data.Entry {}

    //
    // MARK: Updates
    // NOTE: there are no workflows for updating resume buckets,
    //  since you just submit a resume and that's that.
    //

    //
    // MARK: Update Job Openings
    //

    pub fn update_job_opening() EntryUpdateError!void {}

    // if it's been too long since last new new ledger entry...

    // and we haven't submitted an application to the job_opening,
    //  if there's a due date and it's passed,
    //    Entry.job_opening.state.pending = DeadlinePassed
    //  else,
    //    Entry.job_opening.state.pending = Ignored
    // and we haven't heard back after submitting (including if we've interviewed)
    //  Entry.job_opening.state.noOffer = Ghosted

    //
    // MARK: Update Outreach Events
    //
    pub fn update_outreach_event() EntryUpdateError!void {}

    //
    // MARK: Update Coffee Chats
    //
    pub fn update_coffee_chat() EntryUpdateError!void {}

    //
    // MARK: Query DB Entries for Charts
    //

};

//
// MARK: Tests for Actions
//  Using the testing.allocator we can simulate the frontend sending payloads over
//

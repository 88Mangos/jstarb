//
// The actions taken by a company are in the past tense,
//  e.g., "received" an OA/interview/offer,
//  or (god forbid) "rescinded" an offer.
//
// The actions taken by the user are in the present tense,
//  and by default, actions are from the user,
//  e.g., rescheduling an interview is usually because of the interviewer (company),
//  but the user is responsible for doing that reschedule.
//
//
//
const std = @import("std");
const d = @import("data.zig");

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

pub const position = struct {
    pub fn new() !d.Entry {} // begin tracking
    pub fn update() !void {} // manual user updates

    pub const oa = struct {
        pub fn received() !void {}
        pub fn complete() !void {}
        pub fn ignore() !void {}
    };

    pub const interview = struct {
        pub fn received() !void {}
        pub fn schedule() !void {}
        pub fn reschedule() !void {}
        pub fn complete() !void {}
        pub fn ignore() !void {}
    };

    pub const offer = struct {
        pub fn received() !void {}
        pub fn accept() !void {}
        pub fn reject() !void {}
        pub fn reneg() !void {}
        pub fn rescinded() !void {}
    };

    pub fn rejected() !void {}
    pub fn ghosted() !void {}
};

pub const event = struct {
    pub fn new() !d.Entry {} // begin tracking
    pub fn update() !void {} // manual user updates

    pub const oa = struct {
        pub fn received() !void {}
        pub fn complete() !void {}
        pub fn ignore() !void {}
    };

    pub fn attend() !void {}

    pub fn rejected() !void {}
    pub fn ghosted() !void {}
};

pub const chat = struct {
    pub fn new() !d.Entry {}
    pub fn update() !void {} // manual user updates

    pub fn schedule() !void {}
    pub fn reschedule() !void {}
    pub fn complete() !void {}
};

pub const bucket = struct {
    pub fn new() !d.Entry {}
    pub fn update() !void {} // manual user updates

    pub fn submit() !d.Entry {}
};

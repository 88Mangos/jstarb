//
// Thankfully, structs are lazily declared, so we don't
// have to declare them in dependency order.
//
// TODO: to avoid memory leaks after the storage reader
// loads in the data, we tag all structs that contain
// allocatables with a `deinit` method.
//
const std = @import("std");

// use Unix Times as i64

const Location = []const u8; // right now, locations are just strings.

const Person = struct {
    first_name: []const u8,
    last_name: []const u8,
    phone: ?[]const u8,
    email: ?[]const u8,
    company: ?[]const u8,
    notes: []const u8,
};

//
// MARK: Entry Definition
//

pub const EntryStatus = enum { Pending, Active, Terminal, Discarded };
pub const EntryType = enum { Position, Event, Chat, Bucket };

pub const Entry = struct {
    // metadata
    id: u64,
    created_at: i64,
    tags: [][]const u8,

    // entry data
    title: []const u8,
    type: EntryType,
    status: EntryStatus,
    company: []const u8,

    link: []const u8,
    notes: []const u8,

    ledger: std.ArrayList(Update),

    // EntryType specific information
    info: union(enum) {
        position: PositionInfo,
        event: UpdateInfo,
        chat: ChatInfo,
        bucket: BucketInfo,
    },

    pub fn deinit() !void {}
};

pub const ItemType = enum { OA, Interview, Offer, Resume };
pub const Item = struct {
    type: ItemType,
    created_at: i64,
    deadline: ?i64, // e.g., Offer Deadline, OA due date, Interview scheduled
    notes: []const u8,
};

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
pub const Action = enum {
    // Company Actions
    Received,
    Ghosted,
    Offered,
    Rejected,
    Rescinded,

    // User Actions
    Schedule, // rescheduling is just another Schedule action
    Complete,
    Accept,
    Reject,
    Reneg,
    Submit,
    Ignore,

    // Manual updates
    UpdateEntry,
};

pub const Update = struct {
    id: u64,
    created_at: i64,
    action: Action,
    item: ?Item,
    // using reflection to figure out the function call that created this event

    pub fn deinit() !void {}
};

pub const BucketInfo = struct {
    resumeId: []const u8, // identifier for which resume was submitted
};

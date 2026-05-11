//
// Thankfully, structs are lazily declared, so we don't
// have to declare them in dependency order.
//
// TODO: to avoid memory leaks after the storage reader
// loads in the data, we tag all structs that contain
// allocatables with a `deinit` method.
//
const std = @import("std");

//
// MARK: Generic Data Structures: Time, Location, People
//

const time = i64; // Unix time

const location = []const u8; // right now, locations are just strings.

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

pub const Status = enum { Pending, Active, Terminal, Discarded };
pub const EntryType = enum { Position, Event, Chat, Bucket };

pub const Entry = struct {
    ledger: std.MultiArrayList(Event),

    pub fn init() Entry {}
    pub fn deinit() !void {}
};

pub const Event = struct {
    pub fn init() Event {}
    pub fn deinit() !void {}
};

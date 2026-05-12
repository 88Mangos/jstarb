const std = @import("std");
const data = @import("data.zig");

pub const Manager = struct {
    arena: std.heap.ArenaAllocator,

    // Data Structures from High to Low
    // Positions (job openings), (outreach) Events, (resume) Buckets
    // contain meetings and oas, as well as companies and people.
    positions: std.ArrayListUnmanaged(data.Position),
    events: std.ArrayListUnmanaged(data.Event),
    buckets: std.ArrayListUnmanaged(data.Bucket),

    // Meetings and OAs contain companies and people
    meetings: std.ArrayListUnmanaged(data.Meeting),
    oas: std.ArrayListUnmanaged(data.OA),

    // Companies contain people,
    companies: std.ArrayListUnmanaged(data.Company),
    people: std.ArrayListUnmanaged(data.Person),

    pub fn init() Manager {}
    pub fn deinit(mgr: *Manager) !void {}
};

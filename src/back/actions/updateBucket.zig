const std = @import("std");
const d = @import("../data.zig");
const m = @import("manager.zig");

pub fn new(
    mgr: *m.Manager,
    company: []const u8,
    link: []const u8,
    resumeId: []const u8,
) !*d.Entry {
    var t = try mgr.newEntry();
    t.type = .Bucket;
    t.company = company;
    t.link = link;
    t.info = .bucket{ .resumeId = resumeId };

    return t;
}

pub fn submit(mgr: *m.Manager, t: *d.Entry) !void {
    var u = mgr.newUpdate();
    u.verb = .Submit;
    u.item = .Resume;

    try t.ledger.append(u);
    return;
}

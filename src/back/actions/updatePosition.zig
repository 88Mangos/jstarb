const std = @import("std");
const d = @import("../data.zig");
const m = @import("manager.zig");

pub fn new() !d.Entry {} // begin tracking

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

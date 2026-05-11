const std = @import("std");
const d = @import("../data.zig");
const m = @import("manager.zig");

pub fn new() !d.Entry {} // begin tracking

pub const oa = struct {
    pub fn received() !void {}
    pub fn complete() !void {}
    pub fn ignore() !void {}
};

pub fn attend() !void {}

pub fn rejected() !void {}
pub fn ghosted() !void {}

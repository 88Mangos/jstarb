const std = @import("std");
const d = @import("../data.zig");
const m = @import("manager.zig");

pub fn new() !d.Entry {}

pub fn schedule() !void {}
pub fn reschedule() !void {}
pub fn complete() !void {}

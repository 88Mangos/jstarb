const std = @import("std");
const d = @import("../data.zig");
const m = @import("manager.zig");

pub fn new() !d.Entry {}
pub fn update() !void {} // manual user updates

pub fn submit() !d.Entry {}

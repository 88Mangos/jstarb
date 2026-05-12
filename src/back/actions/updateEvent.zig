const std = @import("std");
const data = @import("../data.zig");
const m = @import("../manager.zig");

pub fn new(mgr: *m.Manager) !usize {}
pub fn apply(mgr: *m.Manager, b: usize) !void {}
pub fn oa_received(mgr: *m.Manager, b: data.EntryContext) !void {}
pub fn oa_extended(mgr: *m.Manager, b: data.EntryContext) !void {}
pub fn oa_complete(mgr: *m.Manager, b: usize) !void {}
pub fn interview_received(mgr: *m.Manager, b: usize) !void {}
pub fn interview_scheduled(mgr: *m.Manager, b: usize) !void {}
pub fn interview_rescheduled(mgr: *m.Manager, b: usize) !void {}
pub fn interview_complete(mgr: *m.Manager, b: usize) !void {}
pub fn offer_received(mgr: *m.Manager, b: usize) !void {}
pub fn offer_accepted(mgr: *m.Manager, b: usize) !void {}
pub fn offer_rejected(mgr: *m.Manager, b: usize) !void {}
pub fn offer_reneged(mgr: *m.Manager, b: usize) !void {}
pub fn offer_rescinded(mgr: *m.Manager, b: usize) !void {}
